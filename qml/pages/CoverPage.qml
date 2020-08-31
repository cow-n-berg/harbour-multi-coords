import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/TextFunctions.js" as TF

CoverBackground {
    id: coverPage

    property var gccode: generic.gcCode
    property var gcname: generic.gcName
    property var wpnumb: generic.wpNumber

    Image {
        id: backgroundImage
        source: TF.coverIconUrl(Theme.colorScheme === Theme.LightOnDark)
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 0.15
    }
    Item {
        anchors.fill: parent
        Label {
            anchors {
                centerIn: parent
//                top: parent.height / 2
//                horizontalCenter: parent.horizontalCenter
//                margins: Theme.paddingMedium
            }

            id: code
            text: TF.coverText(gccode, gcname, wpnumb, generic.coverShowAppName)
        }
    }
    CoverActionList {
        id: coverAction
        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                if (!generic.applicationActive) {
                    pageStack.push(Qt.resolvedUrl("MultiAddPage.qml"))
                    generic.activate();
                }
            }
        }
    }
}
