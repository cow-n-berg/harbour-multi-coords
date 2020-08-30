import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {
    id: page

    property var coords

    allowedOrientations: Orientation.All
    canAccept: txtCode.text !== "" && txtName.text !== ""
    onAccepted: {
        var coords = [];
        var numberItems = listModel.count;
        for (var i = 0; i < numberItems; ++i) {
            var wpnr = listModel.get(i).number + (listStartWp1.checked ? 1 : 0);
            var coord = listModel.get(i).coord;
            var note = listModel.get(i).note;
            coords.push({coord: coord, number: wpnr, note: note});
        }
        Database.addCache(txtCode.text, txtName.text, coords)
        generic.multiDirty = true
        pageStack.pop()
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

    SilicaFlickable {
        id: addMulti

        PageHeader {
            id: pageHeader
            title: qsTr("Add Multi cache")
        }

        VerticalScrollDecorator { flickable: wpView }

        anchors.fill: parent
        anchors.margins: Theme.paddingMedium
        contentHeight: column.height + Theme.itemSizeMedium
        quickScroll : true

        Column {
            id: column
            width: parent.width
            anchors {
                top: pageHeader.bottom
                margins: 0
            }

            spacing: Theme.paddingMedium

            TextArea {
                id: description1
                width: parent.width
                height: Screen.height / 6
                text: qsTr("Paste the entire Geocache description - or the content of a GPX file! - in the next text area. Use the button to extract possible coordinates and formulas. Use press-and-hold to remove options. Formulas may be too long, you can edit them later. ")
                label: qsTr("How to add")
                color: Theme.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
            }
            TextArea {
                id: rawText
                width: parent.width
                height: Screen.height / 4
                label: "Raw text"
//                text: '2017" maxlon="5.979433" />  <wpt lat="52.132017" lon="5.979433">    <time>2010-08-01T00:00:00</time>    <name>GC22W75</name>    <groundspeak:cache id="1521673" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">      <groundspeak:name>Het Pad Der 7 Zonden</groundspeak:name>&lt;td&gt;Projecteer vanaf het P-coördinaat 29 meter in richting 57°. Onderin deze stenen paal vind je de waardes A en B. De eerste zonde Trots kun je vinden op N 52° 07.A E 005° 59.B. Elke zonde die je met succes weerstaat wordt beloond met de coördinaten voor het volgende waypoint.&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;'
//                text: 'N 47° 36.600 W 122° 20.555  View the ratings for GC3A7RC  View Ratings for GC3A7RC when masterchef and kelientje visited seattle, they commented on ho     waypoint 1: start                                                   you are standing at the very first location of this worldwide chain     waypoint2: N 47° 36.(580+A) W 122° 20.(507+B)                       as the plaque states, this comical artwork was funded by gifts to c     waypoint3: N 47° 36.(547+C) W 122° 20.(494+D)                       this is a more recent seattle business which opened in 2003 and qui     waypoint4 -final: N 47° 36.(589+A+B+C) W 122°20.(542+D+E+F)         PLEASE WATCH OUT FOR MUGGLES. this is a very high traffic area and      first and second to find prize is a gift card to one of the places      You can check your answers for this puzzle on Geochecker.com.      '
//                text: '<?xml version="1.0" encoding="utf-8"?> <gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Groundspeak, Inc. All Rights Reserved. http://www.groundspeak.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd" xmlns="http://www.topografix.com/GPX/1/0">   <name>Cache Listing Generated from Geocaching.com</name>   <desc>This is an individual cache generated from Geocaching.com</desc>   <author>Account "searchandfind_01" From Geocaching.com</author>   <email>contact@geocaching.com</email>   <url>https://www.geocaching.com</url>   <urlname>Geocaching - High Tech Treasure Hunting</urlname>   <time>2020-08-28T18:23:55.9834306Z</time>   <keywords>cache, geocache</keywords>   <bounds minlat="52.378633" minlon="13.3944" maxlat="52.38065" maxlon="13.39465" />   <wpt lat="52.378633" lon="13.3944">     <time>2015-12-30T00:00:00</time>     <name>GC68X03</name>     <desc>Das fast vergessene Buch by searchandfind_01, Multi-cache (3.5/2.5)</desc>     <url>https://www.geocaching.com/seek/cache_details.aspx?guid=a0e7fcad-5fef-4d16-9e0c-6d39187a0648</url>     <urlname>Das fast vergessene Buch</urlname>     <sym>Geocache</sym>     <type>Geocache|Multi-cache</type>     <groundspeak:cache id="5395245" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">       <groundspeak:name>Das fast vergessene Buch</groundspeak:name>       <groundspeak:placed_by>searchandfind_01</groundspeak:placed_by>       <groundspeak:owner id="6542929">searchandfind_01</groundspeak:owner>       <groundspeak:type>Multi-cache</groundspeak:type>       <groundspeak:container>Small</groundspeak:container>       <groundspeak:attributes>         <groundspeak:attribute id="13" inc="1">Available 24/7</groundspeak:attribute>         <groundspeak:attribute id="19" inc="1">Ticks</groundspeak:attribute>         <groundspeak:attribute id="25" inc="1">Parking nearby</groundspeak:attribute>         <groundspeak:attribute id="1" inc="1">Dogs</groundspeak:attribute>         <groundspeak:attribute id="56" inc="1">Medium hike (1 km–10 km)</groundspeak:attribute>       </groundspeak:attributes>       <groundspeak:difficulty>3.5</groundspeak:difficulty>       <groundspeak:terrain>2.5</groundspeak:terrain>       <groundspeak:country>Germany</groundspeak:country>       <groundspeak:state>Berlin</groundspeak:state>       <groundspeak:short_description html="True">&lt;p&gt;Es gibt Geschichten die sind wahr und jene die ersponnen sind. Es gibt Geschichten die ersponnen wirken und doch ein Fünkchen Wahrheit besitzen. Aber seht und liest selbst...&lt;/p&gt;  </groundspeak:short_description>       <groundspeak:long_description html="True">&lt;p&gt;Es ist schon eine Weile her, als sich ein Cacher aufmachte zum Owner zu werden. Man erzählt, er habe ein besonderes Buch bei sich gehabt und fürchtete es an Unwissende zu verlieren. So machte er sich auf es in Sicherheit zu bringen, es zu verstecken, an einem Ort wo es keiner finden würde. Außer einiger wenige seiner Zunft, die in der Lage sein würden seiner Fährte zu folgen, seine Hinweise zu finden und Rätsel zu entschlüsseln. Nur ihnen wollte er es gestatten, das Buch zu finden, zu öffnen und sich für immer in der Liste Jener zu verewigen, die sich als würdig erwiesen haben.​ Die Geschichte und das Buch gerieten fast in Vergessenheit, wären da nicht die Aufzeichnungen des Owners vor kurzem wieder aufgetaucht.&lt;/p&gt; &lt;p&gt;&lt;img alt="Aufzeichung" src="https://img.geocaching.com/cache/large/a41bb0e0-38ff-4363-bb05-ae4118e6e0d9.jpg" /&gt;&lt;/p&gt; &lt;p&gt;&lt;a href="https://www.dropbox.com/s/v8xp4lbr4tymtlb/Aufzeichnungen.JPG?dl=0"&gt;Der Link zum Foto in voller Auflösung&lt;/a&gt;&lt;/p&gt; &lt;p&gt;Hinweis in eigener Sache:&lt;/p&gt; &lt;p&gt;Ihr solltet euch wie in guten alten Cacherzeiten etwas vorbereiten, eventuell auch die Aufzeichnungen ausdrucken. Die ganze Runde ist etwa 4,5km lang. Plant für die Runde aber etwas mehr Zeit ein, da es sich größtenteils um vor Ort Rätsel handelt. An vier Stationen müsst ihr euch Hinweise notieren! &lt;/p&gt; Der Multi ist ganzjährig machbar, allerdings nicht bei einer geschlossenen Schneedecke!! &lt;p&gt;Bitte hinterlasst alles so wie ihr es vorgefunden habt und deponiert alle Gegenstände wieder an den Fundorten. Geht behutsam mit den gefunden Gegenständen um. Nur so können die Stationen lange bestehen und jeder Cacher nach euch, das gleiche Cache-Erlebnis erfahren. Danke !&lt;/p&gt; &lt;br /&gt; &lt;br /&gt; &lt;p&gt;Auf Wunsch gibt es nun ein Banner für euer Profil:&lt;/p&gt; &lt;a href="http://coord.info/GC68X03"&gt;&lt;img src="https://s3.amazonaws.com/gs-geo-images/86ce6dd6-e0d8-4c77-bff0-d76ad99c5198_l.jpg" alt border="0" width="350" height /&gt;&lt;/a&gt; &lt;p&gt;...einfach folgenden Code ins Profil kopieren:&lt;/p&gt; &lt;p&gt;&amp;lt;a href="http://coord.info/GC68X03"&amp;gt;&amp;lt;img src="https://s3.amazonaws.com/gs-geo-images/86ce6dd6-e0d8-4c77-bff0-d76ad99c5198_l.jpg" alt="" border="0" width="350" height=""&amp;gt;&amp;lt;/a&amp;gt;&lt;/p&gt; &lt;br /&gt; &lt;br /&gt; &lt;p&gt;Additional Hidden Waypoints&lt;/p&gt;0068X03 - Parkplatz&lt;br /&gt;N 52° 22.839 E 013° 23.679&lt;br /&gt;Hier ist Platz für euer Cachemobil&lt;br /&gt;0168X03 - Das Medaillon&lt;br /&gt;N 52° 22.718 E 013° 23.664&lt;br /&gt;&lt;br /&gt;0268X03 - Die chinesischen Karten&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0368X03 - Das Seil&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0468X03 - Das Grab&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0668X03 - Der Sternenkompass&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0768X03 - Der Sechsling&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0868X03 - Das Codebrett&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;FN68X03 - Der Tresor (Final)&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;</groundspeak:long_description> groundspeak:cache>   </wpt>   <wpt lat="52.38065" lon="13.39465">     <time>2015-12-30T10:28:00.047</time>     <name>0068X03</name>     <cmt>Hier ist Platz für euer Cachemobil</cmt>     <desc>Parkplatz</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=d73eeea2-67c8-459d-93a5-05e727a9f827</url>     <urlname>Parkplatz</urlname>     <sym>Parking Area</sym>     <type>Waypoint|Parking Area</type>   </wpt>   <wpt lat="52.378633" lon="13.3944">     <time>2015-12-30T10:35:05.687</time>     <name>0168X03</name>     <cmt />     <desc>Das Medaillon</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=62f8bfb2-def9-4ec0-b4c8-c69578cfe65b</url>     <urlname>Das Medaillon</urlname>     <sym>Physical Stage</sym>     <type>Waypoint|Physical Stage</type>   </wpt> </gpx>'
                text: '<?xml version="1.0" encoding="utf-8"?><gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Groundspeak, Inc. All Rights Reserved. http://www.groundspeak.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd" xmlns="http://www.topografix.com/GPX/1/0">  <name>Cache Listing Generated from Geocaching.com</name>  <desc>This is an individual cache generated from Geocaching.com</desc>  <author>Account "kangaroo22" From Geocaching.com</author>  <email>contact@geocaching.com</email>  <url>https://www.geocaching.com</url>  <urlname>Geocaching - High Tech Treasure Hunting</urlname>  <time>2020-08-29T06:38:31.2935264Z</time>  <keywords>cache, geocache</keywords>  <bounds minlat="52.073767" minlon="5.199117" maxlat="52.075467" maxlon="5.205783" />  <wpt lat="52.0745" lon="5.201">    <time>2020-06-11T00:00:00</time>    <name>GC8TTAK</name>    <desc>Ringslang by kangaroo22, Multi-cache (1.5/2)</desc>    <url>https://www.geocaching.com/seek/cache_details.aspx?guid=27b3f787-94a9-4a9a-84f9-dc596d533f54</url>    <urlname>Ringslang</urlname>    <sym>Geocache</sym>    <type>Geocache|Multi-cache</type>    <groundspeak:cache id="7746177" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">      <groundspeak:name>Ringslang</groundspeak:name>      <groundspeak:placed_by>kangaroo22</groundspeak:placed_by>      <groundspeak:owner id="730096">kangaroo22</groundspeak:owner>      <groundspeak:type>Multi-cache</groundspeak:type>      <groundspeak:container>Small</groundspeak:container>      <groundspeak:attributes>        <groundspeak:attribute id="32" inc="0">Bicycles</groundspeak:attribute>        <groundspeak:attribute id="14" inc="0">Recommended at night</groundspeak:attribute>        <groundspeak:attribute id="13" inc="0">Available 24/7</groundspeak:attribute>        <groundspeak:attribute id="25" inc="1">Parking nearby</groundspeak:attribute>        <groundspeak:attribute id="7" inc="1">Takes less than one hour</groundspeak:attribute>        <groundspeak:attribute id="6" inc="1">Recommended for kids</groundspeak:attribute>        <groundspeak:attribute id="55" inc="1">Short hike (&lt;1 km)</groundspeak:attribute>      </groundspeak:attributes>      <groundspeak:difficulty>1.5</groundspeak:difficulty>      <groundspeak:terrain>2</groundspeak:terrain>      <groundspeak:country>Netherlands</groundspeak:country>      <groundspeak:state>Utrecht</groundspeak:state>      <groundspeak:short_description html="True"></groundspeak:short_description>      <groundspeak:long_description html="True">&lt;p&gt;Deze cache is een korte wandeling van ongeveer 1 kilometer over landgoed de Niënhof bij Bunnik. Je volgt het ringslangpad, mogelijk kom je zelf ook nog wel een ringslang tegen!  De cache is zeer geschikt voor (kleine) kinderen, in de doos zitten wat kleine speelgoedjes die geruild kunnen worden volgens het oorspronkelijke cache-principe (dus alleen iets meenemen als je ook iets achterlaat).&lt;/p&gt;&lt;p&gt;Parkeren bij de ingang, tevens kan je daar je fiets stallen. Het is niet de bedoeling deze fietsend te doen, in het bos zijn fietsers niet toegestaan.&lt;/p&gt;&lt;p&gt;&lt;img alt="Ringslang" src="https://img.geocaching.com/cache/84c12a70-15b7-4d88-b3c4-5a44e7649505.jpg?rnd=0.2838404" style="height:400px;width:600px;" /&gt;&lt;/p&gt;&lt;p&gt;Ringslangen leggen hun eieren in zogenaamde broedhopen, in dit gebied zijn er een aantal aangelegd. Deze hopen moeten aan een aantal voorwaarden voldoen. Het is belangrijk dat het materiaal voldoende los is, zodat een ringslangvrouwtje er gemakkelijk in kan kruipen. De temperatuur in de hoop moet constant rond de 25 tot 30°C zijn. En de hoop moet voldoende vochtig zijn. &lt;/p&gt;&lt;p&gt;Wandel het gebied in en sla op een gegeven moment linksaf het bos in.&lt;/p&gt;&lt;p&gt;&lt;strong&gt;WP1&lt;/strong&gt;: Op de brug, loop je over een aantal planken en iedere plank is met een aantal flinke schroeven vastgezet. Hoeveel schroeven zijn dat per plank (voor de meeste planken)? Dit aantal stapeltellen tot 1 cijfer is X&lt;/p&gt;&lt;p&gt;Ringslangen kunnen uitstekend zwemmen, misschien zie jer er wel eentje!&lt;/p&gt;&lt;p&gt;Vervolg je wandeling via het pad door het bos&lt;/p&gt;&lt;p&gt;&lt;strong&gt;WP2&lt;/strong&gt;: Je vind hier een paaltje met een volgnummer (begint met NIE). Wat is het laatste cijfer van het nummer? Dat is Y.&lt;/p&gt;&lt;p&gt;Loop door langs de rand van het gebied en geniet van het uitzicht. Hou ook je ogen open voor slangen, er zijn hier een aantal broedplaatsen.&lt;/p&gt;&lt;p&gt;&lt;strong&gt;WP3&lt;/strong&gt;: Een bankje met daarop een klein bordje waarop te lezen is hoe het bankje daar gekomen is. Het laatste cijfer op dit bordje is Z.&lt;/p&gt;&lt;p&gt;Op naar de eindlocatie: bereken XYZ * 2034 - 178 je krijgt nu ABCDEF&lt;br /&gt;De cache ligt op &lt;strong&gt;N 52 4.ABC E 5 12.DEF&lt;/strong&gt;&lt;/p&gt;&lt;p&gt;Veel plezier!&lt;/p&gt;&lt;p&gt;&lt;strong&gt;Deze cache is geplaatst met toestemming van het Utrechts Landschap.&lt;/strong&gt;&lt;/p&gt;&lt;ul&gt;&lt;li&gt;&lt;span style="font-size:10pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;&lt;span style="font-size:11.0pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;Toegang is toegestaan tussen zonsopkomst en zonsondergang&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/li&gt;&lt;li&gt;&lt;span style="font-size:10pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;&lt;span style="font-size:11.0pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;Men dient op de paden te blijven. De cache ligt maximaal 1 meter naast het pad.&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/li&gt;&lt;li&gt;&lt;span style="font-size:10pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;&lt;span style="font-size:11.0pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;Honden zijn in dit gebied niet toegestaan&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/li&gt;&lt;li&gt;&lt;span style="font-size:10pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;&lt;span style="font-size:11.0pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;Informatie over het gebied kunt u vinden op: &lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;/span&gt;&lt;a href="https://www.utrechtslandschap.nl/natuurgebieden/landgoed-ni%C3%ABnhof/ontdek"&gt;https://www.utrechtslandschap.nl/natuurgebieden/landgoed-ni%C3%ABnhof/ontde&lt;/a&gt;&lt;/li&gt;&lt;/ul&gt;&lt;p&gt;Additional Hidden Waypoints&lt;/p&gt;018TTAK - Brug&lt;br /&gt;N 52° 04.470 E 005° 12.060&lt;br /&gt;Op de brug, loop je over een aantal planken en iedere plank is met een aantal flinke schroeven vastgezet. Hoeveel schroeven zijn dat per plank (voor de meeste planken)? Dit aantal stapeltellen tot 1 cijfer is X&lt;br /&gt;028TTAK - Paaltje&lt;br /&gt;N 52° 04.528 E 005° 12.175&lt;br /&gt;Je vind hier een paaltje met een volgnummer (begint met NIE). Wat is het laatste cijfer van het nummer? Dat is Y&lt;br /&gt;038TTAK - Bankje&lt;br /&gt;N 52° 04.426 E 005° 12.347&lt;br /&gt;Een bankje met daarop een klein bordje waarop te lezen is hoe het bankje daar gekomen is. Het laatste cijfer op dit bordje is Z&lt;br /&gt;FN8TTAK - Final Location&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Bereken XYZ * 2034 - 178, je krijgt nu ABCDEF, de cache ligt op N 52 4.ABC E 5 12.DEF&lt;br /&gt;P08TTAK - Parkeerplaats&lt;br /&gt;N 52° 04.450 E 005° 11.947&lt;br /&gt;Parkeerplaats&lt;br /&gt;</groundspeak:long_description>      <groundspeak:encoded_hints>Pas op dat je niet gebeten wordt!</groundspeak:encoded_hints>  </wpt>  <wpt lat="52.0745" lon="5.201">    <time>2020-06-11T13:30:43.553</time>    <name>018TTAK</name>    <cmt>Op de brug, loop je over een aantal planken en iedere plank is met een aantal flinke schroeven vastgezet. Hoeveel schroeven zijn dat per plank (voor de meeste planken)? Dit aantal stapeltellen tot 1 cijfer is X</cmt>    <desc>Brug</desc>    <url>https://www.geocaching.com/seek/wpt.aspx?WID=bb5c5961-cad9-423d-a4a6-577c81880702</url>    <urlname>Brug</urlname>    <sym>Virtual Stage</sym>    <type>Waypoint|Virtual Stage</type>  </wpt>  <wpt lat="52.075467" lon="5.202917">    <time>2020-06-11T13:30:43.553</time>    <name>028TTAK</name>    <cmt>Je vind hier een paaltje met een volgnummer (begint met NIE). Wat is het laatste cijfer van het nummer? Dat is Y</cmt>    <desc>Paaltje</desc>    <url>https://www.geocaching.com/seek/wpt.aspx?WID=80342512-cd20-4f07-bc5b-1a7f9621e1d8</url>    <urlname>Paaltje</urlname>    <sym>Virtual Stage</sym>    <type>Waypoint|Virtual Stage</type>  </wpt>  <wpt lat="52.073767" lon="5.205783">    <time>2020-06-16T11:43:48.867</time>    <name>038TTAK</name>    <cmt>Een bankje met daarop een klein bordje waarop te lezen is hoe het bankje daar gekomen is. Het laatste cijfer op dit bordje is Z</cmt>    <desc>Bankje</desc>    <url>https://www.geocaching.com/seek/wpt.aspx?WID=6473e7bd-0e5d-42de-8204-1f691c7eae2e</url>    <urlname>Bankje</urlname>    <sym>Virtual Stage</sym>    <type>Waypoint|Virtual Stage</type>  </wpt>  <wpt lat="52.074167" lon="5.199117">    <time>2020-06-11T13:30:43.553</time>    <name>P08TTAK</name>    <cmt>Parkeerplaats</cmt>    <desc>Parkeerplaats</desc>    <url>https://www.geocaching.com/seek/wpt.aspx?WID=6868ae6a-fdf7-486f-94ec-062c469037ab</url>    <urlname>Parkeerplaats</urlname>    <sym>Parking Area</sym>    <type>Waypoint|Parking Area</type>  </wpt></gpx>'
                placeholderText: qsTr("Paste description, formula or raw text here")
                font.pixelSize: Theme.fontSizeExtraSmall
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
             }

            Button {
                height: Theme.itemSizeLarge
                preferredWidth: Theme.buttonWidthLarge
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Process raw text")
                onClicked: {
                    var results = TF.coordsByRegEx(rawText.text)
                    txtCode.text = results.code
                    txtName.text = results.name
                    coords = results.coords
                    listModel.update()
               }
            }

            SectionHeader {
                text: qsTr("Results: Geocache items")
            }

            TextField {
                id: txtCode
                label: qsTr("Geocache code")
                placeholderText: "GCXXXXX"
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextField {
                id: txtName
                label: qsTr("Geocache name")
                placeholderText: label
                width: parent.width
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            TextSwitch {
                id: listStartWp1
                text: "First coordinate is WP " + (checked ? "1" : "0" )
            }

            TextArea {
                id: description2
                width: parent.width
                height: Screen.height / 6
                text: qsTr("As formulas may get quite long, too much text may be selected. Editing is possible AFTER creating the Geocache.")
                label: qsTr("About the coordinates")
                color: Theme.highlightColor
                readOnly: true
                font.pixelSize: Theme.fontSizeExtraSmall
            }

            SectionHeader {
                text: qsTr("Coordinates list from raw text")
            }

            Repeater {
                model: listModel
                width: parent.width

                ListItem {
                    width: parent.width

                    Row {
                        width: column.width
                        height: wayptFormula.height
                        spacing: Theme.paddingMedium

                        TextArea {
                            id: wayptFormula
                            label: qsTr("Waypoint ") + (number + (listStartWp1.checked ? 1 : 0))
                            text: coord
                            width: parent.width - removeIcon.width
                            font.pixelSize: Theme.fontSizeExtraSmall
                            readOnly: true
//                            EnterKey.iconSource: "image://theme/icon-m-enter-close"
//                            EnterKey.onClicked: focus = false
                        }
                        IconButton {
                            id: removeIcon
                            icon.source: "image://theme/icon-m-remove"
                            icon.width: Theme.iconSizeMedium
                            icon.height: Theme.iconSizeMedium
                            anchors.top: wayptFormula.top
                            onClicked: {
                                listModel.remove(index);
                            }
                        }
                        Separator {
                            width: parent.width
                        }
                    }
                }
            }

            SectionHeader {
                text: qsTr("End of coordinates list")
            }

//            Button {
//                height: Theme.itemSizeLarge
//                preferredWidth: Theme.buttonWidthLarge
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: qsTr("Add Geocache")
//                enabled: txtCode.text != "" && txtName.text !== ""
//                onClicked: {
//                    var coords = [];
//                    var numberItems = listModel.count;
//                    console.log("items listModel: " + numberItems);
//                    for (var i = 0; i < numberItems; ++i) {
//                        var wpnr = listModel.get(i).number + (listStartWp1.checked ? 1 : 0);
//                        var coord = listModel.get(i).coord;
//                        console.log(wpnr + " - " + coord);
//                        coords.push({coord: coord, number: wpnr});
//                    }
//                    Database.addCache(txtCode.text, txtName.text, coords)
//                    generic.multiDirty = true
//                    pageStack.pop()
//                }
//            }
        }
    }
}
