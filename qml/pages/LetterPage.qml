import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    property var    letterid
    property var    callback

    property string lettervalue
    property string letterremark
    property string letter

    function getThisLetter() {
        var letters = Database.getOneLetter(letterid)
        console.log("This letter: " + JSON.stringify(letters))
        if (letters.length > 0) {
            letter       = letters[0].letter
            lettervalue  = letters[0].lettervalue
            letterremark = letters[0].remark
        }
    }

    onAccepted: {
        lettervalue = lettValue.text.valueOf()
//            console.log("letter value: " + lettervalue)
        letterremark = lettRemark.text.valueOf()
//            console.log("letter remark: " + letterremark)
        Database.setLetter(generic.gcId, generic.wpId, letterid, letter, lettervalue, letterremark)
        generic.allLetters = Database.getLetters(generic.gcId)
        dialog.callback(true)
    }

    onRejected: {
        dialog.callback(false)
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
                readOnly: true
                visible: generic.wpNote !== ""
                labelVisible: false
                text: generic.wpNote
                color: generic.secondaryColor
            }

            TextField {
                id: lettValue
                width: parent.width
                text: lettervalue
                label: qsTr("Value for: ") + letter
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                focus: true
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: lettRemark.focus = true
            }

            TextField {
                id: lettRemark
                width: parent.width
                text: letterremark
                placeholderText: label
                label: qsTr("Optional remark")
                color: generic.primaryColor
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: lettRemark.focus = false
            }

            TextArea {
                width: parent.width
                readOnly: true
                text: TF.remarkValues(lettRemark.text)
                label: qsTr("Remark analysis")
                labelVisible: false
                font.pixelSize: Theme.fontSizeExtraSmall
                color: generic.secondaryColor
                visible: lettRemark.text !== ""
            }
        }
    }
}
