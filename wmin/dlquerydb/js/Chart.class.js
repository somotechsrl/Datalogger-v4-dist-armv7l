class ChartJs_Base {

	// Normalizer for ChartJs -- generates labels and data and returns right format
	static normalizeData (data,xkey) {
			
		// each data -- we want colmns ordere by formatter array...
		// data are organized as rowkey : {key:value}
		var values = [];
		var ykeys = {};
		var labels = [];
		
		// check xkey
		if(typeof xkey=='undefined') xkey=null;
		
		// no data'??
		if(data == null) return;
		//console.log(data);
		
		// first extracts and counts all data keys
		var nk=0;
		jQuery.each(data, function(rowkeys,rowdata) {
			jQuery.each(rowdata,function(k,v) {
				if(k=='autofill') return;
				if(k!=xkey && typeof ykeys[k] == 'undefined') ykeys[k]=nk++;
				});
			});
		console.log(ykeys);
		console.log(nk);

		// generates color palette
		var colors = palette('tol-rainbow',nk).map(function(hex) {
			return '#'+hex
			});

		// generates sortable array
		var akeys = Array(nk);
		jQuery.each(ykeys,function(k,i) {
			akeys[i]=k;
			});
		akeys.sort();
		//console.log(nk);
				
		// generates datasets (one for each ykey)
		var datasets = new Array(akeys.length);
		//console.log(akeys);
		jQuery.each(akeys,function(i,ykey) {
			if(xkey==null) labels.push(ykey);
			datasets[i] = {
				fill: false,
				lineTension: 0,
				borderColor: colors[i],
				backgroundColor: colors[i],
				label: ykey,
				data: new Array(),
				};
			});
			
		// extracts data and organizes by ykey
		jQuery.each(data, function(rowkeys,rowdata) {
			if(xkey!=null) labels.push(rowdata[xkey]);
			jQuery.each(akeys,function(i,ykey) {
				datasets[i].data.push(rowdata[ykey]);
				});
			});
			
		// assemble result
		var result = {
			labels: labels,
			datasets: datasets,
			};
		
		//console.log(result);
		
		return result;
		}
			
	}
