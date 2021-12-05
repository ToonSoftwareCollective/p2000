import QtQuick 2.1
import qb.base 1.0
import BasicUIControls 1.0
import qb.components 1.0

Tile {
	id: p2000Tile
	
	property bool dimState: screenStateController.dimmedColors
	onClicked: {
		stage.openFullscreen(app.p2000ScreenUrl)
	}

	Component.onCompleted: {
		app.p2000Updated.connect(updateP2000List);
	}
	
	
	function updateP2000List() {
		if ((statusModel)) {
			statusModel.clear()
			timeModel.clear()
			for (var i in app.description) {
				var shortDescription = app.description[i].substring(0, 37);
				statusModel.append({status: shortDescription, txtcolor: app.txtcolors[i]});
				timeModel.append({time: app.pubDate[i], txtcolor: app.txtcolors[i]});
			}
		}
	}
	
	
	ListModel {
        id: timeModel
    }

    ListModel {
        id: statusModel
    }
	
	Text{
		id: waitText
		text: "Wacht op data" 
		font.pixelSize: isNxt? 25:20
		font.family:  qfont.bold.name
		anchors {
            	verticalCenter: parent.verticalCenter
				horizontalCenter: parent.horizontalCenter
        }
		color: dimState? "white" : "grey" 
		visible: (statusModel.count==0 && app.woonplaats != "xxxxxxxxxxx")? true: false
	}
	
	Text{
		id: setupText
		text: "Selecteer een plaats" 
		font.pixelSize: isNxt? 25:20
		font.family:  qfont.bold.name
		anchors {
			verticalCenter: parent.verticalCenter
			horizontalCenter: parent.horizontalCenter
        }
		color: dimState? "white" : "grey" 
		visible: (app.woonplaats != "xxxxxxxxxxx")? false: true
	}
	
	Text{
		id: p2000Text
		text: "P2000" 
		font.pixelSize: isNxt? 25:20
		font.family:  qfont.bold.name
		anchors {
			bottom: setupText.top
			bottomMargin: isNxt? 20:16
			horizontalCenter: parent.horizontalCenter
        }
		color: dimState? "white" : "grey" 
		visible: (setupText.visible || waitText.visible)
	}	

	Text{
		id: wpText
		text: "P2000 - " + app.woonplaats 
		font.pixelSize: isNxt? 16:12
		font.family:  qfont.bold.name
		anchors {
		    top: parent.top
			left: parent.left
            leftMargin:  isNxt? 12:9
            topMargin: isNxt? 6:5
        }
		color: dimState? "white" : "grey" 
		visible: (!setupText.visible && !waitText.visible)
	}
	

    GridView {
         id: timeListView
         model: timeModel
         delegate: Text {
             id: mytext1
             text: time
             color: dimState? "white" : txtcolor
             font {
                 pixelSize: isNxt? 12:9
             }
             anchors.left: parent.left
         }
         flow: GridView.BottomToTop
         cellWidth: isNxt? parent.width-20 : parent.width-16
         cellHeight:  isNxt? 16:12
         height : isNxt? parent.height  - 20: parent.height  - 16
         width :   isNxt? 40:32
         anchors {
             top: wpText.bottom
             left: parent.left
             leftMargin:  isNxt? 12:9
             topMargin: isNxt? 6:5
         }
         visible: true
     }


     GridView {
         id: statusListView
         model: statusModel
         delegate: Text {
             id: mytext2
             text: status
             color: dimState? "white" : "grey"
             font {
                 pixelSize: isNxt? 12:9
             }
             anchors.left: parent.left
         }
         flow: GridView.BottomToTop
         cellWidth: isNxt? parent.width-20 : parent.width-16
         cellHeight: isNxt? 16:12
         height :isNxt? parent.height  - 20: parent.height  - 16
         width : isNxt? 40:32
         anchors {
             top: timeListView.top
             left: timeListView.right
             leftMargin:  isNxt? 6:5
         }
         visible: true
     }
}
	
