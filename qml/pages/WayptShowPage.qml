import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    property bool lettersFilled : true
    property var  letterExtract: ""
    property var  bracketsFormula: ""

    allowedOrientations: Orientation.All

    onAccepted: {
//        var resLettrs = [];
//        var numberItems = listModel.count;
//        console.log("numberItems " + numberItems)
//        for (var i = 0; i < numberItems; ++i) {
//            var letterid = listModel.get(i).letterid;
//            var lettervalue = listModel.get(i).lettervalue.valueOf();
//            var letterremark = listModel.get(i).remark;
//            console.log("id " + letterid + " val " + lettervalue + " remark " + letterremark)
//            Database.setLetter(generic.gcId, generic.wpId, letterid, letter, lettervalue, letterremark)
//        }
        Database.setWayptFound(generic.gcId, generic.wpId, generic.wpFound)
        if (!generic.wpIsWp) {
            Database.setCacheFound(generic.gcId, generic.wpFound)
            generic.cachesDirty = true
        }
        generic.multiDirty = true
        pageStack.pop()
    }

    ListModel {
        id: listModel

        function update()
        {
            listModel.clear();
            var waypt = Database.getOneWaypt(generic.wpId)
            console.log("This waypt: " + JSON.stringify(waypt))
            generic.wpNumber = waypt.waypoint
            generic.wpForm   = waypt.formula
            generic.wpNote   = waypt.note
            generic.wpIsWp   = waypt.iswp
            generic.wpFound  = waypt.found

            var lettrs = waypt.letters;
            lettersFilled = lettrs.length > 0
            console.log( "Waypt letters: " + JSON.stringify(lettrs) );
            for (var i = 0; i < lettrs.length; ++i) {
                listModel.append(lettrs[i]);
            }
            console.log( "listModel Letters updated");
            generic.allLetters = Database.getLetters(generic.gcId);
            letterExtract      = TF.lettersFromRaw(txtNote.text)
            bracketsFormula    = TF.addParentheses(generic.wpForm, "", generic.allLetters)
            generic.wayptDirty = false
        }
    }

    Component.onCompleted: listModel.update()

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 1.0
//        radius: 10
        visible: generic.nightCacheMode
    }

    SilicaFlickable {
        id: wpView

        anchors {
            fill: parent
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.paddingMedium
        }
        contentHeight: column.height + Theme.itemSizeMedium
        quickScroll : true

        Rectangle {
            visible: generic.wayptDirty
            anchors {
                fill: pageHeader
                centerIn: pageHeader
            }
            color: generic.highlightBackgroundColor
            opacity: 1.0
            Label {
                anchors.centerIn: parent
                text: qsTr("Click to refresh")
                color: generic.primaryColor
                font.pixelSize: Theme.fontSizeHuge
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: listModel.update()
                enabled: generic.wayptDirty
            }
        }

        PageHeader {
            id: pageHeader
            title: generic.gcCode + (generic.wpIsWp ? " WP " + generic.wpNumber : qsTr(" Find cache!") ) + "    "
        }
        VerticalScrollDecorator { flickable: wpView }

        Icon {
            id: iconContainer
            anchors {
                right: parent.right
                verticalCenter: pageHeader.verticalCenter
            }

            source: TF.wayptIconUrl( generic.wpIsWp )
            color: generic.highlightColor
        }

        IconButton {
            id: iconClipboard
            anchors {
                right: parent.right
                top: pageHeader.bottom
            }

            icon.source: "image://theme/icon-m-clipboard"
            icon.color: generic.primaryColor
//            visible: TF.formulaSolved (wpcalc.text)
            onClicked: {
                Clipboard.text = wpcalc.text
            }
        }

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

            spacing: Theme.paddingSmall

            TextArea {
                id: wpcalc
                width: parent.width - iconClipboard.width
                readOnly: true
                label: qsTr("Calculated")
                text: TF.evalFormula(generic.wpForm, generic.allLetters)
                visible: true
                color: generic.primaryColor
            }

            TextArea {
                id: txtNote
                width: parent.width
                readOnly: true
                text: generic.wpNote
                label: qsTr("Note")
                visible: TF.trimString(generic.wpNote) !== ""
                color: generic.primaryColor
            }

//            TextArea {
//                width: parent.width
//                readOnly: true
//                text: qsTr("This waypoint has no letters attached. Click button to add them.")
//                visible: letterExtract !== "" && !lettersFilled
//                color: generic.highlightColor
//            }

//            Button {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: qsTr("Add letters: " + letterExtract)
//                visible: letterExtract !== "" && !lettersFilled
//                color: generic.primaryColor
//                onClicked: {

//                }
//            }

            Repeater {
                model: listModel
                width: parent.width

                ListItem {
                    width: parent.width
                    height: rectLetter.height + Theme.paddingSmall


                    Rectangle {
                        id: rectLetter
                        width: parent.width
                        height: Theme.itemSizeMedium
                        color: generic.highlightBackgroundColor
                        opacity: 0.85

                        TextField {
                            id: lettValue
                            anchors.centerIn: parent
                            text: letter + " = " + (lettervalue === "" ? "<?>" : lettervalue) + qsTr(". Click to change")
//                            font.bold: true
                            labelVisible: false
                            readOnly: true
                            horizontalAlignment: TextInput.AlignHCenter
                            color: generic.primaryColor
                            opacity: 1.0
                            onClicked: {
                                generic.lettEdit  = letter
                                pageStack.push(Qt.resolvedUrl("LetterPage.qml"),
                                               {"letterid": letterid})
                            }
                        }
                    }
                }
            }

            IconTextSwitch {
                id: isFound
                text: TF.wayptFoundButton(generic.wpIsWp, generic.wpFound)
                icon.source: TF.foundIconUrl(generic.wpFound)
                icon.color: generic.primaryColor
                checked: generic.wpFound
                onClicked: {
                    generic.wpFound = !generic.wpFound
                    if (generic.wpFound) {
                        dialog.accept()
                    }
                }
            }

            SectionHeader {
                text: qsTr("Overview")
                color: generic.highlightColor
            }

            TextArea {
                id: txtFormula
                width: parent.width
                readOnly: true
                label: qsTr("Original formula")
                text: generic.wpForm
                font.pixelSize: Theme.fontSizeExtraSmall
                color: generic.secondaryColor
                visible: generic.wpForm !== wpcalc.text
            }

            TextArea {
                width: parent.width
                readOnly: true
                label: qsTr("All values")
                text: TF.showLetters(generic.allLetters)
                font.pixelSize: Theme.fontSizeExtraSmall
                color: generic.secondaryColor
            }

        }

        RemorsePopup { id: remorse }

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete waypoint")
                onClicked: remorse.execute("Clearing waypoint", function() {
                    console.log("Remove waypt id " + generic.wpId)
                    Database.deleteWaypt(generic.wpId, generic.gcId)
                    generic.multiDirty = true
                    pageStack.pop()
                })
            }
            MenuItem {
                text: "Edit waypoint"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("WayptAddPage.qml"),
                                   {"wayptid": generic.wpId})
                }
            }
        }
    }
}
