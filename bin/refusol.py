#!/usr/bin/python
# -*- coding: utf8 -*-

# (c) Studiorizzi dot net
# Module for inverter REFUSOL
# Handles TCP and Serial connections

import os, sys, logging, struct, time, select, string, socket
from optparse import OptionParser
from utils import ByteToHex, ByteToInt, ByteToFloat
from utils import IntTo1Byte, IntTo2Byte, HexToByte, IntToBin

AGENT_VERSION		= '1.0'
LOG_FORMAT			= 'Log|%(asctime)s|%(message)s'
MAX_RESPONSE_TIME	= 1.0		# time to wait for the reply packet (in seconds)
MAX_TIMEOUT			= 60 * 5	# timeout: after that we set data to zero (in seconds)

ser			= None  # handler of the opened serial device (Serial/Socket)
parser		= None  # argument parser object (OptionParser)
logger		= None  # the logging object

# We don't want traceback
sys.tracebacklimit = 0

#-------------------------------------------------------------------------------
#------  DATA_MAPS  ------------------------------------------------------------
#-------------------------------------------------------------------------------
inverter_data_map = [
#	PNU	IDX	 fieldName		 USStype	fieldType	mult	unit
	(500,  0,	 'Error',		  'i32',	 'i',		 1,	  ''),
	(501,  0,	 'Status',		 'i32',	 'i',		 1,	  ''),

	(1150, 0,	 'DailyEnergy',  'i32',	 'F',		 0.1,	'kW/h'),
	(1151, 0,	 'TotalEnergy',  'i32',	 'F',		 0.1,	'kW/h'),
	(1152, 0,	 'LifeTime',	  'i32',	 'i',		 1,	  'h'),

	# (92,	0,	 'Temp1',		  'i32',	 'i',		 1,	  'C'),
	# (92,	1,	 'Temp2',		  'i32',	 'i',		 1,	  'C'),
	# (92,	2,	 'Temp3',		  'i32',	 'i',		 1,	  'C'),
	# (92,	3,	 'Temp4',		  'i32',	 'i',		 1,	  'C'),
	(1191, 0,	 'Irradiation',  'i32',	 'i',		 1,	  'W/mq'),
	(1193, 0,	 'Temperature',  'f32',	 'F',		 1,	  'C'),

	(1104, 0,	 'DCVoltage',	 'f32',	 'F',		 1,	  'V'),
	(1105, 0,	 'DCCurrent',	 'f32',	 'F',		 1,	  'A'),
	(1107, 0,	 'DCPower',		'f32',	 'F',		 0.001, 'kW'),

	# (1102, 0,	 'OutVoltage',	'f32',	 'F',		 1,	  'V'),
	(1123, 0,	 'ACVoltage',	 'f32',	 'F',		 1,	  'V'),
	(1121, 0,	 'ACVoltageR',	'f32',	 'F',		 1,	  'V'),
	(1121, 1,	 'ACVoltageS',	'f32',	 'F',		 1,	  'V'),
	(1121, 2,	 'ACVoltageT',	'f32',	 'F',		 1,	  'V'),

	# (1103, 0,	 'ACCurrent',	 'f32',	 'F',		 1,	  'A'),
	(1124, 0,	 'ACCurrent',	 'f32',	 'F',		 1,	  'A'),
	(1141, 0,	 'ACCurrentR',	'f32',	 'F',		 1,	  'A'),
	(1141, 1,	 'ACCurrentS',	'f32',	 'F',		 1,	  'A'),
	(1141, 2,	 'ACCurrentT',	'f32',	 'F',		 1,	  'A'),
	(1106, 0,	 'ACPower',		'f32',	 'F',		 0.001, 'kW'),

	(1122, 0,	 'ACFrequencyR',	'f32',	 'F',		 1,	  'Hz'),
	(1122, 1,	 'ACFrequencyS',	'f32',	 'F',		 1,	  'Hz'),
	(1122, 2,	 'ACFrequencyT',	'f32',	 'F',		 1,	  'Hz'),
]

inverter_states = {
	0: 'Init',
	1: 'PowerOff',
	2: 'Starting',
	3: 'Connecting',
	4: 'Running',
	5: 'ShutDown',
	6: 'Error',
	7: 'Fail - Fatal Error'
}

#-------------------------------------------------------------------------------
#------  Logger ----------------------------------------------------------------
#-------------------------------------------------------------------------------
def LOG(message):
	"""
	Print the given messagge on standard output or append to the log file
	"""
	logger.error(message)

def OUT(message):
	"""
	Print the given messagge on standard output or append to the log file
	"""
	print message

def DBG(message):
	"""
	Print the given messagge on standard output (only if verbose mode enabled)
	"""
	if opts.verbose: logger.error(message)

