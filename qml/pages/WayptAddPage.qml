import QtQuick 2.6
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    allowedOrientations: Orientation.All

    property var wayptid
    property var callback
    property var template
    property var maxNumber

    property bool   addNewWp  : true
    property string wpNumber  : ""
    property string rawText   : ""
    property string formula   : ""
    property string wpNote    : ""
    property bool   wpIsWp    : true
    property bool   wpFound   : false
    property string wpLetters : ""
    property var    letterExtract: TF.lettersFromRaw(txtNote.text, generic.allLetters, wayptid)

    property var regExPar1  : /\(/g;
    property var regExPar2  : /\)/g;
    property var regExTimes : /x/g;
    property var regExDivid : /÷/g;
    property var regExMinus : /–/g;
    property var regExComma : /,/g;

    canAccept: txtFormula.text !== "" && txtWpNr.text !== ""

    onAccepted: {
        rawText = txtRaw.text === "" ? txtFormula.text : txtRaw.text
        Database.addWaypt(generic.gcId, wayptid, txtWpNr.text, txtFormula.text, rawText, txtNote.text, isWP.checked, wpFound, txtLetters.text.trim())
        dialog.callback(true, false)
    }

    onRejected: {
        dialog.callback(false, false)
    }

    function getThisWaypt(wayptid) {
        if (wayptid === undefined) {
            addNewWp  = true
            wpNumber  = maxNumber + 1
            rawText   = ""
            formula   = generic.provideLatLon ? template : ""
            wpNote    = ""
            wpIsWp    = true
            wpFound   = false
            wpLetters = ""
            isWP.checked = wpIsWp
            txtWpNr.focus = true
        }
        else {
            var waypt = Database.getOneWaypt(wayptid)
            console.log("This waypt: " + JSON.stringify(waypt))
            addNewWp  = false
            wpNumber  = waypt.waypoint
            rawText   = waypt.rawtext
            formula   = waypt.formula
            wpNote    = waypt.note
            wpIsWp    = waypt.iswp
            wpFound   = waypt.found
            wpLetters = waypt.letterstr
            isWP.checked = wpIsWp === 1
            txtWpNr.focus = txtWpNr.txt === ""
            txtNote.text  = wpNote

        }
    }

    Component.onCompleted: getThisWaypt(wayptid);

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 1.0
        visible: generic.nightCacheMode
    }

    SilicaFlickable {
        id: wpView

        PageHeader {
            id: pageHeader
            title: generic.gcCode + (addNewWp ? " - Add WP " : " - Edit WP ")+ "    "
        }

        VerticalScrollDecorator { flickable: wpView }

        anchors {
            fill: parent
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.paddingMedium
        }
        contentHeight: column.height + 2 * Theme.itemSizeMedium
        quickScroll : true

        Icon {
            id: iconContainer
            anchors {
                right: parent.right
                verticalCenter: pageHeader.verticalCenter
            }

            source: TF.wayptIconUrl( wpIsWp )
            color: generic.highlightColor
        }

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

            spacing: Theme.paddingSmall

            TextField {
                id: txtWpNr
                width: parent.width
                text: wpNumber
                label: qsTr("Waypoint number")
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    if (txtFormula.text === "") {
                        txtFormula.focus = true
                    }
                    else {
                        focus = false
                    }
                }
            }

            TextSwitch {
                id: isWP
                text: qsTr("Waypoint is ") + (checked ? qsTr("just a waypoint") : qsTr("the cache location") )
            }

            SectionHeader {
                text: qsTr("Formula editing")
                color: generic.highlightColor
            }

            TextArea {
                id: description1
                width: parent.width
                height: Screen.height / 6
                text: qsTr("All information between brackets [] will be evaluated, e.g. [A+1]. Parentheses () are for calculations like [(B+3)/2]. Use squares like A*A, instead of A^2 or A². The buttons below may help with editing. The [A] button won't replace NSEW in the formula.")
                label: qsTr("Formula conventions")
                labelVisible: false
                color: generic.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: generic.showDialogHints
            }

            TextArea {
                id: txtFormula
                width: parent.width
                label: qsTr("Formula to be processed")
                text: formula
                placeholderText: label
                placeholderColor: generic.secondaryColor
                font.pixelSize: Theme.fontSizeLarge
                color: generic.primaryColor
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    if (txtNote.text === "") {
                        txtNote.focus = true
                    }
                    else {
                        focus = false
                    }
                }
            }

            ButtonLayout {
                preferredWidth: Theme.buttonWidthExtraSmall
                Button {
                    text: "() » [()]"
                    color: generic.primaryColor
                    onClicked: {
                        txtFormula.text = txtFormula.text.replace(regExPar1, '[(')
                        txtFormula.text = txtFormula.text.replace(regExPar2, ')]')
                        // nog een keer precies kijken met zoekterm /\[\[.+?\]\]/g
                    }
                }
                Button {
                    text: "A » [A]"
                    color: generic.primaryColor
                    onClicked: {
                        txtFormula.text = TF.addParentheses(txtFormula.text, txtLetters.text, generic.allLetters)
                    }
                }
                Button {
                    text: "x÷–, » */-"
                    color: generic.primaryColor
                    onClicked: {
                        txtFormula.text = txtFormula.text.replace(regExTimes, '*')
                        txtFormula.text = txtFormula.text.replace(regExDivid, '/')
                        txtFormula.text = txtFormula.text.replace(regExMinus, '-')
                        txtFormula.text = txtFormula.text.replace(regExComma, '')
                    }
                }
                Button {
                    text: qsTr("From raw")
                    enabled: txtRaw.text !== ""
                    color: generic.primaryColor
                    onClicked: {
                        txtFormula.text = txtRaw.text
                    }
                }

            }

            TextArea {
                id: txtRaw
                width: parent.width
                readOnly: true
                label: qsTr("Imported raw text")
                text: rawText
                placeholderText: qsTr("No raw text has been imported")
                placeholderColor: generic.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                color: generic.secondaryColor
                visible: text !== ""
            }

            TextArea {
                id: txtNote
                width: parent.width
                text: wpNote
                placeholderText: label
                placeholderColor: generic.secondaryColor
                label: qsTr("Note")
                color: generic.primaryColor
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    if (txtLetters.text === "") {
                        txtLetters.focus = true
                    }
                    else {
                        focus = false
                    }
                }
            }

            SectionHeader {
                text: qsTr("Letters for this waypoint")
                color: generic.highlightColor
            }

            ButtonLayout {
                preferredWidth: Theme.buttonWidthExtraSmall
                Button {
                    text: letterExtract === "" ? qsTr("No letters?") : qsTr("Use ") + letterExtract
                    enabled: letterExtract !== ""
                    color: generic.primaryColor
                    onClicked: {
                        txtLetters.text = letterExtract
                        txtLetters.focus = true
                    }
                }
                Button {
                    text: qsTr("Reset")
                    color: generic.primaryColor
                    onClicked: {
                        txtLetters.text = ""
                        Database.deleteLetters(generic.wpId)
                        dialog.callback(true)
                    }
                }
            }

            TextArea {
                id: description2
                width: parent.width
                height: Screen.height / 6
                text: qsTr("The button above might copy the letters from the description. Normally, letters should be space separated. E.g. 'A B' will lead to two letters 'A' and 'B'. You are not confined to single characters: entering 'ABC' will lead to one letter 'ABC', but A, B and C will also be evaluated separately.")
                label: qsTr("How to add letters to a waypoint")
                labelVisible: false
                color: generic.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: generic.showDialogHints
            }

            TextField {
                id: txtLetters
                width: parent.width
                text: wpLetters
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: errorHighlight ? generic.highlightColor : generic.primaryColor
                label: qsTr("Letters, space separated, or like ABC")
                validator: RegExpValidator { regExp: /[a-zA-Z ]*/ }
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: dialog.accept()
            }

            SectionHeader {
                text: qsTr("Overview of entire geocache")
                color: generic.highlightColor
            }

            TextArea {
                width: parent.width
                readOnly: true
                label: qsTr("All letters (so far)")
                labelVisible: false
                text: Database.showCacheLetters(generic.gcId)
                font.pixelSize: Theme.fontSizeExtraSmall
                color: generic.secondaryColor
            }

        }

    }
}
