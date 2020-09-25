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
    property var strHouten        : '<?xml version="1.0" encoding="utf-8"?> <gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Groundspeak, Inc. All Rights Reserved. http://www.groundspeak.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd" xmlns="http://www.topografix.com/GPX/1/0">   <name>Cache Listing Generated from Geocaching.com</name>   <desc>This is an individual cache generated from Geocaching.com</desc>   <author>Account "PeterBar" From Geocaching.com</author>   <email>contact@geocaching.com</email>   <url>https://www.geocaching.com</url>   <urlname>Geocaching - High Tech Treasure Hunting</urlname>   <time>2020-09-25T08:24:58.1128965Z</time>   <keywords>cache, geocache</keywords>   <bounds minlat="52.019267" minlon="5.195367" maxlat="52.019417" maxlon="5.195567" />   <wpt lat="52.019267" lon="5.195367">     <time>2019-03-02T00:00:00</time>     <name>GC846PB</name>     <desc>(Ont)Spanning in Houten by PeterBar, Multi-cache (1.5/2)</desc>     <url>https://www.geocaching.com/seek/cache_details.aspx?guid=2bfb34e1-e949-4ccb-a7b9-0cfc7d0b5d88</url>     <urlname>(Ont)Spanning in Houten</urlname>     <sym>Geocache</sym>     <type>Geocache|Multi-cache</type>     <groundspeak:cache id="7102671" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">       <groundspeak:name>(Ont)Spanning in Houten</groundspeak:name>       <groundspeak:placed_by>PeterBar</groundspeak:placed_by>       <groundspeak:owner id="7096072">PeterBar</groundspeak:owner>       <groundspeak:type>Multi-cache</groundspeak:type>       <groundspeak:container>Micro</groundspeak:container>       <groundspeak:attributes>         <groundspeak:attribute id="15" inc="1">Available in winter</groundspeak:attribute>         <groundspeak:attribute id="56" inc="1">Medium hike (1 km–10 km)</groundspeak:attribute>         <groundspeak:attribute id="13" inc="1">Available 24/7</groundspeak:attribute>         <groundspeak:attribute id="8" inc="1">Scenic view</groundspeak:attribute>         <groundspeak:attribute id="40" inc="1">Stealth required</groundspeak:attribute>         <groundspeak:attribute id="6" inc="1">Recommended for kids</groundspeak:attribute>         <groundspeak:attribute id="25" inc="1">Parking nearby</groundspeak:attribute>         <groundspeak:attribute id="41" inc="1">Stroller accessible</groundspeak:attribute>         <groundspeak:attribute id="1" inc="1">Dogs</groundspeak:attribute>       </groundspeak:attributes>       <groundspeak:difficulty>1.5</groundspeak:difficulty>       <groundspeak:terrain>2</groundspeak:terrain>       <groundspeak:country>Netherlands</groundspeak:country>       <groundspeak:state>Utrecht</groundspeak:state>       <groundspeak:short_description html="True"> </groundspeak:short_description>       <groundspeak:long_description html="True">&lt;p&gt;Kom lekker ontspannen in Houten gedurende een 2 ½ kilometer lange wandeling door een zeer mooi stukje Houten.&lt;br /&gt; Voor kinderen zijn her en der leuke inspannende activiteiten te vinden.&lt;br /&gt; Vergeet bij mooi weer niet je strandspulletjes mee te nemen voor het geval je nog meer wilt ontspannen.&lt;/p&gt; &lt;p&gt;Veel plezier toegewenst met deze leuke Multi-Cache.&lt;/p&gt; &lt;p&gt;Voor mensen die hun trouwe viervoeter mee willen nemen, lees het volgende: &lt;a href="http://www.houten.nl/hondenbeleid"&gt;http://www.houten.nl/hondenbeleid&lt;/a&gt;&lt;br /&gt; Dit betekent dat als je alleen samen met je viervoeter deze cache wilt lopen je niet bij WP4 kan komen.&lt;br /&gt; Neem in dat geval gezellig iemand mee die even de viervoeter bij zich kan houden als je zelf het laatste kleine stukje naar WP4 gaat om de vraag te kunnen beantwoorden.&lt;br /&gt; (Vergeet dus ook niet een zakje mee te nemen.)&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP1:&lt;/strong&gt;&lt;br /&gt; N 52° 01.156, E 005° 11.722&lt;br /&gt; &lt;strong&gt;A&lt;/strong&gt; = Het aantal horizontale metalen stangen om mee omhoog te klimmen.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP2:&lt;/strong&gt;&lt;br /&gt; N 52° 01.1(A - 3)2, E 005° 11.676&lt;br /&gt; &lt;strong&gt;B&lt;/strong&gt; = De som van alle cijfers onder het zoetwatermeer.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP3:&lt;/strong&gt;&lt;br /&gt; N 52° 01.(B)9, E 005° 11.512&lt;br /&gt; &lt;strong&gt;C&lt;/strong&gt; = Het aantal palen met metalen punten.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP4:&lt;/strong&gt;&lt;br /&gt; N 52° 01.(A + B)1, E 005° 11.(B + C + 3)7&lt;br /&gt; &lt;strong&gt;D&lt;/strong&gt; = De woordwaarde (herleiden tot 1 cijfer) van alle letters op het ronde metalen plaatje op de boeg.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP5:&lt;/strong&gt;&lt;br /&gt; N 52° 01.(C * D + 5)3, E 005 ° 11.(B - C + 1)5&lt;br /&gt; Schakel hier over naar de satelliet en zoom in op dit gebied.&lt;br /&gt; &lt;strong&gt;E&lt;/strong&gt; = het aantal rotsblokken dat je nu kan tellen binnen de omliggende fietspaden en wegen.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP6:&lt;/strong&gt;&lt;br /&gt; N 52° 01.2(E -  1)4, E 005° 11.(B)8&lt;br /&gt; &lt;strong&gt;F&lt;/strong&gt; = Het aantal groene activiteiten.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP7:&lt;/strong&gt;&lt;br /&gt; N 52° 01.(F * F + 2) 1, E 005° 11.0(C + F - 1)6&lt;br /&gt; &lt;strong&gt;G&lt;/strong&gt; = Aantal metalen palen van het speeltoestel.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP8:&lt;/strong&gt;&lt;br /&gt; N 52° 01.(E + G + 1)3, E 005° 11.(B - G + A)2&lt;br /&gt; &lt;strong&gt;H&lt;/strong&gt; = Het product van de cijfers voor Bouwen.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP9:&lt;/strong&gt;&lt;br /&gt; N 52° 01.1(H), E 005° 11.4(C * H + 1)&lt;br /&gt; &lt;strong&gt;K&lt;/strong&gt; = De laatste twee cijfers onder de rode lamp.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;WP10:&lt;/strong&gt;&lt;br /&gt; N 52° 01.0(H + K + 1), E 005° 11.(H + K + 2)2&lt;br /&gt; &lt;strong&gt;L&lt;/strong&gt; = Het aantal zitjes op dit object.&lt;br /&gt;  &lt;/p&gt; &lt;p&gt;Hoera, je bent er nu bijna!&lt;br /&gt; Ga nu even op het randje zitten om de locatie van de cache te berekenen.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;&lt;em&gt;Een leuk weetje:&lt;/em&gt;&lt;/strong&gt;&lt;/p&gt; &lt;p&gt;De wijk waar je je nu in bevindt is opgeleverd in 2001. Daar worden 310 huizen verwarmt met warmtepompen. Hiervoor loopt een speciaal gesloten waterleidingnetwerk door de wijk waar de huizen middels warmtewisselaars in de warmtepomp wat warmte aan onttrekken. Op een centrale plek in de wijk zitten een aantal bronnen waar de warmte van gebruikt wordt om over te dragen op dat netwerk (ook weer via warmtewisselaars). Als je hier vandaan naar het zuidwesten zou lopen komt je bij die centrale plek.&lt;/p&gt; &lt;p&gt;In de zomer verloopt dit proces tegenovergesteld. De huizen worden dan lekker gekoeld en die warmte daarvan wordt weer terug gestopt in de bron. Omdat er minder warmte terugkomt bij het koelen dan dat nodig is om te verwarmen zijn er nog eens 115 woningen aangesloten op dat netwerk. Die woningen kunnen niet via dit netwerk verwarmen maar in de zomer wel lekker koelen. Op die manier komt er toch weer genoeg warmte terug in de bron.&lt;/p&gt; &lt;p&gt;De plas waar je langs gelopen bent kan indien nodig ook gebruikt worden om warmte aan te onttrekken indien de bronnen te koud zouden gaan worden.&lt;/p&gt; &lt;p&gt;&lt;strong&gt;Controlegetal:&lt;/strong&gt;&lt;/p&gt; &lt;p&gt;A + B + C + D + E + F + G + H + K + L = 133&lt;/p&gt; &lt;p&gt; &lt;/p&gt; &lt;p&gt;&lt;strong&gt;Cache:&lt;/strong&gt;&lt;br /&gt; N 52° 01.( B * C + A + C ), E 005° 11.( (H * K) - (E * H) + (A / L) )&lt;/p&gt; &lt;p&gt;&lt;strong&gt;Voorzichtig voor dreuzels (muggles), probeer niet op te vallen.&lt;/strong&gt;&lt;/p&gt; &lt;p&gt;Let op! Zorg dat je het logrolletje weer goed oprolt en als eerste in het korte deel van de container terugplaatst. Plaats daarna het langere deel van de container er overheen.&lt;br /&gt; Gezien de omvang van de container past er helaas niets anders in dan het logrolletje. Er is dan ook geen pen aanwezig.&lt;br /&gt; &lt;span style="font-size:11.0pt;"&gt;&lt;span style="font-family:&amp;amp;quot;"&gt;Leg de container weer terug op de plaats waar je hem gevonden hebt. Stop hem dus niet helemaal onder in het midden van de verstopplaats, anderen zouden dan moeite hebben om hem er weer uit te halen.&lt;/span&gt;&lt;/span&gt;&lt;/p&gt;  &lt;p&gt;Additional Hidden Waypoints&lt;/p&gt;01846PB - GC846PB WP1&lt;br /&gt;N 52° 01.156 E 005° 11.722&lt;br /&gt;Ga naar: N 52° 01.156 E 005° 11.722 A = Het aantal horizontale metalen stangen om mee omhoog te klimmen.&lt;br /&gt;02846PB - GC846PB WP2&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.1(A - 3)2 E 005° 11.676 B = De som van alle cijfers onder het zoetwatermeer.&lt;br /&gt;03846PB - GC846PB WP3&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.(B)9 E 005° 11.512 C = Het aantal palen met metalen punten.&lt;br /&gt;04846PB - GC846PB WP4&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.(A + B)1 E 005° 11.(B + C + 3)7 D = De woordwaarde (herleiden tot 1 cijfer) van alle letters op het ronde metalen plaatje op de boeg.&lt;br /&gt;05846PB - GC846PB WP5&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.(C * D + 5)3 E 005 ° 11.(B - C + 1)5 E = het aantal rotsblokken dat je nu kan tellen binnen de omliggende fietspaden en wegen.&lt;br /&gt;06846PB - GC846PB WP6&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.2(E -  1)4 E 005° 11.(B)8 F = Het aantal groene activiteiten.&lt;br /&gt;07846PB - GC846PB WP7&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.(F * F + 2)1 E 005° 11.0(C + F - 1)6 G = Aantal metalen palen van het speeltoestel.&lt;br /&gt;08846PB - GC846PB WP8&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.(E + G + 1)3 E 005° 11.(B - G + A)2 H = Het product van de cijfers voor Bouwen.&lt;br /&gt;09846PB - GC846PB WP9&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.1(H) E 005° 11.4(C * H + 1) K = De laatste twee cijfers onder de rode lamp.&lt;br /&gt;10846PB - GC846PB WP10&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Ga naar: N 52° 01.0(H + K + 1) E 005° 11.(H + K + 2)2 L = Het aantal zitjes op dit object.&lt;br /&gt;FN846PB - Final Location&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;Controlegetal:  A + B + C + D + E + F + G + H + K + L = 133  Cache: N 52° 01.( B * C + A + C ) E 005° 11.( (H * K) - (E * H) + (A / L) )&lt;br /&gt;PK846PB - Virtueel punt&lt;br /&gt;N 52° 01.165 E 005° 11.734&lt;br /&gt;&lt;br /&gt;</groundspeak:long_description>       <groundspeak:encoded_hints>- Spanning op hoogte (rond de 1,80 meter), is dat hoogspanning? - [WP6] Bij het bepalen van F zijn lezen &amp; tellen 2 verschillende activiteiten.</groundspeak:encoded_hints>       <groundspeak:logs>         <groundspeak:log id="966666619">           <groundspeak:date>2020-09-24T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="20785664">GlobetrotterJoanna</groundspeak:finder>           <groundspeak:text encoded="False">Na een niet te lang rondje deze cache vlot gevonden op een logische plek.  PeterBar dank je wel voor deze multi en de cache.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="966553197">           <groundspeak:date>2020-09-24T20:47:40Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="4887454">finndtastischh</groundspeak:finder>           <groundspeak:text encoded="False">Een mooie route door houten zuid. Zomers vele uren doorgebracht met zwemmen. Alle wp goes kunnen vinden, alleen moesten we soms even goed kijken en opnieuw lezen. Na het laatste wp de cijfers  opgeteld en kwamen tot het juiste cijfer, dus kon de eindlocatie berekend worden. Hier even gewacht tot spelende kinderen weer verder gingen. En konden we ongezien loggen  tftc</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="966527975">           <groundspeak:date>2020-09-24T17:47:17Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="2379484">Team vdWal</groundspeak:finder>           <groundspeak:text encoded="False">Leuke route in leuke omgeving. Dank voor deze. </groundspeak:text>         </groundspeak:log>         <groundspeak:log id="965843176">           <groundspeak:date>2020-09-20T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="1568181">eikenboom</groundspeak:finder>           <groundspeak:text encoded="False">Van het mooie weer gebruik gemaakt om weer een multi in buurgemeente Houten te zoeken. De informatie was over het algemeen gemakkelijk te vinden, maar ik vind het wel jammer dat er geen punten bezocht worden die op het unieke karakter van deze wijk (wat mij betreft de leukste in Houten) wat betreft energiehuishouding slaan, een gemiste kans. Onderweg een ander team tegengekomen die ook deze cache liep (het was vandaag erg druk hier met cachers). WP10 zat er een flink stuk naast, maar met de checksum was de waarde voor L niet moeilijk te vinden en het was duidelijk waar het WP had moeten liggen. Dankzij de hint (maar waar zou hij hier anders moeten liggen) was de cache snel gevonden.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="965508942">           <groundspeak:date>2020-09-20T22:40:21Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="14308331">ec74</groundspeak:finder>           <groundspeak:text encoded="False">Leuk! Met de kinderen gedaan.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="965444813">           <groundspeak:date>2020-09-20T20:54:46Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="31529782">Vlark</groundspeak:finder>           <groundspeak:text encoded="False">Met de juiste getallen eerst twee keer de verkeerde eindlocatie berekend. Na afloop toch nog de cache gevonden!</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="965073157">           <groundspeak:date>2020-09-19T22:53:18Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="31671730">0511Stan</groundspeak:finder>           <groundspeak:text encoded="False">Gevonden! Heel leuk gedaan! Super mooie route, we hebben bij WP6 wel even lopen zoeken en dat duurde wel even! Uiteindelijk hulp gevraagd en toch gelukt! Goed te fietsen.   Bij de eindlocatie hebben we echt 30 min lopen zoeken maar als je logisch nadenkt dan kom je er wel!  Super leuk gedaan! TFTC Bedankt Peter!</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="958058879">           <groundspeak:date>2020-08-25T03:42:27Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="20790918">Pino030</groundspeak:finder>           <groundspeak:text encoded="False">Afgelopen zaterdag deze multi gefietst. Alle punten werden goed gevonden. Bij punt6 heb ik er zelf een activiteit bij bedacht om op een plausibel coördinaat te komen. Vooraf had ik de hint wel gelezen maar ter plekke niet aan gedacht. Bij punt10 had ik een andere zitplaats bedacht. Op deze tribune was veel meer plek maar dankzij het controlegetal was die fout snel gevonden. Zo kwam ik op een plausibel coördinaat voor de cache uit. Ter plekke goed gezocht en op basis van logjes wel bedacht waar het moest zijn. Maar helaas was de cache geript. Gisteren bericht gekregen van CO dat er een nieuwe ligt dus vandaag mijn naam in een vers logboeken kunnen schrijven.  Bedankt voor deze uitgebreide multi, een favo dik verdiend.  </groundspeak:text>         </groundspeak:log>         <groundspeak:log id="953520021">           <groundspeak:date>2020-08-11T05:43:44Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="30244507">RubyJoyce</groundspeak:finder>           <groundspeak:text encoded="False">Dat was best een pittige met hier en daar twijfel. Mijn eerste multicache. Maar uiteindelijk klopte de optelsom 😁. Bedankt voor de leuke wandeling. Hilarisch moment: onderweg keek ik lang op een bord omdat ik twijfelde aan het product van de cijfers. Een sporter die vlak naast me aan het rekken en strekken was zei: "je bent in Houten hoor!" 🤣 Mijn hulpaap geniet nog even van een prachtige zonsondergang bij het water.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="949506169">           <groundspeak:date>2020-07-28T18:56:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="2732304">EdAnita</groundspeak:finder>           <groundspeak:text encoded="False">Ons laatste dagje in Bunnik en wij gaan vandaag zonder kleinkinderen op pad en plannen een groot rondje in. Via Houten naar Zeist en dan onderweg nog caches in andere dorpen/plaatsen.  We hebben ons vermaakt en wel een paar keer moeten zoeken maar over het algemeen ging het goed. Als er iets te melden is zullen we dat hier doen en anders een probleemloze found.  Onze dochter vertrok 16 jaar geleden naar Houten waar ze een paar jaar heeft gewoond. Toen dus al meerdere keren hier geweest en het blijft lekker fietsen hier.  PeterBar bedankt voor het leggen van deze cache [;)]</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="949789798">           <groundspeak:date>2020-07-11T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="4312500">paulien87</groundspeak:finder>           <groundspeak:text encoded="False">Tftc</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="943714192">           <groundspeak:date>2020-07-11T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="28291635">basjubels</groundspeak:finder>           <groundspeak:text encoded="False">Helaas geen pen mee maar wel super mooie route (leuk rondje) en leuke puzzels. Even lastig om te vinden maar uiteindelijk gelukt.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="941447027">           <groundspeak:date>2020-07-03T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="14450195">DaarZijnZeWeer</groundspeak:finder>           <groundspeak:text encoded="False">Vandaag deze multi gelopen. Nooit geweten dat Houten een strand heeft. Mooi aangelegd die plas in de woonwijk. Alles was goed te vinden alleen bij F even de fout in gegaan. Dit was snel doorzien en hersteld en de route verliep verder probleemloos. Op GZ ff pulken want de cache zat klem maar het is gelukt. Bedankt voor het plaatsen en onderhouden.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="940667718">           <groundspeak:date>2020-06-29T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="15087611">PaMaTw2003</groundspeak:finder>           <groundspeak:text encoded="False">Na het avondeten wandelen we ter ontspanning deze Multi.  Deze wijk in Houten kennen wij nog niet, maar hij maakt wel indruk (met als de 4 suppers trouwens, die fanatiek trainen op de plas.  De vragen bij de Multi zijn goed te beantwoorden en zo komen we telkens op een logisch punt uit. De keer dat de locatie van het volgende waypoint minder logisch was, bleken we de vraag niet goed genoeg gelezen te hebben..  PeterBar, dank voor het leggen en onderhouden van deze cache.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="936466240">           <groundspeak:date>2020-06-14T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="730096">kangaroo22</groundspeak:finder>           <groundspeak:text encoded="False">Duidelijke multi met goed vindbare WPs, leuke tocht! Op de fiets gedaan. Aan het eind klopte de checksum direct en ook de cache had ik daarna snel in handen. Container kwam me heel bekend voor, gisteren zon zelfde gelogd in Houten!  TFTC </groundspeak:text>         </groundspeak:log>         <groundspeak:log id="933397075">           <groundspeak:date>2020-06-03T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="16869127">Poppetjes</groundspeak:finder>           <groundspeak:text encoded="False">Bedankt voor de cache in dit hele mooie stukje van Houten! Papa kon steeds heerlijk puzzelen terwijl de kids zich in de speeltuintjes vermaakten.</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="931831709">           <groundspeak:date>2020-05-30T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="3428332">Peanky</groundspeak:finder>           <groundspeak:text encoded="False">Een fietstocht vandaag naar Houten om daar eens wat smileys te plaatsen. Houten met de auto is voor ons niet heel ontspannend. Op de fiets gaat dat echt een stuk beter.   42km gefietst en genoten!!  Je kunt ook gewoon blind gaan zoeken op een plek waar je niet moet zijn... Dat deden we dus... De hint niet helemaal letterlijk nemen dan gaat het beter.   TFTCs</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="932076697">           <groundspeak:date>2020-05-27T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="170844">wizard4u</groundspeak:finder>           <groundspeak:text encoded="False">27 mei 2020 Wizard4u dankt PeterBar voor (Ont)Spanning in Houten.  Dit is een algemene log. Vandaag zijn we weer eens op pad en in dit deel van Nederland. Onszelf even uitlaten in deze tijd en zo. Geen uitgebreide verhalen over het ontbijt of de koffiepauze van dit team en ook niet over de avonturen onderweg want meestal gebeurt er niet zo veel.  Dank voor het leggen, onderhouden en het ons leiden naar deze cache. Onze hobby krijgt meer invulling door deze cache. Thanks from wizard4u for the cache ☺✔</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="928960924">           <groundspeak:date>2020-05-21T19:00:00Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="9384439">$ Dagobert Duck $</groundspeak:finder>           <groundspeak:text encoded="False">Vorige week dit rondje al gelopen (natuurlijk ook de bekende fout gemaakt), maar we dachten dat we hem niet konden vinden. Na contact met Peter nu toch kunnen loggen. Bedankt Peter!</groundspeak:text>         </groundspeak:log>         <groundspeak:log id="928870018">           <groundspeak:date>2020-05-21T18:21:10Z</groundspeak:date>           <groundspeak:type>Found it</groundspeak:type>           <groundspeak:finder id="25725553">FamAlberts</groundspeak:finder>           <groundspeak:text encoded="False">Super leuke route! Zeker met kinderen! Na een tweede poging gevonden!!</groundspeak:text>         </groundspeak:log>       </groundspeak:logs>       <groundspeak:travelbugs />     </groundspeak:cache>   </wpt>   <wpt lat="52.019267" lon="5.195367">     <time>2019-03-02T06:02:27.607</time>     <name>01846PB</name>     <cmt>Ga naar: N 52° 01.156 E 005° 11.722 A = Het aantal horizontale metalen stangen om mee omhoog te klimmen.</cmt>     <desc>GC846PB WP1</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=8788e1a5-081b-4020-9b63-af1747ba8998</url>     <urlname>GC846PB WP1</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="52.019417" lon="5.195567">     <time>2019-03-02T06:32:04.84</time>     <name>PK846PB</name>     <cmt />     <desc>Virtueel punt</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=04c2c2f6-cddb-4ddf-bd75-bb17e2727754</url>     <urlname>Virtueel punt</urlname>     <sym>Parking Area</sym>     <type>Waypoint|Parking Area</type>   </wpt> </gpx>'
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
                text:  generic.showDialogHints ? strCalmontWalk : "" //strHouten : ""
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
