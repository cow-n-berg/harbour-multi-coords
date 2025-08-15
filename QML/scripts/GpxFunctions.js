function gpxDecode(rawText) {

    var regExNewlin = /\r?\n|\r/g;                             // to remove newlines
    var regExTabs   = /\t/g;                                   // to remove tabs
    var regExSpaces = /\s\s/g;                                 // to remove double spaces

    var regExWpt    = /<wpt\s?[^>]+>(.+?)<\/wpt>/;
    var regExLatLon = /<wpt\slat="([^"]*)"\slon="([^"]*)">/;
    var regExAttrs  = /<groundspeak:attributes>(.+?)<\/groundspeak:attributes>/;
    var regExLogs   = /<groundspeak:logs>(.+?)<\/groundspeak:logs>/;
    var regExWaypts = /Additional Hidden Waypoints(.+?)<\/groundspeak:long_description>/;
    var regExDescr  = /<groundspeak:long_description\s?[^>]+>(.+?)<\/groundspeak:long_description>/;
    var regExDescr1 = /<groundspeak:long_description\s?[^>]+>(.+?)Additional Hidden Waypoints/;

    var regExHideDt = /<time>(.+?)<\/time>/;
    var regExGcCode = /<name>(.+?)<\/name>/;
    var regExName   = /<groundspeak:name>(.+?)<\/groundspeak:name>/;
    var regExOwner  = /<groundspeak:placed_by>(.+?)<\/groundspeak:placed_by>/;
    var regExType   = /<groundspeak:type>(.+?)<\/groundspeak:type>/;
    var regExCont   = /<groundspeak:container>(.+?)<\/groundspeak:container>/;
    var regExDiff   = /<groundspeak:difficulty>(.+?)<\/groundspeak:difficulty>/;
    var regExTerr   = /<groundspeak:terrain>(.+?)<\/groundspeak:terrain>/;
    var regExHints  = /<groundspeak:encoded_hints>(.+?)<\/groundspeak:encoded_hints>/;
    var regExAttr   = /<groundspeak:attribute\s.+?inc="([01])">(.+?)<\/groundspeak:attribute>/g;
    var regExLog    = /<groundspeak:log\s[^>]+>(.+?)<\/groundspeak:log>/g;
    var regExCacher = /<groundspeak:finder\s[^>]+>(.+?)<\/groundspeak:finder>/;
    var regExDate   = /<groundspeak:date>(.+?)<\/groundspeak:date>/;
    var regExText   = /<groundspeak:text\s[^>]+>(.+?)<\/groundspeak:text>/;
    var regExDtTm   = /([0-9]{4}-[0-9]{2}-[0-9]{2})/;
    var regExWpNr   = /([0-9]+)/;
    var regExPark   = /Parking/;

    var regExHidCmt = /([A-Z0-9]{2})[A-Z0-9]{2,6}\s-\s(.*?)<br\s\/>(.*?)<br\s\/>(.*?)<br\s\/>/g;

    // Coordinates and formulas in plain text
    var regExEmpty  = /N\/S[^_]+?__[^_]+?__[^_]+?___\sW\/E[^_]+?___[^_]+?__[^_]+?___/g;
    var regExCoords = /([NS]\s?[0-9]{1,2}°?\s?[0-9]{1,2}\.[0-9]{1,3}.+?[EW]\s?[0-9]{1,3}°?\s?[0-9]{1,2}\.[0-9]{1,3})/g;
    var regExCrdFrm = /([NS]\s?[0-9A-Za-z\[\]()*\-+=]+?.\s?[0-9A-Za-z\[\]()*\-+=]+?\.[0-9A-Za-z\[\]()*\-+=]+?.+?[EW]\s?[0-9A-Za-z\[\]()*\-+=]+?.\s?[0-9A-Za-z\[\]()*\-+=]+?\.[0-9A-Za-z\[\]()*\-+=]+).+?$/g;
    var regExPosFrm = /[\[\]()*\-+=]/;
    var searchLength = 40;
    var regExString = "([NS][^#]{5," + searchLength + "}\\s[EW][^#&,']{5," + searchLength + "})"
    var regExFormul = new RegExp(regExString, "g");
    // Should be like /([NS][^#]{5,40}\s[EW][^#&,']{5,40})/g

    var result      = {};
    var description = [];
    var waypoints   = [];
    var parser, xmlDoc, wpt, attr, logs, desc, wpts, fcts;
    var list, listWp, listDesc, val, rec, txt, dat, nr, tmp;
    var wpCmt, wpDesc, wpSym, wpNr, wpCoord, wpFormula, wpType;
    var mainCoord, tmplCoord, lat, lon;
    var i, j, wpFound, maxNrWp;

    // Clean up first, JS cannot handle newlines
    rawText = rawText.replace(regExNewlin, " ");
    rawText = rawText.replace(regExTabs, " ");
    rawText = rawText.replace(regExSpaces, " ");
    rawText = rawText.replace(regExSpaces, " ");
    rawText = rawText.replace(regExSpaces, " ");
    rawText = rawText.replace(/&amp;/g, "&");
    rawText = rawText.replace(/&quot;/g, "'");
    rawText = rawText.replace(/&#(\d+);/g, function(match, dec) {
                    return String.fromCharCode(dec);
                })

    // Large chunks
    wpt  = simpleRegEx(rawText, regExWpt).trim();
    attr = simpleRegEx(wpt, regExAttrs);
    logs = simpleRegEx(wpt, regExLogs);
    wpts = simpleRegEx(wpt, regExWaypts);
    if (wpts)
        desc = simpleRegEx(wpt, regExDescr1);
    else
        desc = simpleRegEx(wpt, regExDescr);

    // Main Coordinate
    val = regExLatLon.exec(rawText);
    if (val !== null) {
        lat = val[1];
        lon = val[2];
        mainCoord = coordFromLatLon(lat, lon);
        tmplCoord = coordTmplLatLon(lat, lon)
    }
    else
        mainCoord = "Unknown";

    // Single elements
    fcts = {};
    fcts.hidden    = simpleRegEx(wpt, regExHideDt).substring(0, 10);
    fcts.name      = simpleRegEx(wpt, regExName).trim();
    fcts.code      = simpleRegEx(wpt, regExGcCode);
    fcts.owner     = simpleRegEx(wpt, regExOwner);
    fcts.type      = simpleRegEx(wpt, regExType);
    fcts.container = simpleRegEx(wpt, regExCont);
    fcts.difficult = simpleRegEx(wpt, regExDiff);
    fcts.terrain   = simpleRegEx(wpt, regExTerr);
    fcts.hints     = simpleRegEx(wpt, regExHints).trim();

    result.facts = fcts;

    // Attributes
    attr = attr.replace(/&gt;/g, ">");
    attr = attr.replace(/&lt;/g, "<");

    txt = "";
    nr = -1;
    do {
        val = regExAttr.exec(attr);
        if (val !== null && val[2].trim() !== "") {
            nr++;
            if (nr > 0)
                txt += "\n";
            txt += (val[1] === "1" ? "YES: " : "NO : ") + val[2];
        }
   } while (val !== null)
    result.attributes = txt;

    // Logs
    logs = logs.replace(/&gt;/g, ">");
    logs = logs.replace(/&lt;/g, "<");

    list = [];
    nr = -1;
    do {
        val = regExLog.exec(logs);
        if (val !== null) {
//            console.log(JSON.stringify(val));
            nr++;
            rec = {};
            dat         = simpleRegEx(val[1], regExDate);
            rec.date    = dat.substring(0, 10);
            rec.found   = simpleRegEx(val[1], regExType);
            rec.cacher  = simpleRegEx(val[1], regExCacher);
            rec.logText = simpleRegEx(val[1], regExText);
            rec.wrapped = false;

//            if (nr < 10)
            list.push( rec );
        }
   } while (val !== null)

    console.log(JSON.stringify(list));
    result.logs = list;

    // Hidden Wayponts
    wpts = wpts.replace(/&gt;/g, ">");
    wpts = wpts.replace(/&lt;/g, "<");

    listWp = [];
    nr = -1;
    maxNrWp = -10000;
    wpFound = false;
//    console.log("Start Location: " + mainCoord);
    do {
        val = regExHidCmt.exec(wpts);
        if (val !== null) {
//            console.log(JSON.stringify(val));
            wpSym   = val[1];
            wpDesc  = val[2];
            wpCoord = val[3].trim();
            wpCmt   = val[4];

            if (wpCoord === mainCoord)
                wpFound = true;

            // Trying to catch the right Waypoint number
            if (wpSym === "PK" || regExPark.exec(wpDesc)) {
                wpType = "Parking";
                wpNr   = 0;
            }
            else if (wpCoord === mainCoord) {
                wpType = "Start";
                wpNr = 1;
                nr = 1;
            }
            else if (wpSym === "FN") {
                wpType = "Final";
                nr++;
                wpNr = nr;
            }
            else {
                // Test the formula
                tmp = regExWpNr.exec(wpSym);
                if (tmp) {
                    nr = parseInt(tmp[1]);
                    wpNr = nr;
                }
                else {
                    nr++;
                    wpNr = nr;
                }
            }

            tmp = regExCrdFrm.exec(wpDesc);
            if (tmp) {
                wpCoord = tmp[1];
            }

            if (regExEmpty.exec(wpCoord))
                wpCoord = tmplCoord;
            if (!wpCoord)
                wpCoord = simpleRegEx(wpDesc, regExCoords);
            if (!wpCoord)
                wpCoord = simpleRegEx(wpDesc, regExString);

            rec = {};
            rec.number      = wpNr;
            rec.coordinate  = wpCoord;
            rec.descript    = wpDesc;
            rec.instruction = wpCmt;
            rec.marked      = false;
            rec.wrapped     = true;

            listWp.push( rec );

            if (wpNr > maxNrWp) maxNrWp = wpNr;
        }
    } while (val !== null)

    if (!wpFound) {
        wpNr = 1;
        rec  = {};
        rec.number      = wpNr;
        rec.coordinate  = mainCoord;
        rec.descript    = "Starting location";
        rec.instruction = "";
        rec.marked      = false;
        rec.wrapped     = true;

        listWp.push( rec );
        console.log("Adding Main Coord: " + mainCoord);
        if (wpNr > maxNrWp) maxNrWp = wpNr;
    }

    console.log(JSON.stringify(listWp));

    // Description
    desc = desc.replace(/&gt;/g, ">");
    desc = desc.replace(/&lt;/g, "<");
    desc = desc.replace(/\s/g, " ");
    desc = desc.replace(/<span\s?[^>]+?>/g, "");
    desc = desc.replace(/<\/span>/g, "");

    desc = desc.replace(/;/g, ",");
    desc = desc.replace(/<\/p>/g, ";");
    desc = desc.replace(/<\/h.?>/g, ";");
    desc = desc.replace(/<\/[dou]l>/g, ";");
    desc = desc.replace(/<li>/g, "* ");
    desc = desc.replace(/<\/d[dt]>/g, " | ");
    desc = desc.replace(/<\/li>/g, " | ");
    desc = desc.replace(/<td[^>]+>/g, " | ");
    desc = desc.replace(/<\/tr>/g, ";");
    desc = desc.replace(/<\/table>/g, ";");
    desc = desc.replace(/<br\s?\/?>/g, ";");
    desc = desc.replace(/<\/?[^>]+>/g, "");

    console.log(desc.substring(0, 500));

    listDesc = [];
    val = desc.split(";");
    for (i = 0; i < val.length; i++) {
        txt = val[i].trim();
        if (txt.length > 0) {
            wpCoord = "";
            wpNr    = 0;

            // Searching for a coordinate or formula
            tmp = regExCoords.exec(txt);
            if (tmp) {
                wpCoord = coordFromDesc(tmp[1]);
                console.log("Coord found "+ wpCoord + ", within: " + txt);
            }
            else {
                tmp = regExCrdFrm.exec(txt);
                if (tmp) {
                    wpCoord = tmp[1];
                    console.log("Formula found "+ wpCoord);
                }
            }

            if (wpCoord.length > 0) {

                // Should it be added to waypoints?
                wpFound = false;
                for (j = 0; j < listWp.length; j++) {
                    if (listWp[j].coordinate === wpCoord)
                        wpFound = true;
                }

                if (!wpFound) {
                    rec = {};
                    rec.number      = ++maxNrWp;
                    rec.coordinate  = wpCoord;
                    rec.descript    = txt;
                    rec.instruction = "";
                    rec.marked      = false;
                    rec.wrapped     = true;

                    listWp.push( rec );
                    console.log("Adding WP: " + maxNrWp + ", " + wpCoord);

                }
            }

            rec = { line      : txt
                  , coordinate: wpCoord
                  , number    : wpNr
                  , marked    : false
                  , wrapped   : true
                  }

            listDesc.push(rec);
        }
    }

    console.log(JSON.stringify(listDesc));
    result.description = listDesc;

    // Sorting waypoints
    listWp.sort(function(a, b){return a.number - b.number});

    console.log(JSON.stringify(listWp));
    result.waypoints = listWp;

    console.log(JSON.stringify(result));

    return result
}

