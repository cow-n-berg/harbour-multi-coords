import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Page {
    id: thisWayptPage

//    anchors.fill: parent

    allowedOrientations: Orientation.All

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

        }
    }

    Component.onCompleted: listModel.update()

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

            source: TF.wayptIconUrl( generic.wpIsWp, Theme.colorScheme === Theme.LightOnDark )
            color: Theme.highlightColor
        }

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

//            TextField {
//                id: workAround
//                width: parent.width
//                readOnly: true

//                function checkRefresh(isDirty) {
//                    if (isDirty) {
//                        listModel.update()
//                    }
//                    return ""
//                }

//                text: checkRefresh(generic.wayptDirty)
//                visible: false
//            }

            TextArea {
                id: wpcalc
                width: parent.width
                readOnly: true
                label: qsTr("Calculated")
                text: TF.evalFormula(generic.wpForm, generic.allLetters)
                visible: true
            }

            TextArea {
                width: parent.width
                readOnly: true
                text: generic.wpNote
                label: qsTr("Description")
                visible: TF.trimString(generic.wpNote) !== ""
            }

            SectionHeader {
                text: qsTr("Options")
                visible: listModel.count > 0 && generic.wpForm !== wpcalc.text
            }

            Repeater {
                model: listModel
                width: parent.width

                ListItem {
                    width: parent.width

                    Button {
                        height: Theme.itemSizeMedium
                        preferredWidth: Theme.buttonWidthLarge
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: letter + " = " + (lettervalue === "" ? "<?>" : lettervalue) + qsTr(". Click to change")
                        onClicked: {
                            generic.lettEdit  = letter
                            pageStack.push(Qt.resolvedUrl("LetterPage.qml"),
                                           {"letterid": letterid})
//                            listModel.update();
                        }
                    }

                 }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: TF.wayptFoundButton(generic.wpIsWp, generic.wpFound)
                onClicked: {
                    generic.wpFound = !generic.wpFound
                    Database.setWayptFound(generic.wpId, generic.wpFound, generic.gcId)
                    if (!generic.wpIsWp) {
                        Database.setCacheFound(generic.gcId, generic.wpFound)
                    }
                    if (generic.wpFound) {
                        pageStack.pop()
                    }
                }
            }

            SectionHeader {
                text: qsTr("Calculations")
//                visible: listModel.count > 0
            }
            TextArea {
                width: parent.width
                readOnly: true
                label: qsTr("Original formula")
                text: generic.wpForm
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
                visible: generic.wpForm !== wpcalc.text
            }

            TextArea {
                width: parent.width
                readOnly: true
                label: qsTr("All values")
                text: TF.showLetters(generic.allLetters)
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
//                visible: !generic.wpIsWp
            }

        }

        RemorsePopup { id: remorse }

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete")
                onClicked: remorse.execute("Clearing waypoint", function() {
                    console.log("Remove waypt" + index + ", id " + generic.wpId)
                    Database.deleteWaypt(generic.wpId, generic.gcId)
                    generic.multiDirty = true
                    pageStack.pop()
                })
            }
        }
        PushUpMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: listModel.update()
            }
        }
    }
}