def DBG_PACKET(message):
	"""
	Print the given messagge on standard output (only if --packets enabled)
	This is used to debug all the sent/received packets
	"""
	if opts.packets: logger.error(message)

def DBG_DATA(message):
	"""
	Print the given messagge on standard output (only if --datas enabled)
	This is used to debug all the data acquired
	"""
	if opts.datas: logger.error(message)


#-------------------------------------------------------------------------------
#------  Packet Class ----------------------------------------------------------
#-------------------------------------------------------------------------------
class Packet:
	"""
	The Packet class can be used to send or receive a single packet in the USS
	format: STX, LGE, ADR, net data block, BCC

	To send:
		p = Packet(dst_address='XXXX', control_code='XX', ...)
		p.send()
		p.receive()
	"""
	STX = None  # 1 byte (always 0x02)
	LGE = None  # 1 byte (USS 4/6 - 22 bytes)(always 0x16)
	ADR = None  # 1 byte (rs485 address)
	PKE = None  # 2 bytes (AK+0+PNU)
	IDX = None  # 2 bytes (array index)
	PWE = None  # 4 bytes (response value)
	PZD = None  # 12 bytes (not used)
	BCC = None  # 1 byte (checksum)
	error = False

	def __init__(self, addr, pnu, idx = None):
		
		self.STX = HexToByte('02')
		self.LGE = HexToByte('16')
		self.ADR = IntTo1Byte(addr)
		#			 AK  r	  PNU
		# 4096  = 0001 0 000 0000 0000 = request single val
		# 24576 = 0110 0 000 0000 0000 = request array val
		if idx: pke = pnu + 24576
		else:	pke = pnu + 4096
		self.PKE = IntTo2Byte(pke) # TODO FIXME
		self.IDX = IntTo2Byte(idx or 0) # TODO checkme
		self.PWE = HexToByte('00 00 00 00')
		self.PZD = HexToByte('00 00 00 00 00 00 00 00 00 00 00 00')
		self.BCC = self.calc_checksum()
		error = False

	def __str__(self):
		if self.error: return '<Packet ERROR>'
		return '<Packet STX=%s LGE=%s(%d) ADR=%s(%d) PKE=%s IDX=%s(%d) PWE=%s PZD=%s BCC=%s>' % (
			ByteToHex(self.STX),
			ByteToHex(self.LGE), ByteToInt(self.LGE),
			ByteToHex(self.ADR), ByteToInt(self.ADR),
			ByteToHex(self.PKE),
			ByteToHex(self.IDX), ByteToInt(self.IDX),
			ByteToHex(self.PWE),
			ByteToHex(self.PZD),
			ByteToHex(self.BCC)
			)

	def send(self):
		"""
		Send the packet using the opened 'ser' handler.
		"""
		buf = self.STX + self.LGE + self.ADR + self.PKE + self.IDX + \
				self.PWE + self.PZD + self.BCC
		try:
			ser.write(buf)
		except:
			LOG('ERROR: Canont Write to comm channel...')
			self.error = True
		else:
			self.error = False

		DBG_PACKET('SENT:	  "' + ByteToHex(buf, ' ') + '"')
		return not self.error

	def send_and_receive(self):
		self.send()
		self.receive()

	def receive(self, log_no_packet_received = True):
		"""
		Receive a single packet using the opened 'ser' handler.
		This also check the checksum for packet integrity
		"""
		# self.clear()
		self.error = True
		received = ''
		
		try:

			if opts.serial_device:
			
				# check if we have data to read
				if ser.inWaiting() < 1:
					if log_no_packet_received:
						LOG('ERROR: NO PACKETS')
						return False

				# read data
				while ser.inWaiting():
					received += ser.read(ser.inWaiting())			
			else:

				# we expect 24 chars...
				received = ser.read(24)
				DBG_PACKET('RECEIVED: "' + ByteToHex(received, ' ') + '"')

			if not received:
				LOG('ERROR: NO DATA Received')
				return False
			
		except socket.error, msg:
			LOG("ERROR: Socket %s" % msg)
			return False
			

		# check length & header
		if len(received) != 24 or ByteToHex(received[0]) != '02':
			LOG('ERROR: Wrong packet Header (%s)' % ByteToHex(received[0]))
			return False

		# 'parse' fields
		self.STX = received[0]		# 1 byte (always 0x02)
		self.LGE = received[1]		# 1 byte (USS 4/6 - 22 bytes)(always 0x16)
		self.ADR = received[2]		# 1 byte (rs485 address -- always 0 for tcp driver)
		self.PKE = received[3:5]	# 2 bytes (AK+0+PNU)
		self.IDX = received[5:7]	# 2 bytes (array index)
		self.PWE = received[7:11]	# 4 bytes (response value)
		self.PZD = received[11:23]	# 12 bytes (not used)
		self.BCC = received[23]		# 1 byte

		# validate the checksum
		if self.calc_checksum() != self.BCC:
			LOG('ERROR: Wrong packet checksum (%s - %s)' %
				(ByteToHex(self.BCC), ByteToHex(self.calc_checksum())))
			return False

		self.error = False
		return True

	def calc_checksum(self):
		"""
		Calc the checksum of the packet, calculated using the object fields, 1 bytes
		"""
		bcc = 0
		bcc = bcc ^ ByteToInt(self.STX)
		bcc = bcc ^ ByteToInt(self.LGE)
		bcc = bcc ^ ByteToInt(self.ADR)
		for char in self.PKE:
			bcc = bcc ^ ByteToInt(char)
		for char in self.IDX:
			bcc = bcc ^ ByteToInt(char)
		for char in self.PWE:
			bcc = bcc ^ ByteToInt(char)
		for char in self.PZD:
			bcc = bcc ^ ByteToInt(char)

		return IntTo1Byte(bcc)