function gpxByRegEx(rawText) {
    var regExNewlin = /\r?\n|\r/g;                             // to remove newlines
    var regExTabs   = /\t/g;                                   // to remove tabs
    var regExSpaces = /\s\s/g;                                 // to remove double spaces

    rawText = rawText.replace(regExNewlin, "");
    rawText = rawText.replace(regExTabs, " ");
    rawText = rawText.replace(regExSpaces, " ");
    rawText = rawText.replace(regExSpaces, " ");
    rawText = rawText.replace(regExSpaces, " ");

    return rawText
}

function simpleRegEx(rawText, regEx) {
    var res = regEx.exec(rawText);
    if (res !== null) {
        return res[1];
    }
    return ""
}

function coordFromLatLon(lat, lon) {
    var coordinate = "";
    var degLat = parseInt(lat);
    var degLon = parseInt(lon);
    var mLat = (parseFloat(lat) - degLat) * 60;
    var mLon = (parseFloat(lon) - degLon) * 60;
    var strLat = "00" + degLat.toString();
    var strLon = "00" + degLon.toString();
    var minLat = "00" + mLat.toFixed(3);
    var minLon = "00" + mLon.toFixed(3);

    coordinate  = (degLat > 0 ?  "N " :  "S ") + strLat.slice(-2) + "° " + minLat.slice(-6);
    coordinate += (degLon > 0 ? " E " : " W ") + strLon.slice(-3) + "° " + minLon.slice(-6);

//    console.log(coordinate);
    return coordinate
}

