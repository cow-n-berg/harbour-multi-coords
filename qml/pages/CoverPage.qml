import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/TextFunctions.js" as TF

CoverBackground {
    id: coverPage

    property var gccode: generic.gcCode || ""
    property var gcname: generic.gcName || ""
    property var wpnumb: generic.wpNumber || ""

    Image {
        id: backgroundImage
        source: TF.coverIconUrl(Theme.colorScheme === Theme.LightOnDark)

        anchors {
            fill: parent

        }

        fillMode: Image.PreserveAspectCrop
        opacity: 0.15
    }
    Label {
        anchors {
            top: parent.height / 2
            horizontalCenter: parent.horizontalCenter
            margins: Theme.paddingMedium
        }

        id: code
        text: gccode
//            visible: !coverShowAppName
    }
    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: code.bottom
            margins: Theme.paddingMedium
        }

        id: name
        text: TF.truncateString(gcname,12)
//            visible: !coverShowAppName
    }
    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: name.bottom
            margins: Theme.paddingMedium
        }

        id: wp
        text: qsTr("WP ") + wpnumb
//            visible: !coverShowAppName && wpnumb != ""
        visible: wpnumb != ""
    }
    Label {
        anchors {
            top: wp.bottom
            margins: Theme.paddingMedium
            horizontalCenter: parent.horizontalCenter
//                margins: Theme.paddingMedium
        }

        id: label
        text: qsTr("GMFS")
        visible: coverShowAppName
    }

    CoverActionList {
        id: coverAction
    }
}
