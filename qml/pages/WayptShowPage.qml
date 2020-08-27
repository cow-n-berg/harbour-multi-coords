import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Page {
    id: thisWayptPage

//    anchors.fill: parent

    allowedOrientations: Orientation.All

    ListModel {
        id: listModelLett

        function updateLett()
        {
            listModelLett.clear();
            var lettrs = Database.getLettersWP(generic.wpId);
            console.log( JSON.stringify(lettrs) );
            for (var i = 0; i < lettrs.length; ++i) {
                listModelLett.append(lettrs[i]);
            }
            console.log( "listModelLett updated");
            generic.allLetters = Database.getLetters(generic.gcId)
        }
    }

    Component.onCompleted: listModelLett.updateLett();

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
                visible: listModelLett.count > 0 && generic.wpForm !== wpcalc.text
            }

            Repeater {
                model: listModelLett
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
                                           {"lettervalue": lettervalue})
                            listModelLett.updateLett();
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
                    Database.setWayptFound(generic.wpId, generic.wpFound)
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
//                visible: listModelLett.count > 0
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
        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: listModelLett.updateLett()
            }
        }
    }
}
