import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: wayptsPage

//    wayptsPage.onOpened() { listModel.update() }
    allowedOrientations: Orientation.All

    ListModel {
        id: listModel

        function update()
        {
            listModel.clear();
            var waypts = Database.getWaypts(generic.gcId);
            for (var i = 0; i < waypts.length; ++i) {
                listModel.append(waypts[i]);
//                console.log( JSON.stringify(waypts[i]));
            }
            console.log( "listModel MultiShow updated");
            generic.allLetters = Database.getLetters(generic.gcId)

        }
    }

    Component.onCompleted: listModel.update()

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
            model: listModel

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
                enabled: listModel.count === 0
                text: "No waypoints yet"
                hintText: "Pull down to add them"
            }

            delegate: ListItem {
                id: listItem
//                menu: contextMenu

                width: parent.width
                contentHeight: Theme.itemSizeExtraSmall
                ListView.onRemove: animateRemoval(listItem)

                Icon {
                    id: iconContainer
                    x: Theme.paddingMedium
                    source: TF.wayptIconUrl( is_waypoint, Theme.colorScheme === Theme.LightOnDark )
                }

//                Label {
//                    id: workAround
//                    width: parent.width

//                    function checkRefresh(isDirty) {
//                        if (isDirty) {
//                            listModel.update()
//                        }
//                        return ""
//                    }

//                    text: checkRefresh(generic.multiDirty)
//                    visible: false
//                }

                Label {
                    anchors.left: iconContainer.right
                    width: parent.width - iconContainer.width - Theme.paddingMedium
                    text: ( is_waypoint ? "WP" + " " + waypoint : "Cache" ) + ": " + TF.evalFormula(formula, generic.allLetters)
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

//                Component {
//                    id: contextMenu
//                    ContextMenu {
//                        MenuItem {
//                            text: qsTr("Edit waypoint")
//                            visible: false
//                            onClicked: {
//                                console.log("Edit " + index + ", id " + cacheid)
//                            }
//                        }
//                        MenuItem {
//                            text: qsTr("Delete waypoint")
//                            onClicked: remorse.execute("Clearing waypoint", function() {
//                                console.log("Remove waypoint " + index + ", id " + wayptid)
//                                Database.deleteWaypt(wayptid, cacheid)
//                                generic.multiDirty = true
//                            })
//                        }
//                    }
//                }
            }

            VerticalScrollDecorator {}

        }

        RemorsePopup { id: remorse }

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete geocache")
                onClicked: remorse.execute("Clearing geocache", function() {
                    console.log("Remove geocache id " + generic.gcId)
                    Database.deleteCache(generic.gcId)
                    pageStack.pop()
                    generic.cacheDirty = true
                })
            }
            MenuItem {
                text: qsTr("View in browser")
                onClicked:  {
                    console.log("Browser " + generic.browserUrl + generic.gcCode + ", id " + generic.gcId)
                    ExternalLinks.browse(generic.browserUrl + generic.gcCode)
                }
            }
            MenuItem {
                text: "Add waypoint"
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("WayptAddPage.qml"),
                                              {"wayptid": undefined})
                    generic.multiDirty = true
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
}
