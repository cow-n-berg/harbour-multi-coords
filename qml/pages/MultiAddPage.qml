import QtQuick 2.2
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: dialog

    property var callback

    property var coords
    property var showSearchLength : false
    property var strCalmontWalk   : '<?xml version="1.0" encoding="utf-8"?> <gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Groundspeak, Inc. All Rights Reserved. http://www.groundspeak.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd" xmlns="http://www.topografix.com/GPX/1/0">   <name>Cache Listing Generated from Geocaching.com</name>   <desc>This is an individual cache generated from Geocaching.com</desc>   <author>Account "Blinky Bill" From Geocaching.com</author>   <email>contact@geocaching.com</email>   <url>https://www.geocaching.com</url>   <urlname>Geocaching - High Tech Treasure Hunting</urlname>   <time>2020-08-30T14:33:54.7045749Z</time>   <keywords>cache, geocache</keywords>   <bounds minlat="50.101933" minlon="7.123883" maxlat="50.10715" maxlon="7.14015" />   <wpt lat="50.103433" lon="7.137333">     <time>2002-06-08T00:00:00</time>     <name>GC61DC</name>     <desc>Calmont Walk (Replacement) 𓇭 by Blinky Bill, Multi-cache (2/3.5)</desc>     <url>https://www.geocaching.com/seek/cache_details.aspx?guid=1587b22c-ba01-4f8a-acee-b5569838f911</url>     <urlname>Calmont Walk (Replacement) 𓇭</urlname>     <sym>Geocache</sym>     <type>Geocache|Multi-cache</type>     <groundspeak:cache id="25052" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">       <groundspeak:name>Calmont Walk (Replacement) 𓇭</groundspeak:name>       <groundspeak:placed_by>Blinky Bill</groundspeak:placed_by>       <groundspeak:owner id="23131">Blinky Bill</groundspeak:owner>       <groundspeak:type>Multi-cache</groundspeak:type>       <groundspeak:container>Regular</groundspeak:container>       <groundspeak:attributes>         <groundspeak:attribute id="32" inc="0">Bicycles</groundspeak:attribute>         <groundspeak:attribute id="24" inc="0">Wheelchair accessible</groundspeak:attribute>         <groundspeak:attribute id="1" inc="0">Dogs</groundspeak:attribute>         <groundspeak:attribute id="56" inc="1">Medium hike (1 km–10 km)</groundspeak:attribute>         <groundspeak:attribute id="13" inc="1">Available 24/7</groundspeak:attribute>         <groundspeak:attribute id="8" inc="1">Scenic view</groundspeak:attribute>         <groundspeak:attribute id="25" inc="1">Parking nearby</groundspeak:attribute>         <groundspeak:attribute id="21" inc="1">Cliff/falling rocks</groundspeak:attribute>       </groundspeak:attributes>       <groundspeak:difficulty>2</groundspeak:difficulty>       <groundspeak:terrain>3.5</groundspeak:terrain>       <groundspeak:country>Germany</groundspeak:country>       <groundspeak:state>Rheinland-Pfalz</groundspeak:state>       <groundspeak:short_description html="True">&lt;b&gt;Teilweise anstrengende und herausfordernde Wanderung durch den Calmont. Gute Trekking-Schuhe sind ein Muß.&lt;br /&gt; Dauer etwa 1/2 Tag oder mehr, je nach Fitness.&lt;br /&gt; "Ausrüstung:" keine Höhenangst, trainierte Wanderer, Trittsicherheit&lt;br /&gt; &lt;br /&gt;&lt;/b&gt; &lt;hr /&gt; &lt;h3&gt;&lt;b&gt;BTW, it is a question of politeness to log in a language the owner does understand, for example English, if you log caches in another country!!&lt;/b&gt;&lt;/h3&gt; &lt;br /&gt; &lt;hr /&gt; </groundspeak:short_description>       <groundspeak:long_description html="True">&lt;b&gt;1. Start und Ziel ist N50 06.206 E07 08.240. Der Pfad beginnt an der Bahnbrücke.&lt;br /&gt; Gehe zu N50 06.269 E07 08.360 und notiere die Länge des Petersbergtunnels = ABC&lt;br /&gt; &lt;br /&gt; 2. Weiter nach N50 06.317 E07 08.092 und die Anzahl der arbeitenden Menschen auf der Tafel feststellen = D&lt;br /&gt; &lt;br /&gt; 3. Nun zu N50 06.429 E07 07.433 und das Jahr der Auktion notieren = EFGH&lt;br /&gt; &lt;br /&gt; 4. Gehe zu N50 06.(A+C) (C) (D+C)   E07 06.(F) (D+G) (E+F)&lt;br /&gt; Notiere die Summe folgender Buchstaben (Inschrift im Sockel des Kreuzes): a &amp;amp; e. Setze die Anzahl für a = I und die Anzahl für e = J&lt;br /&gt; &lt;br /&gt; 5. Weiter gehts bei N50 06.(J+E) (G+A) (E+G)   E07 07.(J) (J-I) (F-D)&lt;br /&gt; Dort findet Ihr eine Tafel über ein Heiligtum. Welcher Nummer hat "Pommern" = K&lt;br /&gt; Sollten die Koordinaten zu ungenau sind, gebt bitte Bescheid - die Änderung dieser Station erfolgte aus der Ferne&lt;br /&gt; &lt;br /&gt; 6. Bei N50 06.(K-C) (K²/K) (G+I)   E07 08.(H) (G+E) (H)&lt;br /&gt; steht ein Gebäude. Wann wurde es errichtet? = LMNO&lt;br /&gt; &lt;br /&gt; 7. Bei N50 06.350 E07 08.140 notiere die eingravierten Ziffern auf dem Sockel = PQRSTU&lt;br /&gt; &lt;br /&gt; 8. Cache ist bei: N50 0(N-L),(U-Q) [(2*T)/(U+L)] (K-L)   E07 0(S+T-Q).[(3*S)/(Q+L)] (O-P+S) (U)&lt;br /&gt; &lt;br /&gt; Bitte wieder gut verstecken- Danke&lt;br /&gt; &lt;br /&gt;&lt;/b&gt; &lt;hr /&gt; &lt;br /&gt; &lt;br /&gt; English version:&lt;br /&gt; &lt;p&gt;Partly strenous and demanding hike thru the Calmont. A sturdy pair of trekking shoes are a must.&lt;br /&gt; calculate half a day or more depending on your level of fitness&lt;br /&gt; Personal requirements: freedom of vertigo essential, trained hikers, sure-footedness&lt;br /&gt; Cache: tupper box&lt;br /&gt; &lt;br /&gt; 1. Start &amp;amp; end at N50 06.206 E07 08.240. Enter the track at the railway bridge.&lt;br /&gt; Go to N50 06.269 E07 08.360 and note the length (Länge) of the "Petersbergtunnel". Assign the&lt;br /&gt; numbers to the letters ABC (e.g. 698m: A=6 B=9 C=8).&lt;br /&gt; &lt;br /&gt; 2. Goto N50 06.317 E07 08.092 and count the working people on the plate = D&lt;br /&gt; &lt;br /&gt; 3. Continue to N50 06.429 E07 07.433 and note the year of the auction (Versteigerung) and assign it to EFGH.&lt;br /&gt; &lt;br /&gt; 4. Goto N50 06.(A+C) (C) (D+C)   E07 06.(F) (D+G) (E+F)&lt;br /&gt; Check the inscription at the base of the cross, note the sum of the following letters: a &amp;amp; e and&lt;br /&gt; assign a to I and e to J.&lt;br /&gt; &lt;br /&gt; 5. Move on to N50 06.(J+E) (G+A) (E+G) E07 07.(J) (J-I) (F-D)&lt;br /&gt; There youll find information about a sanctuary (Heiligtum). Which number is assigned to "Pommern" = K&lt;br /&gt; If coordinates are too inaccurate please give feedback. Changes have been made from afar.&lt;br /&gt; &lt;br /&gt; 6. Continue to N50 06.(K-C) (K²/K) (G+I)   E07 08.(H) (G+E) (H)&lt;br /&gt; In which year the building was constructed? Assign the numbers to LMNO.&lt;br /&gt; &lt;br /&gt; 7. Goto N50 06.350 E07 08.140, note the cyphers engraved on the basis and assign the numbers to PQRSTU.&lt;br /&gt; &lt;br /&gt; 8. Cache is at:&lt;br /&gt; N50 0(N-L),(U-Q) [(2*T)/(U+L)] (K-L)   E07 0(S+T-Q).[(3*S)/(Q+L)] (O-P+S) (U)&lt;br /&gt; &lt;br /&gt; Please hide cache as you found it - thank you!!&lt;br /&gt; Good luck&lt;/p&gt; &lt;br /&gt; &lt;hr /&gt; &lt;br /&gt; Information: &lt;a rel="nofollow" href="http://www.calmont-mosel.de/"&gt;&lt;font size="4"&gt;Calmont&lt;/font&gt;&lt;/a&gt;&lt;br /&gt; &lt;br /&gt; &lt;br /&gt; &lt;table border="0" cellpadding="5" cellspacing="25"&gt; &lt;tr&gt; &lt;td&gt;&lt;img src="http://www.koala-support.de/geocaching/bc-no-thanks.jpg" /&gt;&lt;/td&gt; &lt;td&gt;&lt;img src="http://www.koala-support.de/geocaching/trade.jpg" /&gt;&lt;/td&gt; &lt;/tr&gt; &lt;/table&gt; &lt;br /&gt; &lt;br /&gt; Updates:&lt;br /&gt; 29-05-2013: Station 5 geändert. Stage 5 changed.&lt;br /&gt; 26-06-2018: Das sich am Final mittlerweile eine Art "WC" befindet ist bedauerlich. Als der Cache hier versteckt wurde, gab es keinen Pfad o. ä. Erst nachdem der Cacherpfad entstanden ist, kamen Wanderer wohl auf die Idee, sich hier "niederzulassen". Wir können das Versteck aber nicht ständig deswegen ändern. Sollte es zu schlimm werden, lassen wir uns etwas einfallen. &lt;p&gt;Additional Hidden Waypoints&lt;/p&gt;0161DC - CAL-1&lt;br /&gt;N 50° 06.269 E 007° 08.360&lt;br /&gt;&lt;br /&gt;0261DC - CAL-2&lt;br /&gt;N 50° 06.317 E 007° 08.092&lt;br /&gt;&lt;br /&gt;0361DC - CAL-3&lt;br /&gt;N 50° 06.429 E 007° 07.433&lt;br /&gt;&lt;br /&gt;0461DC - CAL-4&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0561DC - CAL-5&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0661DC - CAL-6&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0761DC - CAL-7&lt;br /&gt;N 50° 06.350 E 007° 08.140&lt;br /&gt;&lt;br /&gt;PK61DC - GC61DC Parking / Parkplatz neu 2016&lt;br /&gt;N 50° 06.116 E 007° 08.409&lt;br /&gt;&lt;br /&gt;</groundspeak:long_description>       <groundspeak:encoded_hints>unter Steinen / under stones</groundspeak:encoded_hints>       <groundspeak:travelbugs>         <groundspeak:travelbug id="6483756" ref="TB7EDNB">           <groundspeak:name>Schluesselsche</groundspeak:name>         </groundspeak:travelbug>         <groundspeak:travelbug id="6897139" ref="TB7X9V9">           <groundspeak:name>Travel Eagle</groundspeak:name>         </groundspeak:travelbug>         <groundspeak:travelbug id="8108577" ref="TB96ZDY">           <groundspeak:name>Frost in MV 10 gehmalwech</groundspeak:name>         </groundspeak:travelbug>       </groundspeak:travelbugs>     </groundspeak:cache>   </wpt>   <wpt lat="50.104483" lon="7.139333">     <time>2007-09-18T05:50:57.337</time>     <name>0161DC</name>     <cmt />     <desc>CAL-1</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=56af0c18-193c-40b1-80c5-19bb20c42ab2</url>     <urlname>CAL-1</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.105283" lon="7.134867">     <time>2007-09-18T05:51:30.463</time>     <name>0261DC</name>     <cmt />     <desc>CAL-2</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=cb30fd21-1713-4c9f-8bdb-a95e950d7deb</url>     <urlname>CAL-2</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.10715" lon="7.123883">     <time>2007-09-18T05:52:05.773</time>     <name>0361DC</name>     <cmt />     <desc>CAL-3</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=9666a87e-9220-41f8-8dbc-5c6a5cacf566</url>     <urlname>CAL-3</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.105833" lon="7.135667">     <time>2007-09-18T05:54:47.76</time>     <name>0761DC</name>     <cmt />     <desc>CAL-7</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=07671b19-5790-4a2d-b6eb-7f84e89291ba</url>     <urlname>CAL-7</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.101933" lon="7.14015">     <time>2016-05-28T09:26:29.42</time>     <name>PK61DC</name>     <cmt />     <desc>GC61DC Parking / Parkplatz neu 2016</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=f4c9f622-7f17-4e18-b6a4-f5be12b1de90</url>     <urlname>GC61DC Parking / Parkplatz neu 2016</urlname>     <sym>Parking Area</sym>     <type>Waypoint|Parking Area</type>   </wpt> </gpx>'

    allowedOrientations: Orientation.All

    canAccept: txtCode.text !== "" && txtName.text !== ""

    onAccepted: {
        var resCoords = [];
        var numberItems = listModel.count;
        for (var i = 0; i < numberItems; ++i) {
            var wpnr  = i + Number(offset.value);
            var coord = listModel.get(i).coord;
            var note  = listModel.get(i).note;
            var raw   = listModel.get(i).raw;
            resCoords.push({coord: coord, number: wpnr, note: note, raw: raw});
        }
        Database.addCache(txtCode.text, txtName.text, resCoords)
        dialog.callback(true)
    }

    onRejected: {
        dialog.callback(false)
    }

    ListModel {
        id: listModel

        function update()
        {
            listModel.clear();
            if (coords !== undefined) {
                console.log( JSON.stringify(coords) );
                for (var i = 0; i < coords.length; ++i) {
                    listModel.append(coords[i]);
                }
            }
            console.log( "listModel updated");
        }
    }

    Component.onCompleted: listModel.update();

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 1.0
        visible: generic.nightCacheMode
    }

    SilicaFlickable {
        id: addMulti

        PageHeader {
            id: pageHeader
            title: qsTr("Add Multi cache")
        }

        VerticalScrollDecorator { flickable: addMulti }

        anchors.fill: parent
        anchors.margins: Theme.paddingSmall
        contentHeight: column.height + Theme.itemSizeLarge
        quickScroll : true

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

//            spacing: Theme.paddingMedium

            SectionHeader {
                text: qsTr("Raw text")
                color: generic.highlightColor
            }

            TextArea {
                id: description1
                width: parent.width
                height: Screen.height / 6
                text: qsTr("Paste the entire Geocache description - or the content of a GPX file! - in the next text area. Use the button to extract possible coordinates and formulas. Use press-and-hold to remove options. Formulas may be too long, you can edit them later. Use TinyEdit for GPX downloads, or WlanKeyboard.")
                label: qsTr("How to add")
                labelVisible: false
                color: generic.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: generic.showDialogHints
            }
            TextArea {
                id: rawText
                width: parent.width
                height: Screen.height / 4
                label: "Raw text"
                text:  generic.showDialogHints ? strCalmontWalk : ""
                placeholderText: qsTr("Paste description, gpx or raw text here")
                color: generic.primaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
             }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Process raw text")
                color: generic.primaryColor
                onClicked: {
                    var results = TF.coordsByRegEx(rawText.text, slider.value)
                    txtCode.text = results.code
                    txtName.text = results.name
                    coords = results.coords
                    generic.rawText = rawText.text
                    listModel.update()
               }
            }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: showSearchLength ? qsTr("Hide formula search length") : qsTr("Change formula search length")
                color: generic.primaryColor
                onClicked: {
                    showSearchLength = !showSearchLength
               }
            }

            Slider {
                id: slider
                value: 40
                minimumValue: 11
                maximumValue: 60
                stepSize: 1
                width: parent.width
                valueText: value
                label: qsTr("Formula search: characters after NSEW")
                visible: showSearchLength
            }
            Label {
                text: "RegEx: /([NS][^#]{5," + slider.value + "}\s[EW][^#&,']{5," + slider.value + "})/g"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: showSearchLength
            }

