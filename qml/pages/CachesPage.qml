import QtQuick 2.6
import Sailfish.Silica 1.0
import "../modules/Opal/Delegates"
import "../scripts/Database.js" as Database
import "../scripts/ExternalLinks.js" as ExternalLinks
import "../scripts/TextFunctions.js" as TF

Page {
    id: cachesPage

    anchors {
        fill: parent
    }

    allowedOrientations: Orientation.Portrait

    property int  numberOfCaches : 0
    property int  numberOfFinds  : 0
    property bool hideFound      : generic.hideFoundCaches
    property int  listLength

    function updateAfterDialog(updated) {
        if (updated) {
            listModel.update()
//            columnView.scrollToTop()
        }
    }

    ListModel {
        id: listModel

        function update()
        {
            listModel.clear();
            numberOfFinds = 0;
            var caches = Database.getGeocaches(hideFound);
            listLength = caches.length;
            for (var i = 0; i < listLength; ++i) {
                listModel.append(caches[i]);
                numberOfFinds += caches[i].found ? 1 : 0;
                console.log( JSON.stringify(caches[i]));
            }
            console.log( "listModel Caches updated");
            console.log(JSON.stringify(listModel.get(0)));
            numberOfCaches = listLength;
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

    SilicaFlickable {
        id: flickGC
        anchors {
            fill: parent
//            leftMargin: Theme.paddingSmall
//            rightMargin: Theme.paddingSmall
        }
//        contentHeight: column.height
        contentHeight: listLength * Theme.itemSizeLarge
        flickableDirection: Flickable.VerticalFlick
        quickScroll : true

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
//            spacing: Theme.paddingSmall

            PageHeader {
                id: pageHeader
                title: ( numberOfCaches ? numberOfCaches : qsTr("No")) + " " + qsTr("Geocaches") + ( hideFound ? qsTr(" to be found") : ", " + numberOfFinds + " " + qsTr("Found"))
            }

            ViewPlaceholder {
                id: placeh
                enabled: listModel.count === 0
                text: "No geocaches yet"
                hintText: "Pull down to add,\nor go to Settings for examples"
            }

            DelegateColumn  {
                id: columnView
                model: listModel
                spacing: Theme.paddingSmall

                delegate: TwoLineDelegate {
                    id: cacheDelegat
                    text: name
                    description: geocache

                    rightItem: DelegateIconButton {
                        iconSource: TF.foundIconUrl(found)
                        iconSize: Theme.iconSizeMedium
                    }

                    onClicked: {
                        console.log("Clicked GC " + index)
                        generic.gcName = name
                        generic.gcCode = geocache
                        generic.gcId   = cacheid

                        pageStack.push(Qt.resolvedUrl("MultiShowPage.qml"),
                                       {callback: updateAfterDialog})
                    }
                }
            }


            RemorsePopup { id: remorse }

//            Component {
//                id: contextMenu
//                ContextMenu {
//                    MenuItem {
//                        text: qsTr("View in browser")
//                        onClicked:  {
//                            console.log("Browser " + generic.browserUrl  + geocache + ", id " + cacheid)
//                            ExternalLinks.browse(generic.browserUrl + geocache)
//                        }
//                    }

//                }
//            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"),
                                          {callback: updateAfterDialog})
            }
            MenuItem {
                text: qsTr("Add Geocache Multi")
                onClicked: pageStack.push(Qt.resolvedUrl("MultiAddPage.qml"),
                                          {callback: updateAfterDialog})
            }
        }
        PushUpMenu {
            MenuItem {
                text: hideFound ? qsTr("Unhide found geocaches") : qsTr("Hide found geocaches")
                onClicked: {
                    hideFound = !hideFound
                    generic.hideFoundCaches = hideFound
                    Database.setSetting( "hideFoundCaches", generic.hideFoundCaches )
                    listModel.update()
                }
            }
            MenuItem {
                text: qsTr("Show Contents DB in Console")
                enabled: generic.debug
                visible: generic.debug
                onClicked: Database.showAllData()
            }
        }
    }
}