function coordTmplLatLon(lat, lon) {
    var coordinate = "";
    var degLat = parseInt(lat);
    var degLon = parseInt(lon);
    var mLat = (parseFloat(lat) - degLat) * 60;
    var mLon = (parseFloat(lon) - degLon) * 60;
    var strLat = "00" + degLat.toString();
    var strLon = "00" + degLon.toString();
    var minLat = "00" + mLat.toFixed(3);
    var minLon = "00" + mLon.toFixed(3);

    coordinate  = (degLat > 0 ?  "N " :  "S ") + strLat.slice(-2) + "° " + minLat.slice(-6);
    coordinate += (degLon > 0 ? " E " : " W ") + strLon.slice(-3) + "° " + minLon.slice(-6);

//    console.log(coordinate);
    return coordinate
}

function coordFromDesc(txt) {
    var regExCoords = /([NS])\s?([0-9]{1,2})°?\s?([0-9]{1,2})\.([0-9]{1,3}).+?([EW])\s?([0-9]{1,3})°?\s?([0-9]{1,2})\.([0-9]{1,3})/g;
    var tmp, nsLat, degLat, minLat, decLat, nsLon, degLon, minLon, decLon;
    var coordinate = "";
    var mLat, mLon, strLat, strLon;

    tmp = regExCoords.exec(txt);
    if (tmp) {
        nsLat  = tmp[1];
        degLat = tmp[2];
        minLat = tmp[3];
        decLat = tmp[4];
        nsLon  = tmp[5];
        degLon = tmp[6];
        minLon = tmp[7];
        decLon = tmp[8];

        degLat = parseInt(degLat);
        degLon = parseInt(degLon);
        mLat   = parseFloat(minLat + "." + decLat);
        mLon   = parseFloat(minLon + "." + decLon);
        strLat = "00" + degLat.toString();
        strLon = "00" + degLon.toString();
        minLat = "00" + mLat.toFixed(3);
        minLon = "00" + mLon.toFixed(3);

        coordinate  = nsLat + " " + strLat.slice(-2) + "° " + minLat.slice(-6) + " ";
        coordinate += nsLon + " " + strLon.slice(-3) + "° " + minLon.slice(-6);
//        console.log(coordinate);
    }

    return coordinate
}