//            SectionHeader {
//                text: qsTr("Process raw text")
//            }

            SectionHeader {
                text: qsTr("Results: Geocache items")
                color: generic.highlightColor
            }

            TextField {
                id: txtCode
                label: qsTr("Geocache code")
                placeholderText: "GCXXXXX"
                width: parent.width
                color: generic.primaryColor
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextField {
                id: txtName
                label: qsTr("Geocache name")
                placeholderText: label
                width: parent.width
                color: generic.primaryColor
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            SectionHeader {
                text: qsTr("Waypoint numbering")
                color: generic.highlightColor
            }

            TextArea {
                id: description2
                width: parent.width
                text: qsTr("From GPX files, a Parking WP will be put before Main coordinate, resp. WP 0 and 1. You may want to offset the numbering below.")
                label: qsTr("About waypoint numbering")
                labelVisible: false
                color: generic.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: generic.showDialogHints
            }

            ComboBox {
                id: offset
                label: "Offset for waypoint numbers"
                currentIndex: 1

                menu: ContextMenu {
                    MenuItem { text: "+1" }
                    MenuItem { text: "0" }
                    MenuItem { text: "-1" }
                    MenuItem { text: "-2" }
                }
                description: "Align WP numbering with geocache description."
            }

//            Slider {
//                id: offsetSlider
//                value: 0
//                minimumValue: -2
//                maximumValue: +1
//                stepSize: 1
//                width: parent.width
//                valueText: value
//                label: qsTr("Offset for waypoint numbers")
//            }

            TextArea {
                id: description3
                width: parent.width
                height: Screen.height / 6
                text: qsTr("As formulas may get quite long, too much text may be selected. Editing is possible AFTER creating the Geocache. Too much text selected or too little? Change formula search length and try again.")
                label: qsTr("About the coordinates")
                labelVisible: false
                color: generic.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: generic.showDialogHints
            }

            SectionHeader {
                text: qsTr("Coordinates list from raw text")
                color: generic.highlightColor
            }

            Repeater {
                model: listModel
                width: parent.width

                ListItem {
                    width: parent.width
                    height: Theme.itemSizeHuge

                    Row {
                        id: row
                        width: column.width
                        height: Theme.itemSizeLarge
//                        spacing: Theme.paddingLarge

                        TextArea {
                            id: wayptFormula
                            label: (note === "" ? qsTr("WP") : qsTr("Additional WP") ) +  (index + Number(offset.value)) + qsTr(", orig. ") + number
//                            label: qsTr("WP ") + (index + offsetSlider) + qsTr(", orig. ") + number
                            text: TF.truncateString( coord + " | " + note, 80 )
                            width: parent.width - removeIcon.width * 3
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: generic.primaryColor
                            readOnly: true
                        }
                        IconButton {
                            id: upIcon
                            icon.source: "image://theme/icon-m-up"
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            icon.color: generic.primaryColor
//                            anchors {
//                                top: wayptFormula.top
//                                right: removeIcon.left
//                            }
                            enabled: index > 0
                            onClicked: {
                                listModel.move(index, index - 1, 1);
                            }
                        }
                        IconButton {
                            id: removeIcon
                            icon.source: "image://theme/icon-m-remove"
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            icon.color: generic.primaryColor
//                            anchors {
//                                top: wayptFormula.top
//                                right: downIcon.left
//                            }
                            onClicked: {
                                listModel.remove(index);
                            }
                        }
                        IconButton {
                            id: downIcon
                            icon.source: "image://theme/icon-m-down"
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            icon.color: generic.primaryColor
//                            anchors {
//                                top: wayptFormula.top
//                                right: row.right
//                            }
                            enabled: index < listModel.count - 1
                            onClicked: {
                                listModel.move(index, index + 1, 1);
                            }
                        }
                        Separator {
                            width: parent.width
                            color: generic.primaryColor
                        }
                    }
                }
            }

            SectionHeader {
                text: qsTr("End of coordinates list")
                color: generic.highlightColor
            }

        }
    }
}
