import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

//    anchors.fill: parent

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
//            Database.setLetter(letterid, lettervalue, letterremark)
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
            var lettrs = Database.getLettersWP(generic.wpId);
            console.log( "Waypt letters: " + JSON.stringify(lettrs) );
            for (var i = 0; i < lettrs.length; ++i) {
                listModel.append(lettrs[i]);
            }
            console.log( "listModel Letters updated");
            generic.allLetters = Database.getLetters(generic.gcId);
            generic.wayptDirty = false
        }
    }

    Component.onCompleted: listModel.update()

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
            title: generic.gcCode + (generic.wpIsWp ? " WP " + generic.wpNumber : qsTr(" Find cache!") ) + "    "
        }

        VerticalScrollDecorator { flickable: wpView }

        anchors {
            fill: parent
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.paddingMedium
        }
        contentHeight: column.height + Theme.itemSizeMedium
        quickScroll : true

        Icon {
            id: iconContainer
            anchors {
                right: parent.right
                verticalCenter: pageHeader.verticalCenter
            }

            source: TF.wayptIconUrl( generic.wpIsWp )
            color: generic.highlightColor
        }

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

            spacing: Theme.paddingLarge

            TextArea {
                id: wpcalc
                width: parent.width
                readOnly: true
                label: qsTr("Calculated")
                text: TF.evalFormula(generic.wpForm, generic.allLetters)
                visible: true
                color: generic.primaryColor
            }

            TextArea {
                width: parent.width
                readOnly: true
                text: generic.wpNote
                label: qsTr("Description")
                visible: TF.trimString(generic.wpNote) !== ""
                color: generic.primaryColor
            }

            Repeater {
                model: listModel
                width: parent.width

                ListItem {
                    width: parent.width
                    height: lettValue.height + lettRemark.height// + Theme.paddingSmall


                    Rectangle {
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
//                    generic.multiDirty = true
                    pageStack.pop()
                })
            }
            MenuItem {
                text: "Edit waypoint"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("WayptAddPage.qml"),
                                   {"wayptid": generic.wpId})
//                    generic.wayptDirty = true
                }
            }
        }
        PushUpMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: listModel.update()
            }
        }
    }
    Rectangle {
        visible: generic.wayptDirty
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        height: Theme.itemSizeLarge
        color: Theme.highlightBackgroundColor
        opacity: 1.0
        Label {
            anchors.centerIn: parent
            text: qsTr("Pull-up to refresh")
            color: generic.highlightColor
        }
//        MouseArea {
//            anchors.fill: parent
//            onClicked: listModel.update()
//            enabled: generic.wayptDirty
//        }
    }
}
