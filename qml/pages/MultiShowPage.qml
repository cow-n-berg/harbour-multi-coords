import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: wayptsPage

    allowedOrientations: Orientation.All

    property var smallPrint : false

    ListModel {
        id: listModel

        function update()
        {
            generic.allLetters = Database.getLetters(generic.gcId)
//            console.log( JSON.stringify(generic.allLetters));
            listModel.clear();
            var waypts = Database.getWaypts(generic.gcId);
            for (var i = 0; i < waypts.length; ++i) {
                listModel.append(waypts[i]);
//                console.log( JSON.stringify(waypts[i]));
            }
//            console.log( "listModel MultiShow updated");
            generic.multiDirty = false
            smallPrint = listModel.count > 11
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
        id: flickGC
        anchors {
            fill: parent
            leftMargin: Theme.paddingSmall
            rightMargin: Theme.paddingSmall
        }
        contentHeight: column.height
        quickScroll : true

        VerticalScrollDecorator {}

        Rectangle {
            visible: generic.multiDirty
            anchors {
                top: parent.top

            }
            width: parent.width
            height: Theme.itemSizeExtraLarge
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
                enabled: generic.multiDirty
            }
        }

        Rectangle {
            visible: generic.multiDirty
            width: parent.width
            height: Theme.itemSizeExtraLarge
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
                enabled: generic.multiDirty
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader {
                id: pageHeader
                title: generic.gcCode + " - " + generic.gcName
            }

            ColumnView  {
                id: columnView
                model: listModel

                width: parent.width
                itemHeight: Theme.itemSizeExtraLarge + Theme.paddingMedium


                ViewPlaceholder {
                    id: placeh
                    enabled: listModel.count === 0
                    text: "No waypoints yet"
                    hintText: "Pull down to add them"
                }

                delegate: BackgroundItem {
                    id: listItem
//                    menu: contextMenu

                    width: parent.width

//                  ListView.onRemove: animateRemoval(listItem)

                    Icon {
                        id: iconContainer
                        x: Theme.paddingSmall
                        source: TF.wayptIconUrl( is_waypoint )
                        color: generic.primaryColor
                    }

                    TextArea {
                        id: wpDescr
                        anchors.left: iconContainer.right
                        width: parent.width - iconContainer.width - 2 * Theme.paddingSmall
                        height: Theme.itemSizeExtraLarge + Theme.paddingSmall
                        text: ( is_waypoint ? "WP" + " " + waypoint : "Cache" ) + ": " + TF.evalFormula(formula, generic.allLetters) + TF.reqWpLetters( generic.allLetters, wayptid )
                        font.pixelSize: Theme.fontSizeMedium
                        color: found ? generic.secondaryColor : generic.primaryColor
                        readOnly: true
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
                    }
                }
            }
        }

        RemorsePopup { id: remorse }

        PullDownMenu {
            MenuItem {
                text: qsTr("Delete geocache")
                onClicked: remorse.execute("Clearing geocache", function() {
                    console.log("Remove geocache id " + generic.gcId)
                    Database.deleteCache(generic.gcId)
                    pageStack.pop()
                    generic.cachesDirty = true
                })
            }
            MenuItem {
                text: qsTr("Clear letter values")
                onClicked: remorse.execute("Clearing letter values", function() {
                    console.log("Clear letter values " + generic.gcId)
                    Database.clearValues(generic.gcId)
                    generic.multiDirty = true
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
                }
            }
        }
//        PushUpMenu {
//            MenuItem {
//                text: qsTr("Refresh")
//                onClicked: listModel.update()
//            }
//        }

    }
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
