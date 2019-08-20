#!/bin/bash

TBL=$1
URL=$2
PLN=$3

[ -z "$PLN" ] && PLN=16
[ -n "$URL" ] && XURL="ajax: '$URL',"

PL2N=$(( $PLN  * 2 ))
PL4N=$(( $PLN  * 4 ))

cat << EOT
<link rel='stylesheet' type='text/css' href='js/jquery.dataTables.min.css'>
<link rel='stylesheet' type='text/css' href='js/buttons.dataTables.min.css'>
<link rel='stylesheet' type='text/css' href='js/responsive.dataTables.min.css'>
<script type='text/javascript' language=javascript src='js/jquery-1.12.4.js'></script>
<script type='text/javascript' language=javascript src='js/jquery.dataTables.min.js'></script>
<script type='text/javascript' language=javascript src='js/dataTables.buttons.min.js'></script>
<script type='text/javascript' language=javascript src='js/dataTables.responsive.min.js'></script>
<script type='text/javascript' language=javascript src='js/buttons.flash.min.js'></script>
<script type='text/javascript' language=javascript src='jsjszip.min.js'></script>
<script type='text/javascript' language=javascript src='js/pdfmake.min.js'></script>
<script type='text/javascript' language=javascript src='js/vfs_fonts.js'></script>
<script type='text/javascript' language=javascript src='js/buttons.html5.min.js'></script>
<script type='text/javascript' language=javascript src='js/buttons.print.min.js'></script>

<script>
jQuery(document).ready( function () {
	var table=jQuery('#$TBL').DataTable({
        dom: 'lfrtpBi',
 		responsive: true,
 		$XURL
		lengthMenu: [ [$PLN, $PL2N, $PL4N, -1], [$PLN, $PL2N, $PL4N, "All"] ],
        pageLength: $PLN,
		oLanguage: {
			sSearch: "_MENU_",
			sLengthMenu: "Records/Page: _MENU_",
			},
		//paging: false,
	    bFilter : false,

		//scrollY: "32em",		
		//scrollCollapse: false,
		
        buttons: [
            'copy',
            'print', 
			{
				extend: 'csv',
				filename: 'export'
				}, 
			{
				extend: 'excel',
				filename: 'export'
				}, 
            // , 'pdf', 'print'
			],

	    
	  "columnDefs": [
			{ className: "dt-left", "targets": [ $left ] },
			{ className: "dt-center", "targets": [ $center ] },
			{ className: "dt-right", "targets": [ $right ] },
			],
			
      });

	var updated=document.getElementById("updated");
	if(updated !== null) {
		setInterval( function () {
			table.ajax.reload(null,false);
			updated.innerHTML = new Date;
			},30000 );
			
		updated.innerHTML = new Date;
		}
	});
</script>
EOT
