import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: cachesPage

    anchors {
        fill: parent
        leftMargin: Theme.paddingMedium
        rightMargin: Theme.paddingMedium
    }

    allowedOrientations: Orientation.All

    ListModel {
        id: listModel

        function update()
        {
            listModel.clear();
            var caches = Database.getGeocaches();
            for (var i = 0; i < caches.length; ++i) {
                listModel.append(caches[i]);
                console.log( JSON.stringify(caches[i]));
            }
            console.log( "listModel Caches updated");
            console.log(JSON.stringify(listModel.get(0)));
        }
    }

    Component.onCompleted: listModel.update();

    SilicaListView {
        id: gcListView
        model: listModel

        anchors.fill: parent
        spacing: Theme.paddingLarge

        header: PageHeader {
            id: pageHeader
            title: qsTr("All Geocaches")
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

//            height: contentItem.childrenRect.height
//            anchors.margins: Theme.paddingLarge

//            Label {
//                id: workAround
//                width: parent.width

//                function checkRefresh(isDirty) {
//                    if (isDirty) {
//                        listModel.update()
//                    }
//                    return ""
//                }

//                text: checkRefresh(generic.cachesDirty)
//                visible: false
//            }

            Label {
                id: nameGC
                text: TF.truncateString(name, 35)
                font.pixelSize: Theme.fontSizeMedium
                anchors {
                    left: parent.left
                    right: foundGC.left
                    margins: Theme.paddingSmall
                }
//                width: parent.width - foundGC.width
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
                color: Theme.secondaryColor
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
                source: TF.foundIconUrl(found, Theme.colorScheme === Theme.LightOnDark)
            }

            Separator {
                width: parent.width
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
//                            generic.cacheDirty = true
//                        }
//                    }
//                    MenuItem {
//                        text: qsTr("Delete")
//                        onClicked: remorse.execute("Clearing geocache", function() {
//                            console.log("Remove geocache " + codeGC.text)
////                            Database.deleteCache(codeGC.text)
//                            generic.cacheDirty = true
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
            MenuItem {
                text: qsTr("Refresh")
                onClicked: listModel.update()
            }
            MenuItem {
                text: qsTr("Show Contents DB in Console")
                onClicked: Database.showAllData()
            }
        }

        VerticalScrollDecorator {}

    }
}
