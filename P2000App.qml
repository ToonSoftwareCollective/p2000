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
	property string 	lastDescription :  	""
	property var 		pubDate : [];
	property var 		pubDateFull : [];
	property var 		txtcolors : [];	
	property int		scrapetime: 60000; //every minute after first fetch
	property int		scrapetime2: 20000;  //first fetch after start
	property bool 		firststime: true;
	property bool 		enableNotifications: true;
	
	property bool 		isInNotificationMode: false
	property bool 		oldanimationRunning: 	false
	property bool 		oldisVisibleinDimState: true
	property int 		oldanimationInterval : 	1000
	
	property string 	oldqmlAnimationURL :  	""
	property string 	oldqmlAnimationText : 	""
	property string 	oldstaticImageT1 : 		""
	property string 	oldstaticImageT2 : 		""
	property string 	oldstaticImageT1dim : 	""
	property string 	oldstaticImageT2dim : 	""
			
	
	property variant p2000SettingsJson : {
		'woonplaats': "",
		'url': "",
		'enableNotifications': ""
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
			url = p2000SettingsJson['url']
		} catch(e) {
		}
		try {
			p2000SettingsJson = JSON.parse(p2000SettingsFile.read());
			if (p2000SettingsJson['enableNotifications'] == "Yes") {
				enableNotifications = true
			} else {
				enableNotifications = false
			}
		} catch(e) {
		}
		scrapetime2 = 1000;
	}
	
	function saveSettings() {
		var tmpNotifications
		if (enableNotifications == true) {
			tmpNotifications = "Yes";
		} else {
			tmpNotifications = "No";
		}

 		var p2000SettingsJson = {
			"url" : url,
			"enableNotifications" : tmpNotifications,
			"woonplaats" : woonplaats
		}
  		p2000SettingsFile.write(JSON.stringify(p2000SettingsJson))
		title.splice(0, title.length);
		description.splice(0, description.length);
		pubDate.splice(0, pubDate.length);
		pubDateFull.splice(0, pubDateFull.length);
		txtcolors.splice(0, txtcolors.length);
		firststime = true
		console.log("P2000 saved")
		p2000Updated()
		console.log("P2000 getting data")
		getP2000Data()
		
	}

	function  replaceString(inputstring, pattern, nw) {
	   var curidx = 0 ;
	   var patlen = pattern.length;
	   var res = "";
	   while(curidx != -1) {
		   curidx = inputstring.indexOf(pattern, curidx);
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
		if(woonplaats != "xxxxxxxxxxx"){
			title.splice(0, title.length);
			description.splice(0, description.length);
			pubDate.splice(0, pubDate.length);
			pubDateFull.splice(0, pubDateFull.length);
			txtcolors.splice(0, txtcolors.length);
			
			if (debugOutput) console.log("*********P2000: " + "Start P2000 step1")
			var http = new XMLHttpRequest()
			http.open("GET", url, true);
			http.onreadystatechange = function() { // Call a function when the state changes.
				if (http.readyState === 4) {
					if (http.status === 200) {
						if (debugOutput) console.log("*********P2000: " + http.responseText.toString());
						var items = http.responseText.toString().split("<item>")
						var searchString = woonplaats.toLowerCase();
						for(var x = 1;x < 15;x++){
							var tempdescription =items[x].substring(items[x].indexOf("<description>") + "<description>".length ,items[x].indexOf("</description>"));
							var tempTitle =  tempdescription;
							var tempPubDate = items[x].substring(items[x].indexOf("<pubDate>") + "<pubDate>".length ,items[x].indexOf("</pubDate>"))
							
							var lineColor = "black";
							if(tempTitle.toLowerCase().indexOf("ambu")>-1 || tempdescription.toLowerCase().indexOf("ambu")>-1){lineColor = "black";}
							if(tempTitle.toLowerCase().indexOf("politie")>-1 || tempdescription.toLowerCase().indexOf("politie")>-1){lineColor = "blue";}
							if(tempTitle.toLowerCase().indexOf("brandweer ")>-1 || tempdescription.toLowerCase().indexOf("brandweer")>-1){lineColor = "red";}

							tempdescription = replaceString(tempdescription, "Ambulance ", "Ambu ");
							tempdescription = replaceString(tempdescription, "Brandweer ", "Brw ");
							tempdescription = replaceString(tempdescription, "Politie ", "Pol ");
							tempdescription = replaceString(tempdescription, "met spoed", "spoed");
							tempdescription = replaceString(tempdescription, " in " + woonplaats , "");
							tempdescription = replaceString(tempdescription, " " + woonplaats, " ");
							
							if (debugOutput) console.log("*********P2000: " + tempdescription);
							
							txtcolors.push(lineColor);
							title.push(tempTitle);
							
							description.push(tempdescription);
							
							const d = new Date(tempPubDate);
							let month = d.getMonth()+1;
							let monthString = month.toString();
							let day = d.getDate();
							let hour = d.getHours().toString();
							if (hour.length<2){hour = "0" + hour}
							let minutes = d.getMinutes().toString();
							if (minutes.length<2){minutes = "0" + minutes}
							pubDateFull.push(day + "-" + month  + " " + hour + ":" + minutes);
							
							const todayDate = new Date();
							let today = todayDate.getDate();
							if(today === day){
								pubDate.push(hour + ":" + minutes);
							}else{
								pubDate.push(day + "-" + month);
							}
							
						}
						if (lastDescription!==description[0]){ // there is a change
							if(!isInNotificationMode & !firststime & enableNotifications){
								createScreenNotification(pubDate[0], title[0])
							}
						}
						firststime = false;
						lastDescription=description[0]
						p2000Updated();
					}else {
						if (debugOutput) console.log("*********P2000: " + http.status)
					}
				}
			}
			http.send();
		}
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

	function createScreenNotification(eventTime, eventDescription){
		isInNotificationMode = true
		oldanimationRunning = animationscreen.animationRunning
		oldisVisibleinDimState = animationscreen.isVisibleinDimState
		oldanimationInterval = animationscreen.animationInterval
		oldqmlAnimationURL = animationscreen.qmlAnimationURL
		oldqmlAnimationText = animationscreen.qmlAnimationText
		oldstaticImageT1 = animationscreen.staticImageT1
		oldstaticImageT2 = animationscreen.staticImageT2
		oldstaticImageT1dim = animationscreen.staticImageT1dim
		oldstaticImageT2dim =animationscreen.staticImageT2dim
		
		animationscreen.animationRunning= false
			
		if (debugOutput) console.log("*********P2000 START To Write Notification: " + eventTime +  "-" + eventDescription)
		var setJson = {
			"eventTime" : eventTime,
			"eventDescription" : eventDescription
		}
		var doc = new XMLHttpRequest()
		doc.open("PUT", "file:///HCBv2/qml/apps/p2000/event.json")
		doc.send(JSON.stringify(setJson))
		smallDelayTimer.running = true	
	}


	Timer {
		id: smallDelayTimer   //delay to show the goal animation screen
		interval: 100
		repeat: false
		running: false
		triggeredOnStart: false
		onTriggered: {
			animationscreen.qmlAnimationURL= "file:///HCBv2/qml/apps/p2000/P2000Animation.qml"
			animationscreen.animationInterval= 100000
			animationscreen.isVisibleinDimState= true
			if (oldanimationRunning){
				animationscreen.staticImageT1 = oldstaticImageT1
				animationscreen.staticImageT2 = oldstaticImageT2
				animationscreen.staticImageT1dim = oldstaticImageT1dim
				animationscreen.staticImageT2dim = oldstaticImageT2
				
			}else{
				animationscreen.staticImageT1 = ""
				animationscreen.staticImageT2 = ""
				animationscreen.staticImageT1dim = ""
				animationscreen.staticImageT2dim = ""
			}
			animationscreen.animationRunning= true;
			notificationTimer.running = true
			smallDelayTimer.running = false
		}
	}

	Timer {
		id: notificationTimer   //delay to hide the notification
		interval: 10000
		repeat: false
		running: false
		triggeredOnStart: false
		onTriggered: {
			animationscreen.animationRunning= false
			animationscreen.qmlAnimationURL = ""
			smallDelayTimer2.running = true			
			notificationTimer.running = false
		}
	}
	
	Timer {
		id: smallDelayTimer2  //delay to return to the old animation
		interval: 3000
		repeat: false
		running: false
		triggeredOnStart: false
		onTriggered: {
			if (oldanimationRunning){
				animationscreen.isVisibleinDimState = oldisVisibleinDimState
				animationscreen.animationInterval = oldanimationInterval
				animationscreen.qmlAnimationURL = oldqmlAnimationURL
				animationscreen.qmlAnimationText = oldqmlAnimationText
				animationscreen.staticImageT1 = oldstaticImageT1
				animationscreen.staticImageT2 = oldstaticImageT2
				animationscreen.staticImageT1dim = oldstaticImageT1dim
				animationscreen.staticImageT2dim = oldstaticImageT2dim
				animationscreen.animationRunning = true
			}else{
				animationscreen.animationRunning= false
				animationscreen.isVisibleinDimState= false
			}
			isInNotificationMode = false
			smallDelayTimer2.running = false
		}
	}

}