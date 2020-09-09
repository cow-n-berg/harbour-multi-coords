import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: cachesPage

    anchors {
        fill: parent
    }

    allowedOrientations: Orientation.Portrait

    property var numberOfCaches : 0
    property var numberOfFinds  : 0

    ListModel {
        id: listModel

        function update()
        {
            listModel.clear();
            numberOfFinds = 0;
            var caches = Database.getGeocaches();
            for (var i = 0; i < caches.length; ++i) {
                listModel.append(caches[i]);
                numberOfFinds += caches[i].found ? 1 : 0;
                console.log( JSON.stringify(caches[i]));
            }
            console.log( "listModel Caches updated");
            console.log(JSON.stringify(listModel.get(0)));
            generic.cachesDirty = false;
            numberOfCaches = caches.length;
        }
    }

    Component.onCompleted: listModel.update();

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 1.0
//        radius: 10
        visible: generic.nightCacheMode
    }

    SilicaListView {
        id: gcListView
        model: listModel

        anchors {
            fill: parent
            leftMargin: Theme.paddingMedium
            rightMargin: Theme.paddingMedium
        }
        spacing: Theme.paddingMedium

        header: PageHeader {
            id: pageHeader
            title: ( numberOfCaches ? numberOfCaches : qsTr("No")) + " " + qsTr("Geocaches") + ( numberOfFinds ? ", " + numberOfFinds + " " + qsTr("Found") : "")
        }

        Rectangle {
            visible: generic.cachesDirty
            anchors {
                top: parent.top

            }
            width: parent.width
            height: Theme.itemSizeExtraLarge
            color: generic.highlightBackgroundColor
            opacity: 1.0
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Click to refresh")
                color: generic.primaryColor
                font.pixelSize: Theme.fontSizeHuge
                font.bold: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: listModel.update()
                enabled: generic.cachesDirty
            }
        }

        ViewPlaceholder {
            id: placeh
            enabled: listModel.count === 0
            text: "No geocaches yet"
            hintText: "Pull down to add,\nor go to Settings for examples"
        }

        delegate: ListItem {
            id: listItem
            menu: contextMenu

            width: parent.width
            contentHeight: Theme.itemSizeSmall
            ListView.onRemove: animateRemoval(listItem)

            Label {
                id: nameGC
                text: TF.truncateString(name, 35)
                font.pixelSize: Theme.fontSizeMedium
                anchors {
                    left: parent.left
                    right: foundGC.left
                    margins: Theme.paddingSmall
                }
                color: generic.primaryColor
            }
            onClicked: {
                console.log("Clicked GC " + index)
                generic.gcName = name
                generic.gcCode = geocache
                generic.gcId   = cacheid

                pageStack.push(Qt.resolvedUrl("MultiShowPage.qml"))
            }
//            onPressAndHold: {
//            }

            Label {
                id: codeGC
                text: geocache
                font.pixelSize: Theme.fontSizeSmall
                color: generic.secondaryColor
                anchors {
                          top: nameGC.bottom
                          left: parent.left
                          right: foundGC.left
                          margins: Theme.paddingSmall
                        }
            }

            Icon {
                id: foundGC
                anchors {
                          right: parent.right
                          margins: Theme.paddingSmall
                        }
                source: TF.foundIconUrl(found)
                color: generic.primaryColor
            }

            Separator {
                width: parent.width
                color: generic.secondaryColor
            }

            RemorsePopup { id: remorse }

            Component {
                id: contextMenu
                ContextMenu {
                    MenuItem {
                        text: qsTr("View in browser")
                        onClicked:  {
                            console.log("Browser " + generic.browserUrl  + geocache + ", id " + cacheid)
                            ExternalLinks.browse(generic.browserUrl + geocache)
                        }
                    }
//                    MenuItem {
//                        text: qsTr("Edit")
//                        onClicked: {
//                            console.log("Edit " + index + ", id " + listModel[model.index].cacheid)
//                            generic.cachesDirty = true
//                        }
//                    }
//                    MenuItem {
//                        text: qsTr("Delete")
//                        onClicked: remorse.execute("Clearing geocache", function() {
//                            console.log("Remove geocache " + codeGC.text)
////                            Database.deleteCache(codeGC.text)
//                            generic.cachesDirty = true
//                        })
//                    }

                }
            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                text: qsTr("Add Geocache Multi")
                onClicked: pageStack.push(Qt.resolvedUrl("MultiAddPage.qml"))
            }
        }
        PushUpMenu  {
            enabled: generic.debug
//            MenuItem {
//                text: qsTr("Refresh")
//                onClicked: listModel.update()
//            }
            MenuItem {
                text: qsTr("Show Contents DB in Console")
                enabled: generic.debug
                onClicked: Database.showAllData()
            }
        }

        VerticalScrollDecorator {}

    }
}
