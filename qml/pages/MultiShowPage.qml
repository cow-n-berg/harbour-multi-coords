import QtQuick 2.6
import Sailfish.Silica 1.0
import "../modules/Opal/Delegates"
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: page

    allowedOrientations: Orientation.All

    property var    callback

    property bool   hideFound: false

    property var    waypts
    property string formulaTemplate: ""
    property int    maxWpNumber    : 0
    property int    listLength

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

        // Available within listModel:
        // cacheid, wayptid, waypoint, formula, calculated, note, is_waypoint, found

        function update()
        {
            generic.allLetters = Database.getLetters(generic.gcId)
            listModel.clear()
            waypts = Database.getWaypts(generic.gcId, hideFound)
            listLength = waypts.length;
            if (listLength > 0) {
                formulaTemplate = TF.formulaTemplate(waypts[0].formula)
            }
            maxWpNumber = 0
            for (var i = 0; i < listLength; ++i) {
                listModel.append(waypts[i])
                maxWpNumber = Math.max(maxWpNumber, waypts[i].waypoint)
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
//            leftMargin: Theme.paddingSmall
//            rightMargin: Theme.paddingSmall
        }
//        contentHeight: column.height
        contentHeight: (listLength + 1) * Theme.itemSizeLarge
        flickableDirection: Flickable.VerticalFlick
        quickScroll : true

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
//            spacing: Theme.paddingSmall

            PageHeader {
                id: pageHeader
                title: generic.gcCode + " - " + generic.gcName
            }

            ViewPlaceholder {
                id: placeh
                enabled: listModel.count === 0
                text: "No waypoints yet"
                hintText: "Pull down to add them"
            }

            DelegateColumn  {
                id: columnView
                model: listModel
                spacing: Theme.paddingSmall

                delegate: TwoLineDelegate {
                    id: wpDelegat
                    text: calculated
                    description: ( is_waypoint ? "WP" + " " + waypoint : "Cache" ) + TF.reqWpLetters( generic.allLetters, wayptid )

                    rightItem: DelegateIconButton {
                        iconSource: TF.wayptIconUrl( is_waypoint, found )
                        iconSize: Theme.iconSizeMedium
                        onClicked: {
                            found = !found
                            Database.setWayptFound(cacheid, wayptid, found)
                            if (!is_waypoint) {
                                Database.setCacheFound(cacheid, found)
                                generic.wpFound = found
                                callbackTimer.start()
                            }
                        }
                    }

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
                text: qsTr("Waypoint calculations")
                visible: generic.calculationMenu || generic.gcCode === "GC8Y39T"
                onClicked:  {
                    onClicked: pageStack.push(Qt.resolvedUrl("Calculations.qml"),
                                              {callback: updateAfterDialog})
                }
            }
            MenuItem {
                text: qsTr("Add waypoint")
                onClicked: {
                    onClicked: pageStack.push(Qt.resolvedUrl("WayptAddPage.qml"),
                                              {wayptid: undefined, callback: updateAfterDialog, template: formulaTemplate, maxNumber: maxWpNumber})
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
                visible: false //generic.calculationMenu
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
