import QtQuick 2.6
import Sailfish.Silica 1.0
import "../modules/Opal/Delegates"
import "../modules/Opal/Tabs"

TabItem {
    id: wptsTab

    property var    cache   : generic.cache
    property int    listLen : 0

    ListModel {
        id: wptsModel

        function update(list) {
            wptsModel.clear();
            listLen = list.length;
            for (var i = 0; i < listLen; i++  ) {
                wptsModel.append(list[i]);
            }
        }
    }

    Component.onCompleted: {
        console.log(JSON.stringify(cache))
        console.log(JSON.stringify(cache.waypoints))
        wptsModel.update(cache.waypoints)
    }

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentHeight: listLen * Theme.itemSizeHuge
        flickableDirection: Flickable.VerticalFlick
        quickScroll: true

        VerticalScrollDecorator {
            flickable: flick
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            ViewPlaceholder {
                id: placehInv
                enabled: listLen === 0
                text: qsTr("No waypoints yet")
            }

            DelegateColumn {
                id: colDelWayp
                model: wptsModel

                delegate: ThreeLineDelegate {
                    id: wpt
                    title: number + " | " + descript
                    text: coordinate
                    description: instruction
                    descriptionLabel.wrapped: wrapped

                    onClicked: {
                        //toggleWrappedText(descriptionLabel)
                        wrapped = !wrapped
                    }

                }
            }

        }
    }
}
