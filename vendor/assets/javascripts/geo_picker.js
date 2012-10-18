{
		
	/**
	 * Internal state vars.
	 */
	var config;
	var geoWindow;
	    
	
				
	/**
	 * Main, public API function.
	 */
	function myGeoPositionGeoPicker(configObj) {
		
		/**
		 * Check for config data and store in specific var
		 */
		if (typeof configObj != 'object') {
			return;
		}
		config = configObj;
		
		
		/**
		 * Get page META information
		 */
		var metaWindowTitle = '';
		var metaTitle = '';
		var metaDescription = '';
		var metaKeywords = '';
		if (document.getElementsByTagName) {
			var metatags = document.getElementsByTagName("meta");
			for (var i = 0; i < metatags.length; i++) {
				if (metatags[i].getAttribute('name') && metatags[i].getAttribute('name').toLowerCase() == 'title') {
					metaTitle = metatags[i].getAttribute('content');
				}
				if (metatags[i].getAttribute('name') && metatags[i].getAttribute('name').toLowerCase() == 'description') {
					metaDescription = metatags[i].getAttribute('content');
				}
				if (metatags[i].getAttribute('name') && metatags[i].getAttribute('name').toLowerCase() == 'keywords') {
					metaKeywords = metatags[i].getAttribute('content');
				}
			}
			if (document.getElementsByTagName("title").length > 0 && document.getElementsByTagName("title")[0].innerHTML) {
				metaWindowTitle = document.getElementsByTagName("title")[0].innerHTML
			}
		}
		
		
		
		/**
		 * Prepare some vars
		 */
		var id = mgpGenerateId(document.location.hostname + document.location.pathname);
		if (typeof config.startPositionInputFieldIds == 'object' && config.startPositionInputFieldIds.length > 0) {
			config.startAddress = '';
			for (var i = 0; i < config.startPositionInputFieldIds.length; i++) {
				if (document.getElementById(config.startPositionInputFieldIds[i])) {
					config.startAddress += document.getElementById(config.startPositionInputFieldIds[i]).value + ', ';
				}
			}
		}
		
		
		
		/**
		 * Create iframe URL
		 */
		var iframeUrl = 'http://api.mygeoposition.com/api/geopicker/id-' + id + '/?';
		function addToUrl(name, value) {
			if (value) {
				iframeUrl = iframeUrl + "&" + name + "=" + escape(value);
			}
		}
		addToUrl('startAddress', config.startAddress);
		addToUrl('startPositionLat', config.startPositionLat);
		addToUrl('startPositionLng', config.startPositionLng);
		addToUrl('autolocate', config.autolocate);
		addToUrl('locateme',config.locateme);
		addToUrl('zoomLevel', config.zoomLevel);
		addToUrl('mapType', config.mapType);
		addToUrl('showStartupInfoWindow', config.showStartupInfoWindow);
		addToUrl('showResultInfoWindow', config.showResultInfoWindow); 		
		addToUrl('returnUrl', document.location.href);
		addToUrl('langCode', config.langCode);
		addToUrl('langButtonSearch', config.langButtonSearch);
		addToUrl('langButtonReturn', config.langButtonReturn);
		addToUrl('langMarkerInfo', config.langMarkerInfo);
		addToUrl('langSearchField', config.langSearchField);
		addToUrl('langLookupFailed', config.langLookupFailed);
		addToUrl('langLookupNoResults', config.langLookupNoResults);
		addToUrl('backgroundColor', config.backgroundColor);
		addToUrl('windowTitle', config.windowTitle);
		addToUrl('metaWindowTitle', metaWindowTitle);
		addToUrl('metaTitle', metaTitle);
		addToUrl('metaDescription', metaDescription);
		addToUrl('metaKeywords', metaKeywords);		
		
		
		
		/**
		 * Open external window and connect to API server via iframe
		 */
		geoWindow = window.open("", "MGPGeoPickerWindow", "width=488,height=518,location=no,menubar=no,resizable=no,status=no,toolbar=no");
		geoWindow.focus();
		geoWindow.document.write("<html><head><title>");
		geoWindow.document.write(config.windowTitle ? config.windowTitle : (metaWindowTitle ? metaWindowTitle : 'MygeoPosition.com GeoPicker'));
		geoWindow.document.write("</title></head><body style=\"padding:0px;margin:0px;\">");
		geoWindow.document.write("<iframe src=\"" + iframeUrl + "\" width=488 height=518 border=0 frameborder=0 style=\"padding:0px;margin:0px;\"></iframe>");
		geoWindow.document.write("<script type=\"text/javascript\" src=\"http://api.mygeoposition.com/api/geopicker/popup.js\"></script>");
		geoWindow.document.write("</body></html>");
		
	}
	    
	
				
	/**
	 * Process result data as configured by user.
	 */
	function mgpReturnResult(data) {
		
		// Create object from string result
		var resultObj = JSON.parse(data);
		
		// Return data in case of one field only
		if (config.returnFieldId && config.returnValueTemplate && document.getElementById(config.returnFieldId)) {
			document.getElementById(config.returnFieldId).value = mgpFillTemplate(config.returnValueTemplate, resultObj);
		}
		
		// Return data in case field mapping exists
		else if(config.returnFieldMap && typeof config.returnFieldMap == 'object') {
			for(var key in config.returnFieldMap) {
				var documentId = key; 
				var template = config.returnFieldMap[key];
				if (document.getElementById(documentId)) {
					document.getElementById(documentId).value = mgpFillTemplate(template, resultObj);
				}
			}
			
		}
		
		// Return data in case callback exists
		else if(config.returnCallback) {
			window[config.returnCallback](resultObj);
			
		}
		
		else {
			alert("No return field(s) specified!");
		}
		
	}

	
	
	/**
	 * Parse and process a result template.
	 */
	function mgpFillTemplate(template, resultObj) {
		
			var result = template;
			
			result = result.replace(/<LAT>/gi, resultObj.lat);
			result = result.replace(/<LNG>/gi, resultObj.lng);
			
			result = result.replace(/<LAT_MIN>/gi, resultObj.latMin);
			result = result.replace(/<LNG_MIN>/gi, resultObj.lngMin);
			
			result = result.replace(/<ADDRESS>/gi, resultObj.address);
			
			result = result.replace(/<COUNTRY>/gi, resultObj.country.short);
			result = result.replace(/<COUNTRY_LONG>/gi, resultObj.country.long);
			
			result = result.replace(/<STATE>/gi, resultObj.state.short);
			result = result.replace(/<STATE_LONG>/gi, resultObj.state.long);
			
			result = result.replace(/<DISTRICT>/gi, resultObj.district.short);
			result = result.replace(/<DISTRICT_LONG>/gi, resultObj.district.long);
			
			result = result.replace(/<CITY>/gi, resultObj.city.short);
			result = result.replace(/<CITY_LONG>/gi, resultObj.city.long); 
			
			result = result.replace(/<SUBURB>/gi, resultObj.suburb.short);
			result = result.replace(/<SUBURB_LONG>/gi, resultObj.suburb.long);
			
			result = result.replace(/<POSTALCODE>/gi, resultObj.postalCode.short);
			result = result.replace(/<POSTALCODE_LONG>/gi, resultObj.postalCode.long);
			
			result = result.replace(/<ZIP>/gi, resultObj.postalCode.short);
			result = result.replace(/<ZIP_LONG>/gi, resultObj.postalCode.long);
			
			result = result.replace(/<STREET>/gi, resultObj.street.short)
			result = result.replace(/<STREET_LONG>/gi, resultObj.street.long);
			
			result = result.replace(/<STREETNUMBER>/gi, resultObj.streetNumber.short);
			result = result.replace(/<STREETNUMBER_LONG>/gi, resultObj.streetNumber.long);
			
			result = result.replace(/<STREETNO>/gi, resultObj.streetNumber.short);
			result = result.replace(/<STREETNO_LONG>/gi, resultObj.streetNumber.long);
			
			return result;		
	}

	
	
	/**
	 * Generate quite unique app user id
	 */
	function mgpGenerateId(data) {
        data = data.replace(/http:\/\//g, "");
        data = data.replace(/www/g, "");
        data = data.replace(/\//g, "");
        data = data.replace(/\./g, "");
        data = data.replace(/\?/g, "");
        data = data.replace(/_/g, "");
        data = data.replace(/-/g, "");
        data = data.replace(/&/g, "");
        data = data.replace(/=/g, "");
        data = data.replace(/a/g, "v");
        data = data.replace(/e/g, "x");
        data = data.replace(/i/g, "y");
        data = data.replace(/o/g, "z");
        data = data.replace(/u/g, "q"); 
        data = data.replace(/#/g, "");		
		result = '';
		result += data.substr(0, 15);
		result += data.substr(data.length - 13, 10);
        return result;
    }
	
	
	
	/**
	 * JSON2.js
	 */
	
	if(!this.JSON){this.JSON={};}
	(function(){function f(n){return n<10?'0'+n:n;}
	if(typeof Date.prototype.toJSON!=='function'){Date.prototype.toJSON=function(key){return isFinite(this.valueOf())?this.getUTCFullYear()+'-'+
	f(this.getUTCMonth()+1)+'-'+
	f(this.getUTCDate())+'T'+
	f(this.getUTCHours())+':'+
	f(this.getUTCMinutes())+':'+
	f(this.getUTCSeconds())+'Z':null;};String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(key){return this.valueOf();};}
	var cx=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,escapable=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,gap,indent,meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'},rep;function quote(string){escapable.lastIndex=0;return escapable.test(string)?'"'+string.replace(escapable,function(a){var c=meta[a];return typeof c==='string'?c:'\\u'+('0000'+a.charCodeAt(0).toString(16)).slice(-4);})+'"':'"'+string+'"';}
	function str(key,holder){var i,k,v,length,mind=gap,partial,value=holder[key];if(value&&typeof value==='object'&&typeof value.toJSON==='function'){value=value.toJSON(key);}
	if(typeof rep==='function'){value=rep.call(holder,key,value);}
	switch(typeof value){case'string':return quote(value);case'number':return isFinite(value)?String(value):'null';case'boolean':case'null':return String(value);case'object':if(!value){return'null';}
	gap+=indent;partial=[];if(Object.prototype.toString.apply(value)==='[object Array]'){length=value.length;for(i=0;i<length;i+=1){partial[i]=str(i,value)||'null';}
	v=partial.length===0?'[]':gap?'[\n'+gap+
	partial.join(',\n'+gap)+'\n'+
	mind+']':'['+partial.join(',')+']';gap=mind;return v;}
	if(rep&&typeof rep==='object'){length=rep.length;for(i=0;i<length;i+=1){k=rep[i];if(typeof k==='string'){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}else{for(k in value){if(Object.hasOwnProperty.call(value,k)){v=str(k,value);if(v){partial.push(quote(k)+(gap?': ':':')+v);}}}}
	v=partial.length===0?'{}':gap?'{\n'+gap+partial.join(',\n'+gap)+'\n'+
	mind+'}':'{'+partial.join(',')+'}';gap=mind;return v;}}
	if(typeof JSON.stringify!=='function'){JSON.stringify=function(value,replacer,space){var i;gap='';indent='';if(typeof space==='number'){for(i=0;i<space;i+=1){indent+=' ';}}else if(typeof space==='string'){indent=space;}
	rep=replacer;if(replacer&&typeof replacer!=='function'&&(typeof replacer!=='object'||typeof replacer.length!=='number')){throw new Error('JSON.stringify');}
	return str('',{'':value});};}
	if(typeof JSON.parse!=='function'){JSON.parse=function(text,reviver){var j;function walk(holder,key){var k,v,value=holder[key];if(value&&typeof value==='object'){for(k in value){if(Object.hasOwnProperty.call(value,k)){v=walk(value,k);if(v!==undefined){value[k]=v;}else{delete value[k];}}}}
	return reviver.call(holder,key,value);}
	text=String(text);cx.lastIndex=0;if(cx.test(text)){text=text.replace(cx,function(a){return'\\u'+
	('0000'+a.charCodeAt(0).toString(16)).slice(-4);});}
	if(/^[\],:{}\s]*$/.test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,'@').replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']').replace(/(?:^|:|,)(?:\s*\[)+/g,''))){j=eval('('+text+')');return typeof reviver==='function'?walk({'':j},''):j;}
	throw new SyntaxError('JSON.parse');};}}());

}