import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    property var    letterid
    property var    callback

    property string letter

    function getThisLetter() {
        var letters = Database.getOneLetter(letterid)
        console.log("This letter: " + JSON.stringify(letters))
        if (letters.length > 0) {
            letter          = letters[0].letter
            lettValue.text  = letters[0].lettervalue
            lettRemark.text = letters[0].remark
        }
    }

    onAccepted: {
        var lettervalue = lettValue.text.valueOf()
        var letterremark = lettRemark.text
        var found = true
        Database.setLetter(generic.gcId, generic.wpId, letterid, letter, lettervalue, letterremark)
        generic.allLetters = Database.getLetters(generic.gcId)
        found = Database.allLettersWpFound(generic.wpId)
        dialog.callback(true, found)
    }

    onRejected: {
        dialog.callback(false, false)
    }

    Component.onCompleted: getThisLetter(letterid);

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 1.0
        visible: generic.nightCacheMode
    }

    SilicaFlickable {
        width: parent.width
        anchors.fill: parent
        contentHeight: column.height

        PageHeader {
            id: pageHeader
            title: qsTr("Enter value for: " + letter )
        }

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            anchors.top: pageHeader.bottom

            TextArea {
                width: parent.width
                height: Screen.height / 4
                text: generic.wpNote
                color: generic.secondaryColor
                readOnly: true
                visible: generic.wpNote !== ""
                labelVisible: false
                font.pixelSize: Theme.fontSizeLarge

            }

            TextField {
                id: lettValue
                width: parent.width
                label: qsTr("Value for: ") + letter
                placeholderText: label
                color: generic.primaryColor
                font.pixelSize: Theme.fontSizeLarge
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                focus: true
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: lettRemark.focus = true
            }

            Row {
                id: row
                width: column.width
                height: Theme.itemSizeLarge

                TextField {
                    id: lettRemark
                    width: parent.width - removeIcon.width
                    label: qsTr("Optional remark")
                    placeholderText: label
                    font.pixelSize: Theme.fontSizeLarge
                    color: generic.primaryColor
                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: lettRemark.focus = false
                }
                IconButton {
                    id: removeIcon
                    icon.source: "image://theme/icon-m-input-clear"
                    icon.width: Theme.iconSizeMedium
                    icon.height: Theme.iconSizeMedium
                    icon.color: generic.primaryColor
                    onClicked: {
                        lettRemark.text = ""
                        lettRemark.focus = true
                    }
                }

            }

            TextArea {
                width: parent.width
                readOnly: true
                text: TF.remarkValues(lettRemark.text)
                label: qsTr("Remark analysis")
                labelVisible: false
                font.pixelSize: Theme.fontSizeNormal
                color: generic.secondaryColor
                visible: lettRemark.text !== ""
            }
        }
    }
}
