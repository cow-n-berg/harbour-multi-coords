import QtQuick 2.6
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF
import "../scripts/GpxFunctions.js" as GPX

Dialog {
    id: dialog

    property var    callback

    property var    coords
    property bool   showSearchLength : false
    property string strCalmontWalk   : '<?xml version="1.0" encoding="utf-8"?> <gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Groundspeak, Inc. All Rights Reserved. http://www.groundspeak.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd" xmlns="http://www.topografix.com/GPX/1/0">   <name>Cache Listing Generated from Geocaching.com</name>   <desc>This is an individual cache generated from Geocaching.com</desc>   <author>Account "Blinky Bill" From Geocaching.com</author>   <email>contact@geocaching.com</email>   <url>https://www.geocaching.com</url>   <urlname>Geocaching - High Tech Treasure Hunting</urlname>   <time>2020-08-30T14:33:54.7045749Z</time>   <keywords>cache, geocache</keywords>   <bounds minlat="50.101933" minlon="7.123883" maxlat="50.10715" maxlon="7.14015" />   <wpt lat="50.103433" lon="7.137333">     <time>2002-06-08T00:00:00</time>     <name>GC61DC</name>     <desc>Calmont Walk (Replacement) 𓇭 by Blinky Bill, Multi-cache (2/3.5)</desc>     <url>https://www.geocaching.com/seek/cache_details.aspx?guid=1587b22c-ba01-4f8a-acee-b5569838f911</url>     <urlname>Calmont Walk (Replacement) 𓇭</urlname>     <sym>Geocache</sym>     <type>Geocache|Multi-cache</type>     <groundspeak:cache id="25052" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">       <groundspeak:name>Calmont Walk (Replacement) 𓇭</groundspeak:name>       <groundspeak:placed_by>Blinky Bill</groundspeak:placed_by>       <groundspeak:owner id="23131">Blinky Bill</groundspeak:owner>       <groundspeak:type>Multi-cache</groundspeak:type>       <groundspeak:container>Regular</groundspeak:container>       <groundspeak:attributes>         <groundspeak:attribute id="32" inc="0">Bicycles</groundspeak:attribute>         <groundspeak:attribute id="24" inc="0">Wheelchair accessible</groundspeak:attribute>         <groundspeak:attribute id="1" inc="0">Dogs</groundspeak:attribute>         <groundspeak:attribute id="56" inc="1">Medium hike (1 km–10 km)</groundspeak:attribute>         <groundspeak:attribute id="13" inc="1">Available 24/7</groundspeak:attribute>         <groundspeak:attribute id="8" inc="1">Scenic view</groundspeak:attribute>         <groundspeak:attribute id="25" inc="1">Parking nearby</groundspeak:attribute>         <groundspeak:attribute id="21" inc="1">Cliff/falling rocks</groundspeak:attribute>       </groundspeak:attributes>       <groundspeak:difficulty>2</groundspeak:difficulty>       <groundspeak:terrain>3.5</groundspeak:terrain>       <groundspeak:country>Germany</groundspeak:country>       <groundspeak:state>Rheinland-Pfalz</groundspeak:state>       <groundspeak:short_description html="True">&lt;b&gt;Teilweise anstrengende und herausfordernde Wanderung durch den Calmont. Gute Trekking-Schuhe sind ein Muß.&lt;br /&gt; Dauer etwa 1/2 Tag oder mehr, je nach Fitness.&lt;br /&gt; "Ausrüstung:" keine Höhenangst, trainierte Wanderer, Trittsicherheit&lt;br /&gt; &lt;br /&gt;&lt;/b&gt; &lt;hr /&gt; &lt;h3&gt;&lt;b&gt;BTW, it is a question of politeness to log in a language the owner does understand, for example English, if you log caches in another country!!&lt;/b&gt;&lt;/h3&gt; &lt;br /&gt; &lt;hr /&gt; </groundspeak:short_description>       <groundspeak:long_description html="True">&lt;b&gt;1. Start und Ziel ist N50 06.206 E07 08.240. Der Pfad beginnt an der Bahnbrücke.&lt;br /&gt; Gehe zu N50 06.269 E07 08.360 und notiere die Länge des Petersbergtunnels = ABC&lt;br /&gt; &lt;br /&gt; 2. Weiter nach N50 06.317 E07 08.092 und die Anzahl der arbeitenden Menschen auf der Tafel feststellen = D&lt;br /&gt; &lt;br /&gt; 3. Nun zu N50 06.429 E07 07.433 und das Jahr der Auktion notieren = EFGH&lt;br /&gt; &lt;br /&gt; 4. Gehe zu N50 06.(A+C) (C) (D+C)   E07 06.(F) (D+G) (E+F)&lt;br /&gt; Notiere die Summe folgender Buchstaben (Inschrift im Sockel des Kreuzes): a &amp;amp; e. Setze die Anzahl für a = I und die Anzahl für e = J&lt;br /&gt; &lt;br /&gt; 5. Weiter gehts bei N50 06.(J+E) (G+A) (E+G)   E07 07.(J) (J-I) (F-D)&lt;br /&gt; Dort findet Ihr eine Tafel über ein Heiligtum. Welcher Nummer hat "Pommern" = K&lt;br /&gt; Sollten die Koordinaten zu ungenau sind, gebt bitte Bescheid - die Änderung dieser Station erfolgte aus der Ferne&lt;br /&gt; &lt;br /&gt; 6. Bei N50 06.(K-C) (K²/K) (G+I)   E07 08.(H) (G+E) (H)&lt;br /&gt; steht ein Gebäude. Wann wurde es errichtet? = LMNO&lt;br /&gt; &lt;br /&gt; 7. Bei N50 06.350 E07 08.140 notiere die eingravierten Ziffern auf dem Sockel = PQRSTU&lt;br /&gt; &lt;br /&gt; 8. Cache ist bei: N50 0(N-L),(U-Q) [(2*T)/(U+L)] (K-L)   E07 0(S+T-Q).[(3*S)/(Q+L)] (O-P+S) (U)&lt;br /&gt; &lt;br /&gt; Bitte wieder gut verstecken- Danke&lt;br /&gt; &lt;br /&gt;&lt;/b&gt; &lt;hr /&gt; &lt;br /&gt; &lt;br /&gt; English version:&lt;br /&gt; &lt;p&gt;Partly strenous and demanding hike thru the Calmont. A sturdy pair of trekking shoes are a must.&lt;br /&gt; calculate half a day or more depending on your level of fitness&lt;br /&gt; Personal requirements: freedom of vertigo essential, trained hikers, sure-footedness&lt;br /&gt; Cache: tupper box&lt;br /&gt; &lt;br /&gt; 1. Start &amp;amp; end at N50 06.206 E07 08.240. Enter the track at the railway bridge.&lt;br /&gt; Go to N50 06.269 E07 08.360 and note the length (Länge) of the "Petersbergtunnel". Assign the&lt;br /&gt; numbers to the letters ABC (e.g. 698m: A=6 B=9 C=8).&lt;br /&gt; &lt;br /&gt; 2. Goto N50 06.317 E07 08.092 and count the working people on the plate = D&lt;br /&gt; &lt;br /&gt; 3. Continue to N50 06.429 E07 07.433 and note the year of the auction (Versteigerung) and assign it to EFGH.&lt;br /&gt; &lt;br /&gt; 4. Goto N50 06.(A+C) (C) (D+C)   E07 06.(F) (D+G) (E+F)&lt;br /&gt; Check the inscription at the base of the cross, note the sum of the following letters: a &amp;amp; e and&lt;br /&gt; assign a to I and e to J.&lt;br /&gt; &lt;br /&gt; 5. Move on to N50 06.(J+E) (G+A) (E+G) E07 07.(J) (J-I) (F-D)&lt;br /&gt; There youll find information about a sanctuary (Heiligtum). Which number is assigned to "Pommern" = K&lt;br /&gt; If coordinates are too inaccurate please give feedback. Changes have been made from afar.&lt;br /&gt; &lt;br /&gt; 6. Continue to N50 06.(K-C) (K²/K) (G+I)   E07 08.(H) (G+E) (H)&lt;br /&gt; In which year the building was constructed? Assign the numbers to LMNO.&lt;br /&gt; &lt;br /&gt; 7. Goto N50 06.350 E07 08.140, note the cyphers engraved on the basis and assign the numbers to PQRSTU.&lt;br /&gt; &lt;br /&gt; 8. Cache is at:&lt;br /&gt; N50 0(N-L),(U-Q) [(2*T)/(U+L)] (K-L)   E07 0(S+T-Q).[(3*S)/(Q+L)] (O-P+S) (U)&lt;br /&gt; &lt;br /&gt; Please hide cache as you found it - thank you!!&lt;br /&gt; Good luck&lt;/p&gt; &lt;br /&gt; &lt;hr /&gt; &lt;br /&gt; Information: &lt;a rel="nofollow" href="http://www.calmont-mosel.de/"&gt;&lt;font size="4"&gt;Calmont&lt;/font&gt;&lt;/a&gt;&lt;br /&gt; &lt;br /&gt; &lt;br /&gt; &lt;table border="0" cellpadding="5" cellspacing="25"&gt; &lt;tr&gt; &lt;td&gt;&lt;img src="http://www.koala-support.de/geocaching/bc-no-thanks.jpg" /&gt;&lt;/td&gt; &lt;td&gt;&lt;img src="http://www.koala-support.de/geocaching/trade.jpg" /&gt;&lt;/td&gt; &lt;/tr&gt; &lt;/table&gt; &lt;br /&gt; &lt;br /&gt; Updates:&lt;br /&gt; 29-05-2013: Station 5 geändert. Stage 5 changed.&lt;br /&gt; 26-06-2018: Das sich am Final mittlerweile eine Art "WC" befindet ist bedauerlich. Als der Cache hier versteckt wurde, gab es keinen Pfad o. ä. Erst nachdem der Cacherpfad entstanden ist, kamen Wanderer wohl auf die Idee, sich hier "niederzulassen". Wir können das Versteck aber nicht ständig deswegen ändern. Sollte es zu schlimm werden, lassen wir uns etwas einfallen. &lt;p&gt;Additional Hidden Waypoints&lt;/p&gt;0161DC - CAL-1&lt;br /&gt;N 50° 06.269 E 007° 08.360&lt;br /&gt;&lt;br /&gt;0261DC - CAL-2&lt;br /&gt;N 50° 06.317 E 007° 08.092&lt;br /&gt;&lt;br /&gt;0361DC - CAL-3&lt;br /&gt;N 50° 06.429 E 007° 07.433&lt;br /&gt;&lt;br /&gt;0461DC - CAL-4&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0561DC - CAL-5&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0661DC - CAL-6&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;0761DC - CAL-7&lt;br /&gt;N 50° 06.350 E 007° 08.140&lt;br /&gt;&lt;br /&gt;PK61DC - GC61DC Parking / Parkplatz neu 2016&lt;br /&gt;N 50° 06.116 E 007° 08.409&lt;br /&gt;&lt;br /&gt;</groundspeak:long_description>       <groundspeak:encoded_hints>unter Steinen / under stones</groundspeak:encoded_hints>       <groundspeak:travelbugs>         <groundspeak:travelbug id="6483756" ref="TB7EDNB">           <groundspeak:name>Schluesselsche</groundspeak:name>         </groundspeak:travelbug>         <groundspeak:travelbug id="6897139" ref="TB7X9V9">           <groundspeak:name>Travel Eagle</groundspeak:name>         </groundspeak:travelbug>         <groundspeak:travelbug id="8108577" ref="TB96ZDY">           <groundspeak:name>Frost in MV 10 gehmalwech</groundspeak:name>         </groundspeak:travelbug>       </groundspeak:travelbugs>     </groundspeak:cache>   </wpt>   <wpt lat="50.104483" lon="7.139333">     <time>2007-09-18T05:50:57.337</time>     <name>0161DC</name>     <cmt />     <desc>CAL-1</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=56af0c18-193c-40b1-80c5-19bb20c42ab2</url>     <urlname>CAL-1</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.105283" lon="7.134867">     <time>2007-09-18T05:51:30.463</time>     <name>0261DC</name>     <cmt />     <desc>CAL-2</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=cb30fd21-1713-4c9f-8bdb-a95e950d7deb</url>     <urlname>CAL-2</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.10715" lon="7.123883">     <time>2007-09-18T05:52:05.773</time>     <name>0361DC</name>     <cmt />     <desc>CAL-3</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=9666a87e-9220-41f8-8dbc-5c6a5cacf566</url>     <urlname>CAL-3</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.105833" lon="7.135667">     <time>2007-09-18T05:54:47.76</time>     <name>0761DC</name>     <cmt />     <desc>CAL-7</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=07671b19-5790-4a2d-b6eb-7f84e89291ba</url>     <urlname>CAL-7</urlname>     <sym>Virtual Stage</sym>     <type>Waypoint|Virtual Stage</type>   </wpt>   <wpt lat="50.101933" lon="7.14015">     <time>2016-05-28T09:26:29.42</time>     <name>PK61DC</name>     <cmt />     <desc>GC61DC Parking / Parkplatz neu 2016</desc>     <url>https://www.geocaching.com/seek/wpt.aspx?WID=f4c9f622-7f17-4e18-b6a4-f5be12b1de90</url>     <urlname>GC61DC Parking / Parkplatz neu 2016</urlname>     <sym>Parking Area</sym>     <type>Waypoint|Parking Area</type>   </wpt> </gpx>'
    property string strTestCache     : '<?xml version="1.0" encoding="utf-8"?><gpx xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0" creator="Groundspeak, Inc. All Rights Reserved. http://www.groundspeak.com" xsi:schemaLocation="http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd http://www.groundspeak.com/cache/1/0/1 http://www.groundspeak.com/cache/1/0/1/cache.xsd" xmlns="http://www.topografix.com/GPX/1/0">  <name>Cache Listing Generated from Geocaching.com</name>  <desc>This is an individual cache generated from Geocaching.com</desc>  <author>Account "GenHenk" From Geocaching.com</author>  <email>contact@geocaching.com</email>  <url>https://www.geocaching.com</url>  <urlname>Geocaching - High Tech Treasure Hunting</urlname>  <time>2021-03-07T11:06:20.6585859Z</time>  <keywords>cache, geocache</keywords>  <bounds minlat="52.25205" minlon="5.17715" maxlat="52.25205" maxlon="5.17715" />  <wpt lat="52.25205" lon="5.17715">    <time>2013-11-12T00:00:00</time>    <name>GC4RZTJ</name>    <desc>Kijk, een :-) op de hei by te paard en te voet, Multi-cache (1.5/1.5)</desc>    <url>https://www.geocaching.com/seek/cache_details.aspx?guid=bcbc8ccd-497e-452c-9c6b-b05369fb06bc</url>    <urlname>Kijk, een :-) op de hei</urlname>    <sym>Geocache</sym>    <type>Geocache|Multi-cache</type>    <groundspeak:cache id="4027571" available="True" archived="False" xmlns:groundspeak="http://www.groundspeak.com/cache/1/0/1">      <groundspeak:name>Kijk, een :-) op de hei</groundspeak:name>      <groundspeak:placed_by>te paard en te voet</groundspeak:placed_by>      <groundspeak:owner id="2383191">GenHenk</groundspeak:owner>      <groundspeak:type>Multi-cache</groundspeak:type>      <groundspeak:container>Micro</groundspeak:container>      <groundspeak:attributes>        <groundspeak:attribute id="1" inc="0">Dogs</groundspeak:attribute>        <groundspeak:attribute id="13" inc="0">Available 24/7</groundspeak:attribute>        <groundspeak:attribute id="7" inc="1">Takes less than one hour</groundspeak:attribute>        <groundspeak:attribute id="43" inc="1">Livestock nearby</groundspeak:attribute>      </groundspeak:attributes>      <groundspeak:difficulty>1.5</groundspeak:difficulty>      <groundspeak:terrain>1.5</groundspeak:terrain>      <groundspeak:country>Netherlands</groundspeak:country>      <groundspeak:state>Noord-Holland</groundspeak:state>      <groundspeak:short_description html="True">Eén van de multi`s van de ;-)-serie op de Bussumer- en Westerheide.&lt;br /&gt;Loop aub niet door het rustgebied maar respecteer de natuur en loop er netjes omheen!!!</groundspeak:short_description>      <groundspeak:long_description html="True">&lt;img src="http://imgcdn.geocaching.com/cache/large/efdbfeb5-93b7-4e71-8ee8-aa5ea6f712e4.jpeg" width="800" /&gt; De Bussumerheide is een heidegebied van 160 ha in Het Gooi.&lt;br /&gt;Het ligt ten zuiden van Bussum, en grotendeels op het grondgebied van gemeente Hilversum.&lt;br /&gt;De Westerheide is een heidegebied van 344 ha op het grondgebied van Hilversum en Laren.&lt;br /&gt;Het gebied grenst aan de Bussumerheide, de A1, de bebouwde kom van Hilversum en de spoorlijn Amsterdam-Amersfoort.&lt;br /&gt;&lt;br /&gt;WP 1: N 52 15.123 - E 005 10.629&lt;br /&gt;Je ziet hier 1 door de mens aangebracht `ding`&lt;br /&gt;Is dit een&lt;br /&gt;Bankje, A = 7&lt;br /&gt;Toren, A = 2&lt;br /&gt;Wegwijzer, A = 6&lt;br /&gt;&lt;br /&gt;B = Het bovenstaande object staat op ???° t.o.v. WP 1&lt;br /&gt;50°: B = 3&lt;br /&gt;125°: B = 8&lt;br /&gt;200°: B = 5&lt;br /&gt;275°: B = 1&lt;br /&gt;&lt;br /&gt;WP 2: N 52 15.A10 - E 005 10.B6B&lt;br /&gt;C = stapeltel het rode getal tot 1 cijfer&lt;br /&gt;&lt;br /&gt;Hier stond ooit een paaltje met een 2 kleurige route-aanduiding. Wat waren de kleuren van deze route-aanduiding?&lt;br /&gt;Gelijk aan de club-kleuren van de grootste voetbalclub van Nederland: D = 7&lt;br /&gt;De kleuren van de Nederlandse vlag: D = 1&lt;br /&gt;Hoe moeten wij dat weten?: D = 9&lt;br /&gt;&lt;br /&gt;WP 3: N 52 15.A0D - E 005 10.BAC&lt;br /&gt;E =&lt;br /&gt;Zoek in de plaatsnamen welke letters van het alfabet niet worden genoemd&lt;br /&gt;Zet deze ontbrekende letters om in letterwaarde (A = 1, B = 2, etc.)&lt;br /&gt;Trek van de som van de letterwaardes 98 af.&lt;br /&gt;De uitkomst = E.&lt;br /&gt;F = afstand tot de Natuurbrug in hectometers&lt;br /&gt;G = aantal bankjes min 1, zichtbaar vanaf dit kruispunt&lt;br /&gt;H = afstand Lage Vuursche / ( afstand s-Graveland + afstand Spanderswoud - afstand Natuurbrug)&lt;br /&gt;&lt;br /&gt;WP 4: N 52 15.FHH - E 005 10.GGH&lt;br /&gt;I = stapeltel het aantal bouten draaiende deel van het hek tot 1 cijfer en trek hier 4x F van af&lt;br /&gt;&lt;br /&gt;De cache is te vinden op:&lt;br /&gt;N 52 15.IH(B+C) - E 005 10.GG(D-F)&lt;br /&gt;&lt;br /&gt;Om de cache te bereiken hoef je NIET over een hek te klimmen!!!&lt;br /&gt;&lt;br /&gt;Speciale dank aan Goois Natuur Reservaat voor de medewerking van deze serie.&lt;br /&gt;Ook deze cache is een samenwerking tussen &lt;a href="http://www.geocaching.com/profile/?guid=79690d3e-fc1c-4bd4-8d38-ce4ad907e25b"&gt;Te Voet&lt;/a&gt; en &lt;a href="http://www.geocaching.com/profile/?guid=d14d605c-743c-4ea7-87de-b27853bd9e06&amp;amp;wid=017fc7a0-d42b-402b-992a-368af50585e5&amp;amp;ds=2"&gt;Te Paard&lt;/a&gt;&lt;br /&gt;&lt;br /&gt;Zoek en vind alle caches van Te Voet en Te Paard&lt;br /&gt;&lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=dd672988-4517-4bb5-bce8-99cc697744c9"&gt;Zonnestraal (GC2HW4P)&lt;/a&gt; (Gearchiveerd per 17 januari 2015)&lt;br /&gt;&lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=017fc7a0-d42b-402b-992a-368af50585e5"&gt;De Lieberg (GC2VFCW)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?wp=GC2HTJD"&gt;Wolven golfen in het Smitshuyserbosch (GC2HTJD)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=e54f9bc3-1db7-4e88-9027-cfda6d87fef8"&gt;Hilversum by night (GC3W065)&lt;br /&gt;&lt;br /&gt;&lt;/a&gt; De ‘Gamma tot Gamma-Race’, bestaande uit:&lt;br /&gt;&lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=ee7ef9d1-92af-4298-af7f-65542849717c"&gt;`Gamma to Gamma-race` 1 (Bantam) (GC44BEE)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=b06a9469-9c8e-45a5-9acc-3c07e53cc427"&gt;`Gamma to Gamma-race` 2 (Schaep &amp;amp; Burgh) (GC47WCX)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=90da34c0-3f71-463e-b73c-b1b354a3adf8"&gt;`Gamma to Gamma-race` 3 (Boekesteyn) (GC47WEH)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=2a5e9280-f6f3-488a-b74e-28ea3aceee38"&gt;`Gamma to Gamma-race` 4 (Spanderswoud) (GC474P7 )&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=c5d88362-3f59-48f7-8a6e-fb1d7301107b"&gt;`Gamma to Gamma-race` 5 (Hilverbeek) (GC472ZT)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=e50a7485-f338-4824-b7f9-ee2403180dc9"&gt;`Gamma to Gamma-race` 6 (Schoonoord/Land&amp;amp;Boszicht) (GC47WFG)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=4ef594b6-53e1-460f-867b-2bb3b1fd63f5"&gt;`Gamma to Gamma-race` 7 (Jagtlust) (GC45BR3)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=f85f2bb8-6abc-4205-9572-f43555287c47"&gt;`Gamma to Gamma-race` 8 (Gooilust) (GC4730K)&lt;br /&gt;&lt;/a&gt; &lt;a href="http://www.geocaching.com/seek/cache_details.aspx?guid=4d2a49d0-c5a7-4d74-9a2d-79535883c3fd"&gt;`Gamma to Gamma-race` BONUSCACHE (GC47WG6)&lt;br /&gt;&lt;br /&gt;&lt;/a&gt; En de serie `&lt;img src="http://img.smileys.nl/1/smile.png" alt="smile" /&gt; op de hei`.&lt;br /&gt;Een mix van 13 traditionals, multi`s en mysteries op de Bussummer- en Westerheide.&lt;br /&gt;&lt;a href="http://www.geocaching.com/geocache/GC4RZQA_op-de-hei"&gt;GC4RZQA,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZQY_nog-een-op-de-hei"&gt;GC4RZQY,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZT2_verhip-een-op-de-hei"&gt;GC4RZT2,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZT7_alweer-een-op-de-hei"&gt;GC4RZT7,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZTJ_kijk-een-op-de-heii"&gt;GC4RZTJ,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZTT_de-zoveelste-op-de-hei"&gt;GC4RZTT,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZTX_hier-een-op-de-hei"&gt;GC4RZTX,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZV4_daar-een-op-de-hei"&gt;GC4RZV4,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZV7_leuk-een-op-de-hei"&gt;GC4RZV7,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZVC_vind-de-op-de-hei"&gt;GC4RZVC,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZVG_geinig-een-op-de-hei"&gt;GC4RZVG,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZVK_spannend-een-op-de-hei"&gt;GC4RZVK,&lt;/a&gt; &lt;a href="http://www.geocaching.com/geocache/GC4RZVT_he-een-op-de-hei"&gt;GC4RZVT&lt;/a&gt;.&lt;p&gt;Additional Hidden Waypoints&lt;/p&gt;E14RZTJ - GC4RZTJ Stage 1&lt;br /&gt;N 52° 15.123 E 005° 10.629&lt;br /&gt;&lt;br /&gt;E24RZTJ - GC4RZTJ Stage 2&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;E34RZTJ - GC4RZTJ Stage 3&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;E44RZTJ - GC4RZTJ Stage 4&lt;br /&gt;N/S  __ ° __ . ___ W/E ___ ° __ . ___ &lt;br /&gt;&lt;br /&gt;</groundspeak:long_description>      <groundspeak:encoded_hints>      </groundspeak:encoded_hints>      <groundspeak:logs>        <groundspeak:log id="996318035">          <groundspeak:date>2021-02-27T20:00:00Z</groundspeak:date>          <groundspeak:type>Write note</groundspeak:type>          <groundspeak:finder id="2383191">GenHenk</groundspeak:finder>          <groundspeak:text encoded="False">Onderhoudsrondje gemaakt</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="996044996">          <groundspeak:date>2021-02-24T20:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="2387839">anharu</groundspeak:finder>          <groundspeak:text encoded="False">Vandaag hebben we zin in een lange rustige wandeling door een mooi gebied en hiermee kwamen we hier volledig aan onze wensen. We hadden besloten om te proberen al de aanwezige caches te combineren in 1 wandeling wat dankzij een meervoudige administratie tot ons genoegen onverwacht soepel ging. Ook deze konden we met wat extra lopen tot een goed einde brengen en na even kijken zagen we iets en konden we ook hier onze krabbel zetten. Bedankt voor deze cache en het laten zien van deze prachtige omgeving .</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="995661742">          <groundspeak:date>2021-02-23T19:31:24Z</groundspeak:date>          <groundspeak:type>Write note</groundspeak:type>          <groundspeak:finder id="2383191">GenHenk</groundspeak:finder>          <groundspeak:text encoded="False">Kijk, een :-) op de hei was transferred from te paard to user GenHenk</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="991695375">          <groundspeak:date>2021-01-30T20:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="642097">aloys-kylian</groundspeak:finder>          <groundspeak:text encoded="False">16-2-2014  deze ook gedaan, maar toen niet gevonden. Nu gelukkig in de herkansing en wel gelukt.    Bedankt </groundspeak:text>        </groundspeak:log>        <groundspeak:log id="991081191">          <groundspeak:date>2021-01-24T20:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="5190154">Siebje_2013</groundspeak:finder>          <groundspeak:text encoded="False">Vandaag met kleine Mup een rondje wezen fietsen. Eerst in het Spanderswoud een aantal vragen voor de 2Kamp beantwoord en daarna door naar deze pick-up. Ik had de vragen al eerder beantwoord, behalve het laatste getal. Ik was toen met blonde Mup en die mag niet op de locatie van de vraag komen.  Ik kwam alleen niet op een getal waar ik 4 vanaf kon trekken. Ik stond dus met m`n telefoon te hannesen terwijl Kleine Mup lekker aan het spelen was. Er was toen al een man aan komen fietsen die zijn kat aan het uitlaten was. Na wat gepraat liep hij even weg, maar kwam daarna terug. Het bleek dat hij hier vaak komt en hij kon me de cache aanwijzen. Dus toch `gevonden`.    </groundspeak:text>        </groundspeak:log>        <groundspeak:log id="991615716">          <groundspeak:date>2021-01-20T20:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="14481312">pedro allessandro</groundspeak:finder>          <groundspeak:text encoded="False"># # 1.628#Vandaag was het heerlijk wandelweer en we waren niet de enige die dit vonden....Dus op naar Bussum en we pakken deze multi aan om wat invulling te geven aan de wandeling.Alle punten gingen als de spreekwoordelijke speer alleen bij het eindcoord was er toch twijfel.Ik had niet direct door waar te zoeken.Dus eerst maar even doorgewandeld om vervolgens op de weg terug nog maar een poging te doen en toen was het gelukkig wel raak.Er is niets frustrerender dan een multi te lopen en de cache vervolgens niet kunnen vinden...----------👍 Pedro A. 👍 TFTC 👍 20 januari 2021 12:02</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="960992429">          <groundspeak:date>2020-08-30T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="746659">Becurious</groundspeak:finder>          <groundspeak:text encoded="False">Nu is het de tijd van het jaar om op de heide rond te lopen en daarvoor hoef ik gelukkig niet helemaal naar de Veluwe toe, is daar file rijden en lopen de laatste tijd. Best wel pittig en goed opletten, lezen. Gelukkig kan je tegenwoordig met je telefoon foto’s maken dus snel terugkijken lezen is wel wat makkelijker.  Genoten, afstand gehouden en in rustgebied nog een ree gespot in de verte. Al ket al geslaagde zondag. Tftc</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="959561489">          <groundspeak:date>2020-08-30T19:51:49Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="7205591">Cache-tigers</groundspeak:finder>          <groundspeak:text encoded="False">Zoo.....dat was me het zoektochtje wel!!! Voor de tweede keer hierheen en na weer een tijd zoeken en een goed gesprek met, jawel....de kattenfluisteraar zomaar ineens toch de cache gespot. Superblij!!!! En de kattenfluisteraar....his lips are sealed!</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="936448853">          <groundspeak:date>2020-06-12T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="14545349">Ma,Fi&amp;Me</groundspeak:finder>          <groundspeak:text encoded="False">Kijk, een multi op de hei. Ik was hier 29 februari al mee gestart maar ben na WP1 gestopt.  Nu weer verder... wat een tijdrovende multi met al die vragen vooral bij WP3 (die ik eerst voor WP2 aanzag). En ook bijzonder dat je van de hei af moet voor deze :-) op de hei. Wat dan wel weer leuk is, is dat ik voor het eerst over een natuurbrug heb gelopen. Je merkt er eigenlijk niks van als je het niet weet, tenzij er net een trein voorbij komt, zoals bij mij. Na veel rekenen op alle WP`s wordt de cache gevonden. Bedankt voor de cache, te voet en te paard.</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="932445206">          <groundspeak:date>2020-05-31T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="7463513">ErwinKarin</groundspeak:finder>          <groundspeak:text encoded="False">Vandaag gaan we wederom vroeg op pad en nu naar Bussum om daar te gaan cachen dit was voornamelijk op de hei en in de omgeving. We hebben wederom lekker gewandeld. We hadden ons huiswerk goed gedaan en hebben kris en kras over de hei gelopen. Het werd een variatie van puzzel caches, multi`s, tradi`s en zelfs een letterbox. We hebben heerlijk genoten van de mooie natuur en verzorgde caches. We hebben net als gisteren een ree gespot, een specht en andere verschillende vogels. Het was een super lekkere lange geocaching dag en we hebben alle caches die we hebben gedaan gevonden. Soms was het wel flink zoeken omdat het nulpunt ergens anders was. Bij deze bedanken we alle CO`s voor het mogelijk maken van deze geocachingdag.  We hebben op het eindcoordinaat flink lopen zoeken. Hadden we wel de juiste aantal bouten wel goed geteld. Nogmaals tellen en Erwin was zeker. Even een hulplijn zoeken, maar toen spotte Erwin de cache en konden we verder.</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="931706916">          <groundspeak:date>2020-05-30T18:35:50Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="30282403">Lucina1911</groundspeak:finder>          <groundspeak:text encoded="False">Dekuji za kes</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="929336956">          <groundspeak:date>2020-05-22T20:40:21Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="3740373">finefleur1</groundspeak:finder>          <groundspeak:text encoded="False">Vandaag met enkele vrienden en mijn zoon een rondje over de hei om enkele smileys te zoeken. Niet overal succes maar deze werd gevonden na een tijdje zoeken... 😅. Bedankt!</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="928557091">          <groundspeak:date>2020-05-20T02:46:37Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="23945934">TeamGeBakjes</groundspeak:finder>          <groundspeak:text encoded="False">Lekker blokje fietsen vanavond. De gegevens voor deze cache heb ik een paar weken geleden al verzameld (op het laatste WP na) en thuis mee gepuzzeld. Handig als je de omgeving kent, want dan krijg je bij de mogelijke eindpunten wel een idee welke de juist is.  Deze nu snel gevonden. Lang bezig met mijn smiley: het laatste puzzelstukje  staat ook op de kaart, maar bewaar ik weer voor een volgende wandeling...  Op de natuurbrug een reebok en twee reegeiten. Blijft leuk om te zien!</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="926892141">          <groundspeak:date>2020-05-14T04:36:01Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="26209205">ICE83</groundspeak:finder>          <groundspeak:text encoded="False">Yes! Na een eerder mislukte poging nu meer succes :) Dank voor deze!</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="926863254">          <groundspeak:date>2020-05-13T18:10:38Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="22446243">jessicaw88</groundspeak:finder>          <groundspeak:text encoded="False">Pff gelukkig is het rustig, de bezoekers waren vele slakken die de regen trotseerde.</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="923271718">          <groundspeak:date>2020-04-28T19:46:06Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="1927287">rukakids</groundspeak:finder>          <groundspeak:text encoded="False">Hele leuke speurtocht en wandeling naar deze cache :)</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="922864441">          <groundspeak:date>2020-04-26T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="8484517">JR_photograpper</groundspeak:finder>          <groundspeak:text encoded="False">Wat een leuke speurtocht!</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="918289642">          <groundspeak:date>2020-04-04T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="12309805">SimSanneBim</groundspeak:finder>          <groundspeak:text encoded="False">Voor vandaag zat er al één smiley in deze smiley, maar Quenn Tadleight en ik wilden toch alle multi`s, tradi`s en mysteries tot heel veel gele smileys omtoveren. Dus aan het puzzelen geslagen, en toen alle punten bekend waren gingen we op deze mooie zaterdagmiddag op pad. Aan het einde van deze dag rode neuzen van het toch wel erg felle zonnetje... We hebben onszelf aan het einde van de dag verwend met een patatje :)Deze multi was de eerste van vandaag. Helemaal uit de richting bleek uiteindelijk, maar wel een mooie plek. Op de eindlocatie hadden we eerder slechte ervaringen met een andere cache helaas, dus deze plek kenden we al van voren naar achteren. Toch nog een tijdje moeten zoeken, voorzichtig, want er waren behoorlijk wat andere mensen in de buurt. Bijna opgegeven, maar toch gevonden. Bedankt!</groundspeak:text>        </groundspeak:log>        <groundspeak:log id="917662835">          <groundspeak:date>2020-04-04T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="5547261">Quenn Tadleight</groundspeak:finder>          <groundspeak:text encoded="False">Vandaag was het zover. We wilde een mooie grote gele :) op de kaart tevoorschijn toveren. We hadden er eens één van de serie gedaan, daarna de rest gepuzzeld en vandaag hebben we alles gezocht. We hebben de fietsen aan de rand van de heide gezet en zijn lekker gaan wandelen. Het was een mooie dag.  We begonnen met deze multi. Voor ons gevoeg ging deze helemaal de verkeerde kant op, want we hadden de hoop onderweg de andere caches te vinden. De vragen waren soms wat ingewikkeld en op het nulpunt was het behoorlijk zoeken. Dit was een beetje ongemakkelijk omdat de bankjes vol zaten met mensen. Maar uiteindelijk hebben we deze kunnen vinden. </groundspeak:text>        </groundspeak:log>        <groundspeak:log id="962328695">          <groundspeak:date>2020-04-02T19:00:00Z</groundspeak:date>          <groundspeak:type>Found it</groundspeak:type>          <groundspeak:finder id="8781550">TeamGeoCaan</groundspeak:finder>          <groundspeak:text encoded="False">Bij het grondig opruimen van de GPS komen er nog wat niet-geplaatste logjes tevoorschijn. Excuses voor de late log. Vandaag eindelijk maar eens deze multi opgelost. Hier al meermalen mee bezig geweest als we in de buurt waren, maar telkens een hik opgelopen of het was toch te ver uit de buurt. Vandaag opgepakt en afgemaakt. Uiteindelijk is `ie niet zo moeilijk en wordt de cache goed gevonden. Mooie plek. Te Paard en Te Voet, dank voor deze cache!</groundspeak:text>        </groundspeak:log>      </groundspeak:logs>      <groundspeak:travelbugs />    </groundspeak:cache>  </wpt>  <wpt lat="52.25205" lon="5.17715">    <time>2013-11-12T13:05:40.907</time>    <name>E14RZTJ</name>    <cmt />    <desc>GC4RZTJ Stage 1</desc>    <url>https://www.geocaching.com/seek/wpt.aspx?WID=43d35786-4ecb-4708-a46f-969412ebdd94</url>    <urlname>GC4RZTJ Stage 1</urlname>    <sym>Virtual Stage</sym>    <type>Waypoint|Virtual Stage</type>  </wpt></gpx>'

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

            SectionHeader {
                text: qsTr("Raw text")
                color: generic.highlightColor
            }

            // Hier een button met file picker

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
//                text:  strTestCache
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
