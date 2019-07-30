<?

	header("Content-type: text/plain");

	$errors=0;
	$errlist="";
	$setvar = array();
	
	$expectedvars=array("module","key","opcode","data");

	foreach($expectedvars as $v) {
		
		if(isset($_GET[$v])) $setvar[$v]=$_GET[$v];
		if(isset($_POST[$v])) $setvar[$v]=$_POST[$v];
		
		if(!isset($setvar[$v]) || $setvar[$v ]=="") {
			$errors++;
			$errlist.="KO: Parameter $v not set\n";
			}
		}
		
	// object
	$o = (object) $setvar;
	
	// verifies key
	$keybase=date("Y m d H");
	$check_key=md5($keybase);
	if(isset($o->key) && $o->key!="" && $check_key!=$o->key) {
		$errors++;
		$errlist.="KO: Wrong key $keybase:$check_key:".$o->key."\n";
		}
	if($errors) {
		echo "$errlist\nKO: $errors errors found.\n";
		return;
		}

	// ok...
	printf("OK: Executing API command on %s\n",$_SERVER["SERVER_NAME"]);
	printf("API_STDOUT|%s|%s|%s|%s\n",$o->key,$o->module,$o->opcode,$o->data);
	$result=shell_exec(sprintf("sudo -n /opt/datalogger/api/%s '%s' '%s'",$o->module,$o->opcode,$o->data));
	if(!$result || $result=="") 
		echo "KO: No results from command $o->module\n";
	else
		echo $result;
	printf("API_STDOUT_END|%s|%s|%s|%s\n",$o->key,$o->module,$o->opcode,$o->data);

?>