def GetInverterData(addr):
	LOG('Querying Inverter: %d' % (addr))

	for (pnu, idx, fieldName, USStype, fieldType, mult, unit) in inverter_data_map:
		p = Packet(addr=addr, pnu=pnu, idx=idx)
		p.send_and_receive()
		if p.error:
		  OUT("NODATA")
		  LOG('WARNING: NO Data - timeout ?')
		  return

		# convert value from the correct format
		if USStype == 'f32':
			val = ByteToFloat(p.PWE)
		elif USStype == 'i32':
			val = ByteToInt(p.PWE)

		# apply multiplicator
		if mult != 1:
			val *= mult

		if fieldName == 'Status':
			OUT('%s_descr: %s %s' % (fieldName, inverter_states[val],unit))
		else:
			# Sends output
			OUT('%s: %s %s' % (fieldName, str(val),unit))

 
#------------------------------------------------------------------------------
#------  MAIN  -----------------------------------------------------------------
#-------------------------------------------------------------------------------

# parse command line options
parser = OptionParser(
	version=AGENT_VERSION,
	usage='%prog <-f /dev/ttySX | -t addr> -a 1,2,3 [options]',
	description='REFUSOL driver V'+AGENT_VERSION
	)
	
parser.add_option('-f', '--serial-device', type='string', default=None,help='Serial port device, es /dev/ttyS2')
parser.add_option('-t', '--tcp-address', type='string', default=None,help='TCP/IP address')
parser.add_option('-a', '--inverter-addresses', type='string', default=None,help='Comma separated addresses (1,2,3,...)')
parser.add_option('-l', '--log-file', default=None,help='Log File path (default: stdout)')
parser.add_option('-v', '--verbose', action='store_true', default=False,help='Verbose running')
parser.add_option('-p', '--packets', action='store_true', default=False,help='Show all I/O packets')
parser.add_option('-d', '--datas', action='store_true', default=False,help='Show All data')
(opts, args) = parser.parse_args()

if (not opts.serial_device and not opts.tcp_address) or not opts.inverter_addresses:
	parser.print_help()
	sys.exit(1)

# setup logging
logging.basicConfig(format=LOG_FORMAT, filename=opts.log_file)
logger = logging.getLogger('')
LOG('REFUSOL Driver - V'+AGENT_VERSION)

if opts.serial_device:
	# open the serial port
	try:
		devname=opts.serial_device
		ser = serial.Serial(port=opts.serial_device, baudrate=9600,
			parity=serial.PARITY_EVEN, stopbits=serial.STOPBITS_ONE,
			bytesize=serial.EIGHTBITS, timeout=MAX_RESPONSE_TIME)
		ser.open()
	except ValueError as e:
		LOG('ERROR: Can\'t open "%s: %s => %s"' % (opts.serial_device,e.errno,e.strerror))
		sys.exit(1)
	else:
		LOG('OK: Port "%s" opened' % (opts.serial_device))

if opts.tcp_address:
	# open the emulated serial port
	try:
		devname=opts.tcp_address
		ser = serial.serial_for_url("socket://"+opts.tcp_address+":21062");
		ser.timeout=100
	except ValueError as e:
		LOG('ERROR: Can\'t connect to "%s: %s => %s"' % (opts.tcp_address,e.errno,e.strerror))
		sys.exit(1)
	else:
		LOG('OK: Connected to "%s"' % (opts.tcp_address))

addrs = opts.inverter_addresses.split(',')

# main
for addr in addrs:
  #OUT("BEGIN %s %s %s" % (devname,addr,int(time.time())))
  GetInverterData(int(addr))
  #OUT("END %s %s %s" % (devname,addr,int(time.time())))


# release the serial port and exit succesfully
ser.close()
sys.exit(0)

