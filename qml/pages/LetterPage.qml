import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    property var    letterid
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

    Component.onCompleted: getThisLetter(letterid);

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Enter value for: " + letter )
        }

        TextField {
            id: lettValue
            width: parent.width
            text: lettervalue
            label: letter
            color: generic.primaryColor
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: true
            EnterKey.enabled: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-next"
            EnterKey.onClicked: lettRemark.focus = true
        }

        TextArea {
            width: parent.width
            readOnly: true
            text: generic.wpNote
            color: generic.secondaryColor
        }

        TextField {
            id: lettRemark
            width: parent.width
            text: letterremark
            placeholderText: label
            label: qsTr("Remark")
            color: generic.primaryColor
            EnterKey.enabled: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-close"

            // When Enter key is pressed, accept the dialog
            EnterKey.onClicked: dialog.accept()
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            lettervalue = lettValue.text.valueOf()
            console.log("letter value: " + lettervalue)
            letterremark = lettRemark.text.valueOf()
            console.log("letter remark: " + letterremark)
            Database.setLetter(letterid, lettervalue, letterremark)
            generic.allLetters = Database.getLetters(generic.gcId)
//            generic.wayptDirty = true
        }
    }
}
