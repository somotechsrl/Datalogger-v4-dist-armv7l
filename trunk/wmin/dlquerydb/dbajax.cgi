#!/bin/bash

echo -e "Content-Type: text/json;\n"

# sets variables from query string
for v in $(sed 's/[&]/\n/g' <<< $QUERY_STRING); do
	vname=$(cut -d '=' -f 1 <<< $v);
	value=$(cut -d '=' -f 2 <<< $v);
	eval $vname=$value
	done
	
cd /opt/datalogger-v4

echo  "{ \"data\" : ["
api/db-moduledata $m $d $f $t| bin/CSVRow2JSON -v separator="|" -v columns="datetime timestamp $c" 2>&1
echo -e "\n]}"
