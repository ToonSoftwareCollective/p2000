import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Screen {
	id: p2000ConfigScreen
	screenTitle: "P2000 App Setup"
	property string tempWoonplaats: app.woonplaats
	
	property var placenames : []
	property var foundPlaces : []
    property int bw : 70
    property int bh : 35
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
        //height: parent.height - keyb.height - keyb.bottomMargin -100
		height: 200
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
		height: 200
		width:parent.width -50
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
			Rectangle {height: bh ;width:bw ; Text {text:"Q"} MouseArea {anchors.fill: parent; onClicked: { newString("Q")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"W"} MouseArea {anchors.fill: parent; onClicked: { newString("W")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"E"} MouseArea {anchors.fill: parent; onClicked: { newString("E")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"R"} MouseArea {anchors.fill: parent; onClicked: { newString("R")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"T"} MouseArea {anchors.fill: parent; onClicked: { newString("T")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"Y"} MouseArea {anchors.fill: parent; onClicked: { newString("Y")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"U"} MouseArea {anchors.fill: parent; onClicked: { newString("U")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"I"} MouseArea {anchors.fill: parent; onClicked: { newString("I")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"O"} MouseArea {anchors.fill: parent; onClicked: { newString("O")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"P"} MouseArea {anchors.fill: parent; onClicked: { newString("P")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"BACK"} MouseArea {anchors.fill: parent; onClicked: {searchstring = searchstring.substring(0,searchstring.length-1) ; updateList(searchstring)}}}
		}


		Row {
			id: row2
			spacing: 2
			anchors {
				top: row1.bottom
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}
			Rectangle {height: bh ;width:bw ; Text {text:"A"} MouseArea {anchors.fill: parent; onClicked: { newString("A")}}}
			Rectangle { height: bh ;width:bw ; Text {text:"S"} MouseArea {anchors.fill: parent; onClicked: { newString("S")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"D"} MouseArea {anchors.fill: parent; onClicked: { newString("D")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"F"} MouseArea {anchors.fill: parent; onClicked: { newString("F")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"G"} MouseArea {anchors.fill: parent; onClicked: { newString("G")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"H"} MouseArea {anchors.fill: parent; onClicked: { newString("H")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"J"} MouseArea {anchors.fill: parent; onClicked: { newString("J")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"K"} MouseArea {anchors.fill: parent; onClicked: { newString("K")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"L"} MouseArea {anchors.fill: parent; onClicked: { newString("L")}}}
		}


		Row {
			id: row3
			spacing: 2
			anchors {
				top: row2.bottom
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}
			Rectangle {height: bh ;width:bw ; Text {text:"Z"} MouseArea {anchors.fill: parent; onClicked: { newString("Z")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"X"} MouseArea {anchors.fill: parent; onClicked: { newString("X")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"C"} MouseArea {anchors.fill: parent; onClicked: { newString("C")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"V"} MouseArea {anchors.fill: parent; onClicked: { newString("V")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"B"} MouseArea {anchors.fill: parent; onClicked: { newString("B")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"N"} MouseArea {anchors.fill: parent; onClicked: { newString("N")}}}
			Rectangle {height: bh ;width:bw ; Text {text:"M"} MouseArea {anchors.fill: parent; onClicked: { newString("M")}}}
		}

		Row {
			id: row4
			spacing: 2
			anchors {
				top: row3.bottom
				topMargin: isNxt ? 10:8
				horizontalCenter: parent.horizontalCenter
			}
			Rectangle {height: bh ;width:200 ; Text {text:"SPACE  "} MouseArea {anchors.fill: parent; onClicked: { newString(" ")}}}
			Rectangle {height: bh ;width:200 ; Text {text:"DASH"} MouseArea {anchors.fill: parent; onClicked: { newString("-")}}}
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
			leftMargin:20
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
			topMargin:20
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
			leftMargin:20
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




