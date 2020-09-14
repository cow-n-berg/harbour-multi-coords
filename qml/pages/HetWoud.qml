import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/Calculations.js" as Calc

Page {
    id: page

    allowedOrientations: Orientation.All

    property var waypts  : Database.getWaypts(generic.gcId, false);
    property var distance: 0

    SilicaFlickable {
        id: flick
        anchors {
            fill: parent
            leftMargin: Theme.paddingSmall
            rightMargin: Theme.paddingSmall
        }
        contentHeight: column.height
        quickScroll : true

        PageHeader {
            id: pageHeader
            title: "Calculate pentagon"
        }

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            anchors.top: pageHeader.bottom

            TextField {
                id: wp1
                width: parent.width
//                text: ""
                label: Calc.showFormula( wp1.text, waypts)
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                focus: true
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp2.focus = true
            }

            TextField {
                id: wp2
                width: parent.width
//                text: ""
                label: Calc.showFormula( wp2.text, waypts) //qsTr("WP2")
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp3.focus = true
            }

            TextField {
                id: wp3
                width: parent.width
//                text: ""
                label: Calc.showFormula( wp3.text, waypts) //qsTr("WP3")
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp4.focus = true
            }

            TextField {
                id: wp4
                width: parent.width
//                text: ""
                label: Calc.showFormula( wp4.text, waypts) //qsTr("WP4")
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    wp5.focus = true
                }
            }

            TextField {
                id: wp5
                width: parent.width
//                text: ""
                label: Calc.showFormula( wp5.text, waypts) //qsTr("WP5")
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    distance = Calc.distance( wp1.text, wp2.text, wp3.text, wp4.text, wp5.text, waypts )
                    wp5.focus = false
                }
            }

            TextArea {
                id: dist
                width: parent.width
                text: distance
                label: qsTr("Circumference (meter)")
                color: generic.highlightColor
                readOnly: true
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Clear waypoints")
                color: generic.primaryColor
                onClicked: {
                    wp1.text = ""
                    wp2.text = ""
                    wp3.text = ""
                    wp4.text = ""
                    wp5.text = ""
                    wp1.focus = true
               }
            }
        }
    }
}
