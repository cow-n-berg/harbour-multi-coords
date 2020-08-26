import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    property string lettervalue
    property string letter : generic.lettEdit

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
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            focus: true
            EnterKey.enabled: text.length > 0
            EnterKey.iconSource: "image://theme/icon-m-enter-close"

            // When Enter key is pressed, accept the dialog
            EnterKey.onClicked: dialog.accept()        }

        TextArea {
            width: parent.width
            readOnly: true
            text: generic.wpNote
//            label: qsTr("Note")
            color: Theme.secondaryColor
        }
    }

    onDone: {
        if (result == DialogResult.Accepted) {
            lettervalue = lettValue.text.valueOf()
            Database.setLetter(letter, lettervalue)
            generic.allLetters = Database.getLetters(generic.gcId)
//            generic.lettEdited = true
        }
    }
}
