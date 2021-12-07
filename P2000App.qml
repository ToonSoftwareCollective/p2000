//12-2021
//by oepi-loepi


import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import FileIO 1.0

App {
	id: p2000App
	property bool 		debugOutput : false
	property url 		tileUrl : "P2000Tile.qml"

	property url 		thumbnailIcon: "qrc:/tsc/bad_small.png"
	property 		 	P2000Tile p2000Tile

	property			P2000Screen  p2000Screen
	property url 		p2000ScreenUrl : "P2000Screen.qml"
	property			P2000ConfigScreen  p2000ConfigScreen
	property url 		p2000ConfigScreenUrl : "P2000ConfigScreen.qml"
	property string 	url : "https://www.alarmeringen.nl/feeds/all.rss"
	property string 	woonplaats :  "xxxxxxxxxxx"
	property var 		title : [];
	property var 		description : [];
	property var 		pubDate : [];
	property var 		pubDateFull : [];
	property var 		txtcolors : [];	
	property int		scrapetime: 20000;
	property int		scrapetime2: 20000;
	
	property variant p2000SettingsJson : {
		'woonplaats': ""
	}
	
	FileIO {
		id: p2000SettingsFile
		source: "file:///mnt/data/tsc/p2000_userSettings.json"
	}

	signal p2000Updated()	
	
	function init() {
		registry.registerWidget("screen", p2000ConfigScreenUrl, this, "p2000ConfigScreen")
		registry.registerWidget("screen", p2000ScreenUrl, this, "bitcoinScreen")
		registry.registerWidget("tile", tileUrl, this, "p2000Tile", {thumbLabel: qsTr("P2000"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, baseTileSolarWeight: 10, thumbIconVAlignment: "center"})
	}
		
	Component.onCompleted: {
		try {
			p2000SettingsJson = JSON.parse(p2000SettingsFile.read());
			woonplaats = p2000SettingsJson['woonplaats']
		} catch(e) {
		}
		scrapetime2 = 1000;
	}
	
	function saveSettings() {
 		var p2000SettingsJson = {
			"woonplaats" : woonplaats
		}
  		p2000SettingsFile.write(JSON.stringify(p2000SettingsJson))
		title.splice(0, title.length);
		description.splice(0, description.length);
		pubDate.splice(0, pubDate.length);
		pubDateFull.splice(0, pubDateFull.length);
		txtcolors.splice(0, txtcolors.length);
		p2000Updated();
		getP2000Data()
	}



	function  replaceString(inputstring, pattern, nw) {
	   var curidx = 0 ;
	   var patlen = pattern.length;
	   var res = "";
	   while(curidx != -1) {
		   curidx = inputstring.indexOf(pattern, curidx);
		   //console.log(curidx);
		   if(curidx == -1) {
			   break;
		   }
		   var end = curidx + patlen;
		   var firststring = inputstring.substring(0, curidx);
		   var endstring =  inputstring.substring(curidx + patlen, inputstring.length);
		   inputstring = firststring + nw + endstring;
		}
		return inputstring;
	}
	

    function getP2000Data(){
		scrapetime2 = scrapetime;
        if (debugOutput) console.log("*********P2000: " + "Start P2000 step1")
        var http = new XMLHttpRequest()
		http.open("GET", url, true);
		http.onreadystatechange = function() { // Call a function when the state changes.
			if (http.readyState === 4) {
				if (http.status === 200) {
				if (debugOutput) console.log("*********P2000: " + http.responseText.toString());
					var items = http.responseText.toString().split("<item>")
					var searchString = woonplaats.toLowerCase();
					for(var x = 1;x < items.length;x++){
						var tempTitle = items[x].substring(items[x].indexOf("<title>") + "<title>".length ,items[x].indexOf("</title>"));
						var tempdescription =items[x].substring(items[x].indexOf("<description>") + "<description>".length ,items[x].indexOf("</description>"));
						var tempPubDate = items[x].substring(items[x].indexOf("<pubDate>") + "<pubDate>".length ,items[x].indexOf("</pubDate>"));
						var found = false;
						if (tempdescription.toLowerCase().indexOf(searchString)>-1){
							for (var index in title){
								if (tempTitle.toLowerCase() === title[index].toLowerCase()){found =true}
							}
							if (!found){
								var lineColor = "black";
								
								if (debugOutput) console.log("*********P2000: " + tempTitle);
								if (debugOutput) console.log("*********P2000: " + tempdescription);
								
								if(tempTitle.toLowerCase().indexOf("ambu")>-1 || tempdescription.toLowerCase().indexOf("ambu")>-1){lineColor = "black";}
								if(tempTitle.toLowerCase().indexOf("politie")>-1 || tempdescription.toLowerCase().indexOf("politie")>-1){lineColor = "blue";}
								if(tempTitle.toLowerCase().indexOf("brandw")>-1 || tempdescription.toLowerCase().indexOf("brandw")>-1){lineColor = "red";}
								
								tempdescription = replaceString(tempdescription, "Ambulance ", "Ambu ");
								tempdescription = replaceString(tempdescription, "Brandweer ", "Brw ");
								tempdescription = replaceString(tempdescription, "Politie ", "Pol ");
								tempdescription = replaceString(tempdescription, "met spoed", "spoed");
								tempdescription = replaceString(tempdescription, " in " + woonplaats , "");
								tempdescription = replaceString(tempdescription, " " + woonplaats, " ");
								
								if (debugOutput) console.log("*********P2000: " + tempdescription);
								
								txtcolors.unshift(lineColor);
								title.unshift(tempTitle);
								description.unshift(tempdescription);
								
								const d = new Date(tempPubDate);
								//let year = d.getFullYear().toString();;
								let month = d.getMonth()+1;
								let monthString = month.toString();
								let day = d.getDate();
								let hour = d.getHours().toString();;
								if (hour.length<2){hour = "0" + hour}
								let minutes = d.getMinutes().toString();
								if (debugOutput) console.log("*********P2000: " + minutes.length);
								if (minutes.length<2){minutes = "0" + minutes}
								pubDateFull.unshift(day + "-" + month  + " " + hour + ":" + minutes);
								pubDate.unshift(hour + ":" + minutes);
								
								if (debugOutput) console.log("*********P2000: " + hour + ":" + minutes);
								
								if (title.length>10){
									title.pop();
									description.pop();
									pubDate.pop();
									pubDateFull.pop();
									txtcolors.pop();
								}
							}
							p2000Updated();
						 }
					}
				} else {
					if (debugOutput) console.log("*********P2000: " + http.status)
				}

			}
		}
		http.send();

    }		
		
    Timer {
            id: scrapeTimer   //delay to hide the new goal screen
            interval: scrapetime2
            repeat: true
            running: true
            triggeredOnStart: false
            onTriggered: {
                getP2000Data()
            }
   }		



}