<html>
<head>
  <link rel="stylesheet" href="styles.css">
  <script type="text/javascript" src="js/runOnLoad.min.js"></script>
  <script type="text/javascript" src="js/CollapsibleLists.min.js"></script>
    <script type="text/javascript">
      runOnLoad(function(){ CollapsibleLists.apply(); });
    </script>
</head>
	<body>
	<?
		// gets username from included subsys
		if (isset($_COOKIE['verify'])) include("password.php");
		
		$status=array(
			#"sethttpdate" => "Data e Ora",
			"status" => "Stato Datalogger",
			"drList" => "Drivers Disponibili",
			"lastData" => "Ultime Letture Dati",
			"drCommands" => "Comandi Interattivi",
			);

		$system=array(
			"netStatus" => "Rete",
			"vpnStatus" => "VPN",
			"psStatus" => "Processi",
			"dmesg" => "Messaggi Kernel",
			);	
	
		 $sysutils=array(
			"reboot" 		=> "Reboot",
			"forceDLRun"	=> "Forza Datalogging",
			"setdate" 		=> "Data da Internet",
			"scan_mbgates" 	=> "Scan MBGateways&reg;",
			"svnupdate" 	=> "Aggiornamento Firmware",
			);

		 $sysconfig=array(
			"setinterfaces" => "Rete",
			"showTarget" 	=> "Generale",
			"configDL" 		=> "Periferiche",
			);

		 $super=array(
			"setpackages" => "Packages",
			);

		$reports=array(
			#"DownloadDb" => "Scarica",
			"showDb" => "Tutti i Dati",
			"showDbShort" => "Formato Sintetico",
			);
				
	?>
	<h2>
		LoggerBox<br>System<br>(Orange)
	</h2>
	<ul class="collapsibleList">
		<li><a href="/login.php" target="destra">Login</a> </li>
		<li><a href="/logout.php" target="destra">Logout</a> </li>
		<li>Informazioni
			<ul>
				<?
				foreach($status as $scrpt => $descr) {
					echo "<li><a href='/wrapper.tpl.php?s=$scrpt&d=$descr' target='destra'>$descr</a></li>";
					}
				?>
			</ul>
		</li>
		<li>Stato Sistema
			<ul>
				<?
				foreach($system as $scrpt => $descr) {
					echo "<li><a href='/wrapper.tpl.php?s=$scrpt&d=$descr' target='destra'>$descr</a></li>";
					}
				?>
			</ul>
		</li>
		<? if(isset($username) && $username=="admin") { ?>
		<li>Utilita' Sistema
			<ul>
				<?
				foreach($sysutils as $scrpt => $descr) {
					echo "<li><a href='/wrapper.tpl.php?s=$scrpt&d=$descr' target='destra'>$descr</a></li>";
					}
				?>
			</ul>
		</li>
		<li>Configurazione Sistema
			<ul>
				<?
				foreach($sysconfig as $scrpt => $descr) {
					echo "<li><a href='/wrapper.tpl.php?s=$scrpt&d=$descr' target='destra'>$descr</a></li>";
					}
				?>
			</ul>
		</li>
		<? } ?>
		<? if (isset($username) && $username=="super") { ?>
		<li>Modifica Opzioni
			<ul>
				<?
				foreach($super as $scrpt => $descr) {
					echo "<li><a href='/wrapper.tpl.php?s=$scrpt&d=$descr' target='destra'>$descr</a></li>";
					}
				?>
			</ul>
		</li>
		<? } ?>
		<? //if(file_exists("/opt/datalogger/db")) { ?>
		<li>Database Locale
			<ul>
				<?
				foreach($reports as $scrpt => $descr) {
					echo "<li><a href='/wrapper.tpl.php?s=$scrpt&d=$descr' target='destra'>$descr</a></li>";
					}
				?>
			</ul>
		</li>
		<? //} ?>
	</ul>
	</body>
</html>
