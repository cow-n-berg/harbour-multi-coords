import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Page {
    id: page

    allowedOrientations: Orientation.All

    ListModel {
        id: listModelCoord

        function updateCoord()
        {
//            listModelCoord.clear();
//            var lettrs = Database.getLettersWP(generic.wpId);
//            console.log( JSON.stringify(lettrs) );
//            for (var i = 0; i < lettrs.length; ++i) {
//                listModelCoord.append(lettrs[i]);
//            }
//            console.log( "listModelCoord updated");
//            generic.allLetters = Database.getLetters(generic.gcId)
        }
    }

    Component.onCompleted: listModelCoord.updateCoord();

    SilicaFlickable {
        id: addMulti

        PageHeader {
            id: pageHeader
            title: qsTr("Add Multi cache")
        }

        VerticalScrollDecorator { flickable: wpView }

        anchors.fill: parent
        anchors.margins: Theme.paddingMedium
        contentHeight: column.height + Theme.itemSizeMedium
        quickScroll : true

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

            TextArea {
                id: textArea
                width: parent.width
                height: Screen.height / 6
                text: qsTr("Past the entire Geocache description - or the content of a GPX file! - in the next text area. Use the button to extract possible coordinates and formulas. Use press-and-hold to remove options. Formulas may be too long, you can edit them later. ")
                label: qsTr("How to add")
                color: Theme.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
            }
            TextArea {
                id: rawText
                width: parent.width
                height: Screen.height / 4
                label: "Raw text"
//                text: '2017" maxlon="5.979433" />  <wpt lat="52.132017" lon="5.979433">    <time>2010-08-01T00:00:00</time>    <name>GC22W75</name>    <groundspeak:cache id="1521673" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">      <groundspeak:name>Het Pad Der 7 Zonden</groundspeak:name>&lt;td&gt;Projecteer vanaf het P-coördinaat 29 meter in richting 57°. Onderin deze stenen paal vind je de waardes A en B. De eerste zonde Trots kun je vinden op N 52° 07.A E 005° 59.B. Elke zonde die je met succes weerstaat wordt beloond met de coördinaten voor het volgende waypoint.&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;'
                text: 'N 47° 36.600 W 122° 20.555  View the ratings for GC3A7RC  View Ratings for GC3A7RC when masterchef and kelientje visited seattle, they commented on ho     waypoint 1: start                                                   you are standing at the very first location of this worldwide chain     waypoint2: N 47° 36.(580+A) W 122° 20.(507+B)                       as the plaque states, this comical artwork was funded by gifts to c     waypoint3: N 47° 36.(547+C) W 122° 20.(494+D)                       this is a more recent seattle business which opened in 2003 and qui     waypoint4 -final: N 47° 36.(589+A+B+C) W 122°20.(542+D+E+F)         PLEASE WATCH OUT FOR MUGGLES. this is a very high traffic area and      first and second to find prize is a gift card to one of the places      You can check your answers for this puzzle on Geochecker.com.      '
                placeholderText: qsTr("Paste description, formula or raw text here")
                font.pixelSize: Theme.fontSizeExtraSmall
//                focus: true
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
             }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Process raw text")
                onClicked: {
                    var results = TF.coordsByRegEx(rawText.text)
                    txtCode.text = results.code
                    txtName.text = results.name
//                    txtMain.text = results.main
//                    txtCoord.text = results.coords
//                    txtFormul.text = results.formul
               }
            }

            SectionHeader {
                text: qsTr("Results: Geocache items")
            }

            TextField {
                id: txtCode
                label: qsTr("Geocache code")
                placeholderText: "GCXXXXX"
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextField {
                id: txtName
                label: qsTr("Geocache name")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextField {
                id: txtMain
                label: qsTr("Main coordinate")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextField {
                id: txtCoord
                label: qsTr("Main coordinate")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextField {
                id: txtFormul
                label: qsTr("Waypoint formula (raw text)")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }
        }

    }
}
