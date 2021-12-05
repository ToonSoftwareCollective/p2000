import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: p2000ConfigScreen
	screenTitle: "P2000 App Setup"
	property string tempWoonplaats: app.woonplaats
	
	property var placenames : []
	property var foundPlaces : []
    property int bw : isNxt? 70:56
    property int bh : isNxt? 35:28
    property string searchstring : ""
	

	onShown: {
		addCustomTopRightButton("Opslaan")
		woonplaats.text =tempWoonplaats
		searchstring = ""
		getPlaces()
	}

	onCustomButtonClicked: {
		app.woonplaats = tempWoonplaats
		app.saveSettings()
		hide()
	}

	function saveWoonplaats(text) {
		if (text) {
			tempWoonplaats = text;
			woonplaats2.text = tempWoonplaats;
		}
	}

    function updateList(searchPlace){
	    placesModel.clear()
        console.log(searchPlace)
		foundPlaces.splice(0, foundPlaces.length);
        if ((placesModel)) {
			placesModel.clear()
			for (var i in placenames) {
				if(searchPlace === ""){
					placesModel.append({place: placenames[i]});
					foundPlaces.push(placenames[i]);
				}else{
					console.log(placenames[i].toLowerCase().substring(0,searchPlace.length))
					if(placenames[i].toLowerCase().substring(0,searchPlace.length) === searchPlace.toLowerCase() ){
						placesModel.append({place: placenames[i]});
						foundPlaces.push(placenames[i]);
					}
				}

			}
		}
    }
	
	Rectangle{
        id: listviewContainer1
        width: isNxt ? 300 : 240
		height: isNxt? 200:160
        color: "white"
        radius: isNxt ? 5 : 4
        border.color: "black"
            border.width: isNxt ? 3 : 2
        anchors {
            top:		parent.top
            topMargin: 	isNxt? 20:16
            left:   	parent.left
			leftMargin : isNxt? 20:16
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
		id: refreshButton
		anchors {
			verticalCenter: listviewContainer1.verticalCenter
			left:  listviewContainer1.right
			leftMargin : isNxt? 3 : 2
		}
		iconSource: "qrc:/tsc/refresh.png"
		onClicked: {
			searchstring = ""
			getPlaces()
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
		width: isNxt ? 120 : 96;  
		height: isNxt ? 40:32
		buttonActiveColor: "lightgreen"
		buttonHoverColor: "blue"
		enabled : true
		textColor : "black"
		buttonText:  "Selecteer"
		anchors {
			top: listviewContainer1.bottom
			left: listviewContainer1.left
			topMargin: isNxt? 5: 4
			}
		onClicked: {
			saveWoonplaats(foundPlaces[listview1.currentIndex])
			console.log(foundPlaces[listview1.currentIndex])
		}
	}

	Rectangle {
		id:keyb
		height: isNxt? 200:160
		width: isNxt? parent.width -50:parent.width -40
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt ? 20:16
			horizontalCenter: parent.horizontalCenter
		}
		Row {
			id: row1
			spacing: 2
			anchors {
				top: parent.top
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}

			Rectangle {height: bh ;width:bw ; Text {text:"Q";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("Q")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"W";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("W")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"E";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("E")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"R";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("R")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"T";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("T")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"Y";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("Y")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"U";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("U")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"I";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("I")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"O";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("O")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"P";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("P")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"BACK";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: {searchstring = searchstring.substring(0,searchstring.length-1) ; updateList(searchstring)}}}
		}


		Row {
			id: row2
			spacing: 2
			anchors {
				top: row1.bottom
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}
			Rectangle {height: bh ;width:bw ; Text {text:"A";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("A")}}}
			Rectangle { height: bh ;width:bw ; Text {text:"S";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("S")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"D";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("D")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"F";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("F")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"G";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("G")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"H";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("H")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"J";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("J")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"K";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("K")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"L";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("L")}}}
		}


		Row {
			id: row3
			spacing: 2
			anchors {
				top: row2.bottom
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}
			Rectangle {height: bh ;width:bw ; Text {text:"Z";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("Z")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"X";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("X")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"C";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("C")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"V";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("V")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"B";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("B")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"N";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("N")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"M";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("M")}}}
		}

		Row {
			id: row4
			spacing: 2
			anchors {
				top: row3.bottom
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}
			Rectangle {height: bh ;width:isNxt? 200:160 ; Text {text:"SPACE";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString(" ")}}}
			Rectangle {height: bh ;width:isNxt? 200:160 ; Text {text:"DASH";font.family: qfont.semiBold.name} MouseArea {anchors.fill: parent; onClicked: { newString("-")}}}
		}
	}
	
	Text {
        id: placesText
        text: searchstring
        font {
            family: qfont.semiBold.name
            pixelSize: isNxt ? 18:14
        }
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }
		
	Text {
		id: mytext1
		text:  "Huidige plaats: "
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
			topMargin:20
		}
	}

	Text {
		id: woonplaats
		text:  ""
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: mytext1.top
			left: mytext1.right
			leftMargin:isNxt? 20:16
		}
	}

	Text {
		id: mytext2
		text:  "Nieuwe plaats: "
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: mytext1.bottom
			left: mytext1.left
			topMargin:isNxt? 20:16
		}
	}

	Text {
		id: woonplaats2
		text:  ""
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 18:14
		anchors {
			top: mytext2.top
			left: woonplaats.left
			leftMargin:isNxt? 20:16
		}
	}

    function  replaceString(inputstring, pattern, nw) {
       var curidx = 0 ;
       var patlen = pattern.length;
       var res = "";
       while(curidx !== -1) {
           curidx = inputstring.indexOf(pattern, curidx);
           //console.log(curidx);
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
	
	function  newString(newChar) {
        searchstring = searchstring + newChar
        updateList(searchstring)
    }
	
    function getPlaces(){
        placesModel.clear()
		placenames.splice(0, placenames.length);
        if (app.debugOutput) console.log("*********P2000: " + "Start getPlaces")
        var http = new XMLHttpRequest()
		http.open("GET", "https://alarmeringen.nl/plaatsen.html", true);
		http.onreadystatechange = function() { // Call a function when the state changes.
			if (http.readyState === 4) {
				if (http.status === 200) {
					var table = http.responseText.substring(http.responseText.indexOf("<table>") + "<table>".length ,http.responseText.indexOf("</table>"));
					var items = table.split("<tr>")
					for(var x = 0;x < items.length;x++){
						if (items[x] !== undefined){
							var row = items[x].split("<td>")
							if (row[1] !== undefined){
								var begin = row[1].indexOf("'>") + "'>".length
								var end = row[1].indexOf("<",begin)
								var tempName = row[1].substring(begin, end).trim();
								tempName = replaceString(tempName, "&#39;", "");
								if (app.debugOutput) console.log("*********P2000: " + tempName);
								placenames.push(tempName);
							}
						}
					}
					updateList("")
				} else {
					console.log(http.status)
				}
			}
		}
		http.send();
    }
}




