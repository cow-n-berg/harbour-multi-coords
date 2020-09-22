import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: page

    allowedOrientations: Orientation.All

    property var callback

    property bool hideFound: false

    property var waypts

    function updateAfterDialog(updated) {
        if (updated) {
            listModel.update()
        }
    }

    Timer {
        id: callbackTimer
        interval: 500
        running: false
        onTriggered: {
            page.callback(true)
        }
    }

    ListModel {
        id: listModel

        function update()
        {
            generic.allLetters = Database.getLetters(generic.gcId)
            listModel.clear();
            waypts = Database.getWaypts(generic.gcId, hideFound);
            for (var i = 0; i < waypts.length; ++i) {
                listModel.append(waypts[i]);
            }
            callbackTimer.start()
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
                itemHeight: Theme.itemSizeExtraLarge + Theme.paddingSmall

                ViewPlaceholder {
                    id: placeh
                    enabled: listModel.count === 0
                    text: "No waypoints yet"
                    hintText: "Pull down to add them"
                }

                delegate: BackgroundItem {
                    id: listItem

                    width: parent.width

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
                            pageStack.push(Qt.resolvedUrl("WayptShowPage.qml"),
                                           {callback: updateAfterDialog})
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
                    page.callback(true)
                    pageStack.pop()
                })
            }
            MenuItem {
                text: qsTr("Clear letter values")
                onClicked: remorse.execute("Clearing letter values", function() {
                    console.log("Clear letter values " + generic.gcId)
                    Database.clearValues(generic.gcId)
                    listModel.update()
                })
            }
            MenuItem {
                text: qsTr("Calculations")
                visible: generic.gcCode === "GC8Y39T"
                onClicked:  {
                    onClicked: pageStack.push(Qt.resolvedUrl("Calculations.qml"),
                                              {callback: updateAfterDialog})
                }
            }
            MenuItem {
                text: qsTr("Add waypoint")
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("WayptAddPage.qml"),
                                              {wayptid: undefined, callback: updateAfterDialog})
                }
            }
        }
        PushUpMenu {
            MenuItem {
                text: hideFound ? qsTr("Unhide found waypoints") : qsTr("Hide found waypoints")
                onClicked: {
                    hideFound = !hideFound
                    listModel.update()
                }
            }
            MenuItem {
                text: qsTr("Calculations")
                visible: generic.calculationMenu
                onClicked:  {
                    onClicked: pageStack.push(Qt.resolvedUrl("Calculations.qml"))
                }
            }
            MenuItem {
                text: qsTr("View in browser")
                onClicked:  {
                    console.log("Browser " + generic.browserUrl + generic.gcCode + ", id " + generic.gcId)
                    ExternalLinks.browse(generic.browserUrl + generic.gcCode)
                }
            }
        }
    }
}
