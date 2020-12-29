import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/Calculations.js" as Calc
import "../scripts/TextFunctions.js" as TF

Page {
    id: page

    allowedOrientations: Orientation.All

    property var callback

    property var waypts
    property var maxWaypt   : 0
    property var projCoord  : ""
    property var distAngle  : ""
    property var intersect1 : ""
    property var intersect2 : ""
    property var intersect3
    property var intersect4
    property var circle
    property var wgsCoord1  : ""
    property var wgsCoord2  : ""
    property var distance   : 0

    property bool addEnabled: true
    property var projText   : "Projection of WP " + wp11.text + ": " + deg1.text + "° and " + dist1.text + " m"
    property var interText1 : "Intersection of lines WPs " + wp21.text + "-" + wp22.text + " and " + wp23.text + "-" + wp24.text
    property var interText2 : "Intersection of lines WPs " + wp31.text + ", " + deg31.text + "° and " + wp32.text + ", " + deg32.text + "°"
    property var interText3 : "Intersection of line WP " + wp41.text + ", " + deg41.text + "° and circle " + wp42.text + ", radius " + radius42.text + " m"
    property var interText4 : "Intersection of circles " + wp51.text + ", radius " + radius51.text + " m and circle " + wp52.text + ", " + radius52.text + " m"
    property var centreTxt  : "Circle centre WPs " + wp71.text + ", " + wp72.text + ", " + wp73.text + ", radius (m): " + ( circle === undefined ? "" : circle.radius )
    property var rdText     : "Conversion of RD X: " + x.text + ", Y: " + y.text
    property var utmText    : "Conversion of UTM " + zone.text + letter.text.toUpperCase() + " E " + easting.text + " N " + northing.text

    function populate() {
        waypts = Database.getWaypts(generic.gcId, false);
        for (var i = 0; i < waypts.length; i++) {
            maxWaypt = waypts[i].waypoint > maxWaypt ? waypts[i].waypoint : maxWaypt
//            waypts[i].calculated = TF.evalFormula(waypts[i].formula, generic.allLetters)
        }
    }

    Timer {
        id: addTimer
        interval: 500
        running: false
        onTriggered: {
            indicator.running = false
            addEnabled = true
        }
    }

    BusyIndicator {
        id: indicator
         size: BusyIndicatorSize.Large
         anchors.centerIn: parent
         running: false
    }

    Component.onCompleted: populate()

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

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Waypoint projection")
                color: generic.primaryColor
                onClicked: {
                    wp11.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Line distance, angle")
                color: generic.primaryColor
                onClicked: {
                    wp61.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Intersect lines using 4 WP")
                color: generic.primaryColor
                onClicked: {
                    wp21.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Intersect lines 2 WPs, angles")
                color: generic.primaryColor
                onClicked: {
                    wp31.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Intersect line and circle")
                color: generic.primaryColor
                onClicked: {
                    wp41.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Intersect two circles")
                color: generic.primaryColor
                onClicked: {
                    wp51.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Circle through 3 WPs")
                color: generic.primaryColor
                onClicked: {
                    wp71.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("RD XY to WGS coordinate")
                color: generic.primaryColor
                visible: generic.xySystemIsRd
                onClicked: {
                    x.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("UTM to WGS coordinate")
                color: generic.primaryColor
                onClicked: {
                    zone.focus = true
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Pentagon circumference")
                color: generic.primaryColor
                onClicked: {
                    wp1.focus = true
               }
            }

            SectionHeader {
                text: qsTr("Waypoint projection (Vincenty)")
                color: generic.highlightColor
            }

            TextField {
                id: wp11
                width: parent.width
                label: Calc.showFormula( wp11.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: deg1.focus = true
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
                    projCoord = Calc.projectWp(wp11.text, deg1.text, dist1.text, waypts, generic.xySystemIsRd)
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
                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: newCoord.text !== "" && addEnabled
                    onClicked: {
                        indicator.running = true
                        addEnabled = false
                        addTimer.start()
                        Database.addWaypt(generic.gcId, "", maxWaypt + 1, projCoord, projCoord, projText, true, false, "")
                        populate()
                        page.callback(true)
                   }
                }
                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
                        Clipboard.text = projCoord
                   }
                }
                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp11.text = ""
                        deg1.text = ""
                        dist1.text = ""
                        projCoord = ""
                        wp11.focus = true
                    }
                }
            }

            SectionHeader {
                text: qsTr("Line distance, angle (Vincenty)")
                color: generic.highlightColor
            }

            TextField {
                id: wp61
                width: parent.width
                label: Calc.showFormula( wp61.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp62.focus = true
            }

            TextField {
                id: wp62
                width: parent.width
                label: Calc.showFormula( wp62.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked:
                {
                    distAngle = Calc.distAngle(wp61.text, wp62.text, waypts, generic.xySystemIsRd)
                    wp62.focus = false
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

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp61.text = ""
                        wp62.text = ""
                        distAngle = ""
                        wp61.focus = true
                    }
                }
            }

            SectionHeader {
                text: qsTr("Intersect lines using 4 WPs")
                color: generic.highlightColor
            }

            TextField {
                id: wp21
                width: parent.width
                label: "Line 1, from " + Calc.showFormula( wp21.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp22.focus = true
            }

            TextField {
                id: wp22
                width: parent.width
                label: "Line 1, to " + Calc.showFormula( wp22.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp23.focus = true
            }

            TextField {
                id: wp23
                width: parent.width
                label: "Line 2, from " + Calc.showFormula( wp23.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp24.focus = true
            }

            TextField {
                id: wp24
                width: parent.width
                label: "Line 2, to " + Calc.showFormula( wp24.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    intersect1 = Calc.intersection1( wp21.text, wp22.text, wp23.text, wp24.text, waypts, generic.xySystemIsRd )
                    wp24.focus = false
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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: inters1.text !== "" && addEnabled
                    onClicked: {
                        indicator.running = true
                        addEnabled = false
                        addTimer.start()
                        Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect1, intersect1, interText1, true, false, "")
                        populate()
                        page.callback(true)
                   }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
                        Clipboard.text = intersect1
                   }
                }

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp21.text = ""
                        wp22.text = ""
                        wp23.text = ""
                        wp24.text = ""
                        intersect1 = ""
                        wp21.focus = true
                   }
                }
            }

            SectionHeader {
                text: qsTr("Intersect lines 2 WPs, angles")
                color: generic.highlightColor
            }

            TextField {
                id: wp31
                width: parent.width
                label: qsTr("WP1: ") + Calc.showFormula( wp31.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: deg31.focus = true
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
                EnterKey.onClicked: wp32.focus = true
            }

            TextField {
                id: wp32
                width: parent.width
                label: qsTr("WP2: ") + Calc.showFormula( wp32.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: deg32.focus = true
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
                    intersect2 = Calc.intersection2( wp31.text, deg31.text, wp32.text, deg32.text, waypts, generic.xySystemIsRd )
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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: inters2.text !== "" && addEnabled
                    onClicked: {
                        indicator.running = true
                        addEnabled = false
                        addTimer.start()
                        Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect2, intersect2, interText2, true, false, "")
                        populate()
                        page.callback(true)
                   }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
                        Clipboard.text = intersect2
                   }
                }

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp31.text = ""
                        deg31.text = ""
                        wp32.text = ""
                        deg32.text = ""
                        intersect2 = ""
                        wp31.focus = true
                   }
                }
            }

            SectionHeader {
                text: qsTr("Intersect circle and line")
                color: generic.highlightColor
            }

            TextField {
                id: wp41
                width: parent.width
                label: qsTr("Line WP1: ") + Calc.showFormula( wp41.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: deg41.focus = true
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
                EnterKey.onClicked: wp42.focus = true
            }

            TextField {
                id: wp42
                width: parent.width
                label: qsTr("Circle WP2: ") + Calc.showFormula( wp42.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: radius42.focus = true
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
                    intersect3 = Calc.intersection3( wp41.text, deg41.text, wp42.text, radius42.text, waypts, generic.xySystemIsRd )
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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: intersect3 !== undefined && addEnabled
                    onClicked: {
                        indicator.running = true
                        addEnabled = false
                        addTimer.start()
                        Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect3.coord1, intersect3.coord1, interText3, true, false, "")
                        Database.addWaypt(generic.gcId, "", maxWaypt + 2, intersect3.coord2, intersect3.coord2, interText3, true, false, "")
                        populate()
                        page.callback(true)
                    }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
                        Clipboard.text = intersect3 === undefined ? "" : intersect3.str
                   }
                }

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp41.text = ""
                        deg41.text = ""
                        wp42.text = ""
                        radius42.text = ""
                        intersect3 = undefined
                        wp41.focus = true
                   }
                }
            }

            SectionHeader {
                text: qsTr("Intersect circles")
                color: generic.highlightColor
            }

            TextField {
                id: wp51
                width: parent.width
                label: qsTr("Circle WP1: ") + Calc.showFormula( wp41.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: radius51.focus = true
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
                EnterKey.onClicked: wp52.focus = true
            }

            TextField {
                id: wp52
                width: parent.width
                label: qsTr("Circle WP2: ") + Calc.showFormula( wp42.text, waypts)
                placeholderText: label
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: radius52.focus = true
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
                    intersect4 = Calc.intersection4( wp51.text, radius51.text, wp52.text, radius52.text, waypts, generic.xySystemIsRd )
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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: intersect4 !== undefined && addEnabled
                    onClicked: {
                        if (intersect4.possible) {
                            indicator.running = true
                            addEnabled = false
                            addTimer.start()
                            Database.addWaypt(generic.gcId, "", maxWaypt + 1, intersect4.coord1, intersect4.coord1, interText4, true, false, "")
                            Database.addWaypt(generic.gcId, "", maxWaypt + 2, intersect4.coord2, intersect4.coord2, interText4, true, false, "")
                            populate()
                            page.callback(true)
                        }
                    }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
                        Clipboard.text = intersect4 === undefined ? "" : intersect4.str
                   }
                }

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp51.text = ""
                        radius51.text = ""
                        wp52.text = ""
                        radius52.text = ""
                        intersect4 = undefined
                        wp51.focus = true
                   }
                }
            }

            SectionHeader {
                text: qsTr("Circle through 3 WPs")
                color: generic.highlightColor
            }

            TextField {
                id: wp71
                width: parent.width
                label: Calc.showFormula( wp71.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp72.focus = true
            }

            TextField {
                id: wp72
                width: parent.width
                label: Calc.showFormula( wp72.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp73.focus = true
            }

            TextField {
                id: wp73
                width: parent.width
                label: Calc.showFormula( wp73.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: {
                    circle = Calc.circle( wp71.text, wp72.text, wp73.text, waypts, generic.xySystemIsRd )
                    wp73.focus = false
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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: circle !== undefined && addEnabled
                    onClicked: {
                        if (circle.possible) {
                            indicator.running = true
                            addEnabled = false
                            addTimer.start()
                            Database.addWaypt(generic.gcId, "", maxWaypt + 1, circle.centre, circle.centre, centreTxt, true, false, "")
                            populate()
                            page.callback(true)
                        }
                   }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
                        Clipboard.text = circle === undefined ? "" : circle.centre
                   }
                }

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp71.text = ""
                        wp72.text = ""
                        wp73.text = ""
                        circle = undefined
                        wp71.focus = true
                   }
                }
            }

            SectionHeader {
                text: qsTr("RD XY to WGS coordinate")
                color: generic.highlightColor
            }

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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: wgs.text !== "" && addEnabled
                    onClicked: {
                        indicator.running = true
                        addEnabled = false
                        addTimer.start()
                        Database.addWaypt(generic.gcId, "", maxWaypt + 1, wgsCoord1, wgsCoord1, rdText, true, false, "")
                        populate()
                        page.callback(true)
                   }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
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

            SectionHeader {
                text: qsTr("UTM to WGS coordinate")
                color: generic.highlightColor
            }

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

                IconButton {
                    icon.source: "image://theme/icon-l-new"
                    icon.color: generic.primaryColor
                    enabled: wgs2.text !== "" && addEnabled
                    onClicked: {
                        indicator.running = true
                        addEnabled = false
                        addTimer.start()
                        Database.addWaypt(generic.gcId, "", maxWaypt + 1, wgsCoord2, wgsCoord2, utmText, true, false, "")
                        populate()
                        page.callback(true)
                   }
                }

                IconButton {
                    icon.source: "image://theme/icon-l-clipboard"
                    icon.color: generic.primaryColor
                    onClicked: {
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

            SectionHeader {
                text: qsTr("Pentagon distance")
                color: generic.highlightColor
            }

            TextField {
                id: wp1
                width: parent.width
                label: Calc.showFormula( wp1.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp2.focus = true
            }

            TextField {
                id: wp2
                width: parent.width
                label: Calc.showFormula( wp2.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp3.focus = true
            }

            TextField {
                id: wp3
                width: parent.width
                label: Calc.showFormula( wp3.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: wp4.focus = true
            }

            TextField {
                id: wp4
                width: parent.width
                label: Calc.showFormula( wp4.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    wp5.focus = true
                }
            }

            TextField {
                id: wp5
                width: parent.width
                label: Calc.showFormula( wp5.text, waypts)
                placeholderText: "Enter WP number"
                placeholderColor: generic.secondaryColor
                color: generic.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: {
                    distance = Calc.distance( wp1.text, wp2.text, wp3.text, wp4.text, wp5.text, waypts, generic.xySystemIsRd )
                    wp5.focus = false
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

                IconButton {
                    icon.color: generic.primaryColor
                    icon.source: "image://theme/icon-l-dismiss"
                    onClicked: {
                        wp1.text = ""
                        wp2.text = ""
                        wp3.text = ""
                        wp4.text = ""
                        wp5.text = ""
                        wp1.focus = true
                    }
                }
            }
        }
    }
}
