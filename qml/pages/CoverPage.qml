import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/TextFunctions.js" as TF

CoverBackground {
    id: coverPage

    property var gccode        : generic.gcCode
    property var gcname        : generic.gcName
    property var wpnumb        : generic.wpNumber
    property var copyTriState : true

    Timer {
        id: coverTimer
        interval: 5000
        running: false
        onTriggered: {
            coverLabel.text = TF.coverText(gccode, gcname, wpnumb, generic.coverShowAppName)
        }
    }

    Image {
        id: backgroundImage
        source: TF.coverIconUrl(Theme.colorScheme === Theme.LightOnDark, generic.nightCacheMode)
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 0.15
    }
    Item {
        anchors.fill: parent
        Label {
            id: coverLabel
            anchors.centerIn: parent
            text: TF.coverText(gccode, gcname, wpnumb, generic.coverShowAppName)
            color: generic.primaryColor
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
        CoverAction {
            iconSource: TF.copyIconUrl(Theme.colorScheme === Theme.LightOnDark, generic.nightCacheMode)
            onTriggered: {
                if (wpnumb === undefined) {
                    coverLabel.text = qsTr("No formula yet")
                }
                else
                    if (generic.formulaCopyMode) {
                        Clipboard.text = TF.copyText( generic.wpCalc, copyTriState )
                        coverLabel.text = copyTriState === 0 ? qsTr("Formula copied") : ( copyTriState === 1 ? qsTr("Lat copied") : qsTr("Lon copied") )
                        copyTriState === 2 ? 0 : copyTriState++
                    }
                    else {
                        Clipboard.text = generic.wpCalc
                        coverLabel.text = qsTr("Formula copied")
                    }
                coverTimer.start()
            }
        }
    }
}
