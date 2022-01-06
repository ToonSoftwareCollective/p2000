import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: p2000ConfigScreen
	screenTitle: "P2000 App Setup"
	property string tempWoonplaats: app.woonplaats
	
	property var placenames : []
	property var cityURLs : []

    property int bw : isNxt? 70:56
    property int bh : isNxt? 35:28
	property string tempUrl : app.url
	
	property bool tempNotifications : app.enableNotifications

	onShown: {
		addCustomTopRightButton("Opslaan")
		woonplaatsEdit.inputText =tempWoonplaats
		searchstring = ""
		getPlaces2(tempWoonplaats)
		notificationModeToggle.isSwitchedOn = tempNotifications;
	}

	onCustomButtonClicked: {
		if (tempWoonplaats === "")tempWoonplaats ="xxxxxxxxxxx"	
		app.woonplaats = tempWoonplaats
		app.url = tempUrl 
		app.enableNotifications = tempNotifications
		app.saveSettings()
		hide()
	}

	function saveWoonplaats(plaats,plaatsURL) {
		if (plaats) {
			tempWoonplaats = plaats;
			if (app.debugOutput) console.log("*********P2000 plaats: " + plaats)
			    nwwoonplaatsText.text = tempWoonplaats
				tempUrl = "https://alarmeringen.nl/feeds/city/" + plaatsURL + ".rss"
				if (app.debugOutput) console.log("*********P2000 tempUrl: " + tempUrl)
				tempUrl = replaceString(tempUrl, " ", "-");
				urlText.text = tempUrl
		}
	}
	
	function updateList(){
        if (app.debugOutput) console.log("*********P2000 updateListToon1")
        if (placesModel){
			placesModel.clear()
			for (var i in placenames) {
				placesModel.append({place: placenames[i]});
			}
		}
    }
	
	Text {
		id: instelText
		text:  "Instellingen"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: parent.top
			left: parent.left
			leftMargin: 20
			topMargin:isNxt? 16:12
		}
	}
	
	Text {
		id: infoText
		text:  "kijk op https://alarmeringen.nl/plaatsen.html voor de juiste spelling van de plaatsnaam."
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			left:instelText.left
			top: instelText.bottom
			topMargin:isNxt? 16:12
		}
	}
	
	Text {
		id: infoText2
		text:  "Type een plaats of een gedeelte daarvan in het invoerveld hieronder: "
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: infoText.bottom
			left:instelText.left
			topMargin:isNxt? 10:8
		}
	}
	
	EditTextLabel4421 { 
		id: woonplaatsEdit
		width: (parent.width*0.4) - 40		
		height: 30
		inputText:""
		leftTextAvailableWidth: 100
		leftText: "Plaats: "
		labelFontSize: isNxt ? 18:14
		labelFontFamily: qfont.semiBold.name
		anchors {
			left:instelText.left
			top: infoText2.bottom
			topMargin:isNxt? 16:12
		}
		onClicked: {
			qkeyboard.open(woonplaatsEdit.leftText, woonplaatsEdit.inputText, getPlaces2)
		}
	}
	
	Text {
		id: notificationMode
		text: "Schermnotificatie bij nieuwe melding: "
		font.pixelSize:  isNxt ? 18:14
		font.family: qfont.semiBold.name

		anchors {
			left: upButton.right
			top: woonplaatsEdit.top
			leftMargin: isNxt ? 18:14
		}
	}

	OnOffToggle {
		id: notificationModeToggle
		height:  30
		
		anchors {
			left: notificationMode.right
			top: notificationMode.top
			leftMargin: isNxt ? 18:14
		}
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				tempNotifications = true;
			} else {
				tempNotifications = false;
			}
		}
	}

	
	Rectangle{
        id: listviewContainer1
        width: isNxt ? 400 : 320
		height: isNxt? 200:160
        color: "white"
        radius: isNxt ? 5 : 4
        border.color: "black"
        border.width: isNxt ? 3 : 2
        anchors {
            top:		woonplaatsEdit.bottom
            topMargin: 	isNxt? 20:16
            left:   	instelText.left
        }

        Component {
            id: aniDelegate
            Item {
                width: isNxt ? (parent.width-20) : (parent.width-16)
                height: isNxt ? 22 : 18
                Text {
                    id: tst
                    text: place
                    font.pixelSize: isNxt ? 18:14
                }
            }
        }

        ListModel {
                id: placesModel
        }

        ListView {
            id: listview1
            anchors {
                top: parent.top
                topMargin:isNxt ? 20 : 16
                leftMargin: isNxt ? 12 : 9
                left: parent.left
            }
            width: parent.width
            height: isNxt ? (parent.height-50) : (parent.height-40)
            model:placesModel
            delegate: aniDelegate
            highlight: Rectangle {
                color: "lightsteelblue";
                radius: isNxt ? 5 : 4
            }
            focus: true
        }
    }
	
	IconButton {
		id: upButton
		anchors {
			top: listviewContainer1.top
			left:  listviewContainer1.right
			leftMargin : isNxt? 3 : 2
		}

		iconSource: "qrc:/tsc/up.png"
		onClicked: {
			if (listview1.currentIndex>0){
				listview1.currentIndex  = listview1.currentIndex -1
			}
		}	
	}
	

	IconButton {
		id: downButton
		anchors {
			bottom: listviewContainer1.bottom
			left:  listviewContainer1.right
			leftMargin : isNxt? 3 : 2

		}
		iconSource: "qrc:/tsc/down.png"
		onClicked: {
			listview1.currentIndex  = listview1.currentIndex +1
		}

	}

	NewTextLabel {
		id: selText
		width: listviewContainer1.width 
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Selecteer"
		anchors {
			top: listviewContainer1.bottom
			left: instelText.left
			topMargin: isNxt? 5: 4
			}
		onClicked: {
			saveWoonplaats(placenames[listview1.currentIndex],cityURLs[listview1.currentIndex])
		}
	}

	Text {
		id: nwPlaatsText
		text:  "Nieuwe plaats: "
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: selText.bottom
			left: instelText.left
			topMargin:isNxt? 16:12
		}
	}


	Text {
		id: nwwoonplaatsText
		text:  ""
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: nwPlaatsText.top
			left: nwPlaatsText.right
			leftMargin: isNxt? 30:24
		}
	}	
	

	Text {
		id: urlText
		text:  ""
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		wrapMode: Text.Wrap
		width: 800
		anchors {
			top:  nwPlaatsText.bottom
			left: instelText.left
			topMargin:isNxt? 10:8
		}
	}


    function  replaceString(inputstring, pattern, nw) {
       var curidx = 0 ;
       var patlen = pattern.length;
       var res = "";
       while(curidx !== -1) {
           curidx = inputstring.indexOf(pattern, curidx);
           if (app.debugOutput) console.log("*********P2000 curidx: " + curidx);
           if(curidx === -1) {
               break;
           }
           var end = curidx + patlen;
           var firststring = inputstring.substring(0, curidx);
           var endstring =  inputstring.substring(curidx + patlen, inputstring.length);
           inputstring = firststring + nw + endstring;
        }
        return inputstring;
    }
	
	
    function getPlaces2(plaats){
		
		placenames.splice(0, placenames.length);
		cityURLs.splice(0, cityURLs.length);
	
        if (app.debugOutput) console.log("*********P2000: Start getPlaces")
        var http = new XMLHttpRequest()
		http.open("GET", "https://alarmeringen.nl/city_autocomplete/?q=" + plaats, true);
		if (app.debugOutput) console.log("*********P2000: URL: " + "https://alarmeringen.nl/city_autocomplete/?q=" + plaats)
		http.onreadystatechange = function() { // Call a function when the state changes.
			woonplaatsEdit.inputText =plaats
			if (http.readyState === 4) {
				if (http.status === 200) {
					if (app.debugOutput) console.log("*********P2000: responseText: " +http.responseText)
					var JsonString = http.responseText
                    var JsonObject= JSON.parse(JsonString)
					for(var x = 0;x < JsonObject.length;x++){
						placenames.push(JsonObject[x].value)
						if (app.debugOutput) console.log("*********P2000 pushing to placenames: " + JsonObject[x].value)
						var einde = JsonObject[x].url.length -2
						var begin = JsonObject[x].url.lastIndexOf("/", einde) + 1
						cityURLs.push(JsonObject[x].url.substring(begin, (JsonObject[x].url.length -1)))
						if (app.debugOutput) console.log("*********P2000 pushing to cityURLs: " + JsonObject[x].url.substring(begin, JsonObject[x].url.length -1))
					}
					updateList()
				} else {
					if (app.debugOutput) console.log("*********P2000 http.status: " + http.status)
				}
			}
		}
		http.send();
    }

}




