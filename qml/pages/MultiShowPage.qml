import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: wayptsPage

//    wayptsPage.onOpened() { listModelWP.updateWP() }
    allowedOrientations: Orientation.All

    ListModel {
        id: listModelWP

        function updateWP()
        {
            listModelWP.clear();
            var waypts = Database.getWaypts(generic.gcId);
            for (var i = 0; i < waypts.length; ++i) {
                listModelWP.append(waypts[i]);
                console.log( JSON.stringify(waypts[i]));
            }
            console.log( "listModelWP updated");
            generic.allLetters = Database.getLetters(generic.gcId)

        }
    }

    Component.onCompleted: listModelWP.updateWP()

    SilicaFlickable {

        anchors {
            fill: parent
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.paddingMedium
        }

        PageHeader {
            id: pageHeader
            title: generic.gcCode + " - " + generic.gcName
        }

        SilicaListView {
            id: listViewWP
            model: listModelWP

            height: parent.height - pageHeader.height
//            width: parent.width - 2 * Theme.paddingMedium
            width: parent.width
            anchors {
                top: pageHeader.bottom
                leftMargin: Theme.paddingMedium
            }
            spacing: Theme.paddingLarge

            ViewPlaceholder {
                id: placeh
                enabled: listModelWP.count === 0
                text: "No waypoints yet"
                hintText: "Pull down to add them"
            }

            delegate: ListItem {
                id: listItem
                menu: contextMenu

                width: parent.width
                contentHeight: Theme.itemSizeExtraSmall
                ListView.onRemove: animateRemoval(listItem)

                Icon {
                    id: iconContainer
                    x: Theme.paddingMedium
                    source: TF.wayptIconUrl( is_waypoint, Theme.colorScheme === Theme.LightOnDark )
                }

                Label {
                    anchors.left: iconContainer.right
                    width: parent.width - iconContainer.width - Theme.paddingMedium
                    text: ( is_waypoint ? "WP" + " " + index : "Cache" ) + ": " + TF.evalFormula(formula, generic.allLetters)
                    color: found ? Theme.secondaryColor : Theme.primaryColor
                    truncationMode: TruncationMode.Elide
                }
                onClicked: {
                    generic.wpId     = wayptid
                    generic.wpNumber = waypoint
                    generic.wpForm   = formula
                    generic.wpNote   = note
                    generic.wpIsWp   = is_waypoint
                    generic.wpFound  = found
                    console.log("Clicked WP " + index)
                    pageStack.push(Qt.resolvedUrl("WayptShowPage.qml"))
                }

                RemorsePopup { id: remorse }

                Component {
                    id: contextMenu
                    ContextMenu {
                        MenuItem {
                            text: qsTr("Edit")
                            visible: false
                            onClicked: {
                                console.log("Edit " + index + ", id " + cacheid)
                                Database.deleteCache(cacheid)
                                listModelGC.updateGC()
                            }
                        }
                        MenuItem {
                            text: qsTr("Delete")
                            onClicked: remorse.execute("Clearing", function() {
                                console.log("Remove " + index + ", id " + cacheid)
                                Database.deleteCache(cacheid)
                                listModelGC.updateGC()
                            })
                        }
                    }
                }
            }

            VerticalScrollDecorator {}

        }

        PullDownMenu {
            MenuItem {
                text: qsTr("View in browser")
                onClicked:  {
                    console.log("Browser " + generic.browserUrl + generic.gcCode + ", id " + generic.gcId)
                    ExternalLinks.browse(generic.browserUrl + generic.gcCode)
                }
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: listModelWP.updateWP()
            }
            MenuItem {
                text: "Add Waypoint"
                onClicked: {
                }
            }
        }

    }
}
