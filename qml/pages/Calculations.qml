import QtQuick 2.6
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
//import "../modules/ExpandingColumn.qml"
import "../scripts/Database.js" as Database
import "../scripts/Calculations.js" as Calc
import "../scripts/TextFunctions.js" as TF

Page {
    id: page

    allowedOrientations: Orientation.All

    property var callback

    property var    waypts
    property int    listLength
    property int    maxWaypt   : 0
    property string projCoord  : ""
    property string moveCoord  : ""
    property string distAngle  : ""
    property string intersect1 : ""
    property string intersect2 : ""
    property var    intersect3
    property var    intersect4
    property var    circle
    property string wgsCoord1  : ""
    property string wgsCoord2  : ""
    property real   distance   : 0
    property string notify     : ""

    property bool   addEnabled : true

    property string wp1  : "0"
    property string wp2  : "0"
    property string wp3  : "0"
    property string wp4  : "0"
    property string wp5  : "0"
    property string wp11 : "0"
    property string wp21 : "0"
    property string wp22 : "0"
    property string wp23 : "0"
    property string wp24 : "0"
    property string wp31 : "0"
    property string wp32 : "0"
    property string wp41 : "0"
    property string wp42 : "0"
    property string wp51 : "0"
    property string wp52 : "0"
    property string wp61 : "0"
    property string wp62 : "0"
    property string wp71 : "0"
    property string wp72 : "0"
    property string wp73 : "0"
    property string wp81 : "0"

    property string projText   : "" // "Projection of WP " + wp11 + ": " + deg1.text + "° and " + dist1.text + " m"
    property string moveText   : "" // "Moving WP " + wp81 + ": " + dist2.text + " m North, " + dist3.text + " m East"
    property string interText1 : "" // "Intersection of lines WPs " + wp21 + "-" + wp22 + " and " + wp23 + "-" + wp24
    property string interText2 : "" // "Intersection of lines WPs " + wp31 + ", " + deg31.text + "° and " + wp32 + ", " + deg32.text + "°"
    property string interText3 : "" // "Intersection of line WP " + wp41 + ", " + deg41.text + "° and circle " + wp42 + ", radius " + radius42.text + " m"
    property string interText4 : "" // "Intersection of circles " + wp51 + ", radius " + radius51.text + " m and circle " + wp52 + ", " + radius52.text + " m"
    property string centreTxt  : "" // "Circle centre WPs " + wp71 + ", " + wp72 + ", " + wp73 + ", radius (m): " + ( circle === undefined ? "" : circle.radius )
    property string rdText     : "" // "Conversion of RD X: " + x.text + ", Y: " + y.text
    property string utmText    : "" // "Conversion of UTM " + zone.text + letter.text.toUpperCase() + " E " + easting.text + " N " + northing.text

    ListModel {
        id: listModel

        // Available within listModel:
        // cacheid, wayptid, waypoint, formula, calculated, note, is_waypoint, found

        function update()
        {
            listModel.clear();
            waypts = Database.getWaypts(generic.gcId, false);
            listLength = waypts.length;
            for (var i = 0; i < listLength; ++i) {
                listModel.append(waypts[i]);
                maxWaypt = waypts[i].waypoint > maxWaypt ? waypts[i].waypoint : maxWaypt
            }
            console.log( "listModel projects updated");
        }
    }

    Component.onCompleted: listModel.update()

    Timer {
        id: addTimer
        interval: 500
        running: false
        onTriggered: {
            indicator.running = false
            addEnabled = true
        }
    }

    Notification {
        id: notification

        summary: notify
        body: "GMFS"
        expireTimeout: 500
        urgency: Notification.Low
        isTransient: true
    }

    BusyIndicator {
        id: indicator
         size: BusyIndicatorSize.Large
         anchors.centerIn: parent
         running: false
    }

//    Component.onCompleted: listModel.update()

    SilicaFlickable {
        id: flick
        anchors {
            fill: parent
            leftMargin: Theme.paddingSmall
            rightMargin: Theme.paddingSmall
        }
        contentHeight: column.height + Theme.itemSizeHuge
        quickScroll : true

        PageHeader {
            id: pageHeader
            title: "Calculations"
        }

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            anchors.top: pageHeader.bottom

            ExpandingSection {
                title: qsTr("Waypoint projection")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box11
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp11 = waypoint
                                        deg1.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: deg1
                        width: parent.width
                        label: qsTr("Degrees")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: dist1.focus = true
                    }

                    TextField {
                        id: dist1
                        width: parent.width
                        label: qsTr("Distance (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            projCoord = Calc.projectWp(wp11, deg1.text, dist1.text, waypts, generic.xySystemIsRd)
                            dist1.focus = false
                        }
                    }

                    TextField {
                        id: newCoord
                        width: parent.width
                        text: projCoord
                        label: qsTr("New coordinate")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: newCoord.text !== "" && addEnabled
                            onClicked: {
                                notify = qsTr("Projection WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                projText = "Projection of WP " + wp11 + ": " + deg1.text + "° and " + dist1.text + " m"
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, projCoord, projCoord, projText, true, false, "")
                                listModel.update()
                                page.callback(true)
                           }
                        }
                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Projection WP copied")
                                notification.publish()
                                Clipboard.text = projCoord
                           }
                        }
                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp11 = "0"
                                deg1.text = ""
                                dist1.text = ""
                                projCoord = ""
                            }
                        }
                    }
                }

            }

            ExpandingSection {
                title: qsTr("Move to North and East")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box81
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp81 = waypoint
                                        dist2.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: dist2
                        width: parent.width
                        label: qsTr("Moving to the North (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: dist3.focus = true
                    }

                    TextField {
                        id: dist3
                        width: parent.width
                        label: qsTr("Moving to the East (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            moveCoord = Calc.moveWp(wp81, dist2.text, dist3.text, waypts, generic.xySystemIsRd)
                            moveText = "Moving WP " + wp81 + ": " + dist2.text + " m North, " + dist3.text + " m East"
                            dist3.focus = false
                        }
                    }

                    TextField {
                        id: newCoord8
                        width: parent.width
                        text: moveCoord
                        label: qsTr("New coordinate")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: newCoord8.text !== "" && addEnabled
                            onClicked: {
                                notify = qsTr("Projection WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                moveText = "Moving WP " + wp81 + ": " + dist2.text + " m North, " + dist3.text + " m East"
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, moveCoord, moveCoord, moveText, true, false, "")
                                listModel.update()
                                page.callback(true)
                           }
                        }
                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Moving WP copied")
                                notification.publish()
                                Clipboard.text = projCoord
                           }
                        }
                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp81 = "0"
                                dist2.text = ""
                                dist3.text = ""
                                moveCoord = ""
                            }
                        }
                    }
                }
            }

            ExpandingSection {
                title: qsTr("Line distance, angle (Vincenty)")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box61
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp61 = waypoint

                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box62
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp62 = waypoint
                                        distAngle = Calc.distAngle(wp61, wp62, waypts, generic.xySystemIsRd)
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: distext
                        width: parent.width
                        text: distAngle
                        label: qsTr("Line distance, angle")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp61 = "0"
                                wp62 = "0"
                                distAngle = ""
                            }
                        }
                    }
                }
            }

            ExpandingSection {
                title: qsTr("Intersect lines using 4 WP")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box21
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp21 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box22
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp22 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box23
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp23 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box24
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp24 = waypoint
                                        intersect1 = Calc.intersection1( wp21, wp22, wp23, wp24, waypts, generic.xySystemIsRd )
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: inters1
                        width: parent.width
                        text: intersect1
                        label: qsTr("Intersection coordinate")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: inters1.text !== "" && addEnabled
                            onClicked: {
                                notify = qsTr("Intersection WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                interText1 = "Intersection of lines WPs " + wp21 + "-" + wp22 + " and " + wp23 + "-" + wp24
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect1, intersect1, interText1, true, false, "")
                                listModel.update()
                                page.callback(true)
                           }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Intersection WP copied")
                                notification.publish()
                                Clipboard.text = intersect1
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp21 = "0"
                                wp22 = "0"
                                wp23 = "0"
                                wp24 = "0"
                                intersect1 = ""
                           }
                        }
                    }
                }
            }

            ExpandingSection {
                title: qsTr("Intersect lines 2 WPs, angles")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box31
                        label: qsTr("Waypoint") + " 1"
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp31 = waypoint
                                        deg31.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: deg31
                        width: parent.width
                        label: qsTr("Angle (°)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: deg32.focus = true
                    }

                    ComboBox {
                        id: box32
                        label: qsTr("Waypoint") + " 2"
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp32 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: deg32
                        width: parent.width
                        label: qsTr("Angle (°)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            intersect2 = Calc.intersection2( wp31, deg31.text, wp32, deg32.text, waypts, generic.xySystemIsRd )
                            deg32.focus = false
                        }
                    }

                    TextField {
                        id: inters2
                        width: parent.width
                        text: intersect2
                        label: qsTr("Intersection coordinate")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: inters2.text !== "" && addEnabled
                            onClicked: {
                                notify = qsTr("Intersection WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                interText2 = "Intersection of lines WPs " + wp31 + ", " + deg31.text + "° and " + wp32 + ", " + deg32.text + "°"
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect2, intersect2, interText2, true, false, "")
                                listModel.update()
                                page.callback(true)
                           }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Intersection WP copied")
                                notification.publish()
                                Clipboard.text = intersect2
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp31 = "0"
                                deg31.text = ""
                                wp32 = "0"
                                deg32.text = ""
                                intersect2 = ""
                                deg31.focus = true
                           }
                        }
                    }

                }
            }

            ExpandingSection {
                title: qsTr("Intersect line and circle")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box41
                        label: qsTr("Waypoint") + " " + qsTr("Line")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp41 = waypoint
                                        deg41.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: deg41
                        width: parent.width
                        label: qsTr("Angle (°)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: radius42.focus = true
                    }

                    ComboBox {
                        id: box42
                        label: qsTr("Waypoint") + " " + qsTr("Circle")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp42 = waypoint
                                        radius42.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: radius42
                        width: parent.width
                        label: qsTr("Radius (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            intersect3 = Calc.intersection3( wp41, deg41.text, wp42, radius42.text, waypts, generic.xySystemIsRd )
                            radius42.focus = false
                        }
                    }

                    TextArea {
                        id: inters3
                        width: parent.width
                        text: intersect3 === undefined ? "" : intersect3.str
                        label: qsTr("Intersection coordinates")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: intersect3 !== undefined && addEnabled
                            onClicked: {
                                notify = qsTr("Intersection WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                interText3 = "Intersection of line WP " + wp41 + ", " + deg41.text + "° and circle " + wp42 + ", radius " + radius42.text + " m"
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect3.coord1, intersect3.coord1, interText3, true, false, "")
                                Database.addWaypt(generic.gcId, "", maxWaypt + 2, intersect3.coord2, intersect3.coord2, interText3, true, false, "")
                                listModel.update()
                                page.callback(true)
                            }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Intersection WP copied")
                                notification.publish()
                                Clipboard.text = intersect3 === undefined ? "" : intersect3.str
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp41 = "0"
                                deg41.text = ""
                                wp42 = "0"
                                radius42.text = ""
                                intersect3 = undefined
                           }
                        }
                    }

                }
            }

            ExpandingSection {
                title: qsTr("Intersect two circles")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box51
                        label: qsTr("Waypoint") + " " + qsTr("Circle")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp51 = waypoint
                                        radius51.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: radius51
                        width: parent.width
                        label: qsTr("Radius (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: radius52.focus = true
                    }

                    ComboBox {
                        id: box52
                        label: qsTr("Waypoint") + " " + qsTr("Line")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp52 = waypoint
                                        radius52.focus = true
                                    }
                                }
                            }
                        }
                    }

                    TextField {
                        id: radius52
                        width: parent.width
                        label: qsTr("Radius (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            intersect4 = Calc.intersection4( wp51, radius51.text, wp52, radius52.text, waypts, generic.xySystemIsRd )
                            radius52.focus = false
                        }
                    }

                    TextArea {
                        id: inters4
                        width: parent.width
                        text: intersect4 === undefined ? "" : intersect4.str
                        label: qsTr("Intersection coordinates")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: intersect4 !== undefined && addEnabled
                            onClicked: {
                                if (intersect4.possible) {
                                    notify = qsTr("Intersection WP added")
                                    notification.publish()
                                    indicator.running = true
                                    addEnabled = false
                                    addTimer.start()
                                    interText4 = "Intersection of circles " + wp51 + ", radius " + radius51.text + " m and circle " + wp52 + ", " + radius52.text + " m"
                                    Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect4.coord1, intersect4.coord1, interText4, true, false, "")
                                    Database.addWaypt(generic.gcId, "", maxWaypt + 2, intersect4.coord2, intersect4.coord2, interText4, true, false, "")
                                    listModel.update()
                                    page.callback(true)
                                }
                            }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Intersection WP copied")
                                notification.publish()
                                Clipboard.text = intersect4 === undefined ? "" : intersect4.str
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp51 = "0"
                                radius51.text = ""
                                wp52 = "0"
                                radius52.text = ""
                                intersect4 = undefined
                           }
                        }
                    }

                }
            }

            ExpandingSection {
                title: qsTr("Circle through 3 WPs")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box71
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp71 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box72
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp72 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box73
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp73 = waypoint
                                        circle = Calc.circle( wp71, wp72, wp73, waypts, generic.xySystemIsRd )
                                    }
                                }
                            }
                        }
                    }

                    TextArea {
                        id: circleCentre
                        width: parent.width
                        text:  circle === undefined ? "" : ( circle.centre + ", " + circle.radius + " m" )
                        label: qsTr("Circle centre and radius (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: circle !== undefined && addEnabled
                            onClicked: {
                                if (circle.possible) {
                                    notify = qsTr("Circle centre WP added")
                                    notification.publish()
                                    indicator.running = true
                                    addEnabled = false
                                    addTimer.start()
                                    centreTxt = "Circle centre WPs " + wp71 + ", " + wp72 + ", " + wp73 + ", radius (m): " + ( circle === undefined ? "" : circle.radius )
                                    Database.addWaypt(generic.gcId, "", maxWaypt + 1, circle.centre, circle.centre, centreTxt, true, false, "")
                                    listModel.update()
                                    page.callback(true)
                                }
                           }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("Circle centre coords copied")
                                notification.publish()
                                Clipboard.text = circle === undefined ? "" : circle.centre
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp71 = "0"
                                wp72 = "0"
                                wp73 = "0"
                                circle = undefined
                           }
                        }
                    }

                }
            }

            ExpandingSection {
                title: qsTr("RD XY to WGS coordinate")

                content.sourceComponent: Column {

                    TextField {
                        id: x
                        width: parent.width
                        label: "X (Dutch RD)"
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: y.focus = true
                    }

                    TextField {
                        id: y
                        width: parent.width
                        label: "Y (Dutch RD)"
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            wgsCoord1 = Calc.rd2wgs(x.text, y.text).str
                            focus = false
                        }
                    }

                    TextField {
                        id: wgs
                        width: parent.width
                        text: wgsCoord1
                        label: qsTr("WGS Coordinate")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: wgs.text !== "" && addEnabled
                            onClicked: {
                                notify = qsTr("WGS coordinate WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                rdText = "Conversion of RD X: " + x.text + ", Y: " + y.text
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, wgsCoord1, wgsCoord1, rdText, true, false, "")
                                listModel.update()
                                page.callback(true)
                           }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("WGS coordinates copied")
                                notification.publish()
                                Clipboard.text = wgsCoord1
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                x.text = ""
                                y.text = ""
                                wgsCoord1 = ""
                                x.focus = true
                            }
                        }
                    }

                }
            }

            ExpandingSection {
                title: qsTr("UTM to WGS coordinate")

                content.sourceComponent: Column {

                    TextField {
                        id: zone
                        width: parent.width
                        label: "Zone"
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: letter.focus = true
                    }

                    TextField {
                        id: letter
                        width: parent.width
                        label: "Letter"
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        EnterKey.enabled: text.length === 1
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: easting.focus = true
                    }

                    TextField {
                        id: easting
                        width: parent.width
                        label: "Easting"
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-next"
                        EnterKey.onClicked: northing.focus = true
                    }

                    TextField {
                        id: northing
                        width: parent.width
                        label: "Northing"
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.primaryColor
                        inputMethodHints: Qt.ImhDigitsOnly
                        EnterKey.enabled: text.length > 0
                        EnterKey.iconSource: "image://theme/icon-m-enter-close"
                        EnterKey.onClicked: {
                            wgsCoord2 = Calc.utm2wgs(zone.text + letter.text + " E " + easting.text + " N " + northing.text).str
                            focus = false
                        }
                    }

                    TextField {
                        id: wgs2
                        width: parent.width
                        text: wgsCoord2
                        label: qsTr("WGS Coordinate")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.source: "image://theme/icon-l-new"
                            icon.color: generic.primaryColor
                            enabled: wgs2.text !== "" && addEnabled
                            onClicked: {
                                notify = qsTr("WGS coordinate WP added")
                                notification.publish()
                                indicator.running = true
                                addEnabled = false
                                addTimer.start()
                                utmText = "Conversion of UTM " + zone.text + letter.text.toUpperCase() + " E " + easting.text + " N " + northing.text
                                Database.addWaypt(generic.gcId, "", maxWaypt + 1, wgsCoord2, wgsCoord2, utmText, true, false, "")
                                listModel.update()
                                page.callback(true)
                           }
                        }

                        IconButton {
                            icon.source: "image://theme/icon-l-clipboard"
                            icon.color: generic.primaryColor
                            onClicked: {
                                notify = qsTr("WGS coordinates copied")
                                notification.publish()
                                Clipboard.text = wgsCoord2
                           }
                        }

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                zone.text = ""
                                letter.text = ""
                                northing.text = ""
                                easting.text = ""
                                wgsCoord2 = ""
                                zone.focus = true
                            }
                        }
                    }
                }
            }

            ExpandingSection {
                title: qsTr("Pentagon circumference")

                content.sourceComponent: Column {

                    ComboBox {
                        id: box1
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp1 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box2
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp2 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box3
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp3 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box4
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp4 = waypoint
                                    }
                                }
                            }
                        }
                    }

                    ComboBox {
                        id: box5
                        label: qsTr("Waypoint")
                        menu: ContextMenu {
                            Repeater {
                                model: listModel
                                MenuItem {
                                    text: waypoint + ", " + calculated
                                    onClicked: {
                                        console.log("ComboBox onClicked: " + waypoint)
                                        wp5 = waypoint
                                        distance = Calc.distance( wp1, wp2, wp3, wp4, wp5, waypts, generic.xySystemIsRd )
                                    }
                                }
                            }
                        }
                    }

                    TextArea {
                        id: dist
                        width: parent.width
                        text: distance
                        label: qsTr("Circumference (meter)")
                        placeholderText: label
                        placeholderColor: generic.secondaryColor
                        color: generic.highlightColor
                        readOnly: true
                    }

                    Row {
                        spacing: Theme.itemSizeSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        bottomPadding: Theme.paddingMedium

                        IconButton {
                            icon.color: generic.primaryColor
                            icon.source: "image://theme/icon-l-dismiss"
                            onClicked: {
                                wp1 = "0"
                                wp2 = "0"
                                wp3 = "0"
                                wp4 = "0"
                                wp5 = "0"
                            }
                        }
                    }
                }
            }

        }
    }
}
