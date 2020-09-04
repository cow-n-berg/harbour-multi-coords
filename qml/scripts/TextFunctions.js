/*
 * Copyright (C) 2020 Rob Kouwenberg <sailfish@cow-n-berg.nl>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2 only.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

.pragma library
.import QtQuick 2.0 as QtQuick

/*
*  A truncation function for occasions
*  when Silica components won't work
*/
function truncateString(str, num) {
  if (str.length <= num) {
    return str
  }
  return str.slice(0, num) + '...'
}

/*
*  A trim function for strings
*/
function trimString(str) {
  return str.trim()
}

/*
*  A function to check for empty strings,
*  and issue a replacement string
*/
function replString(str, repl) {
  if (str.trim() === "") {
    return repl
  }
  return str
}

/*
*  Building up an icon url
*/
function coverIconUrl(darkTheme, nightMode) {
    var url;
    var filename = "../images/icon-cover-";
    if (nightMode){
        filename += "black.svg";
    }
    else if (darkTheme) {
        filename += "white.svg";
    }
    else {
        filename += "black.svg";
    }
    url = Qt.resolvedUrl(filename)
//    console.log(url);
    return url
}

function foundIconUrl(found) {
    var url;
    var filename = "../images/icon-";
    if (found) {
        filename += "found-";
    }
    else {
        filename += "blank-";
    }
    filename += "black.svg";
    url = Qt.resolvedUrl(filename)
//    console.log("foundIcon " + filename)
    return url
}

function wayptIconUrl(isWpt) {
    var url;
    var filename = "../images/icon-";
    if (isWpt) {
        filename += "waypt-";
    }
    else {
        filename += "cache-";
    }
    filename += "black.svg";
    url = Qt.resolvedUrl(filename)
//    console.log("wayptIcon " + filename)
    return url
}

/*
*  Building up an button text
*/
function wayptFoundButton(isWpt, isFound) {
    //qsTr("Mark waypoint as Found")
    var text = qsTr("This ");
    if (isWpt) {
        text += qsTr("waypoint is ");
    }
    else {
        text += qsTr("geocache is ");
    }
    if (isFound) {
        text += qsTr("Found");
    }
    else {
        text += qsTr("Not Found");
    }
    return text
}

/*
*  Building up an button text
*/
function coverText(gccode, gcname, wpnumber, showAppName) {
    var text = "";
    if (gccode !== undefined) {
        text += gccode + "\n" + truncateString(gcname,12);
    }
    if (wpnumber !== undefined) {
        text += "\nWP " + wpnumber;
    }
    if (showAppName) {
        if (gccode !== undefined) {
            text += "\n";
        }
        text += qsTr("GMFS");
    }
    return text
}

/*
*  Total abuse of this function :D
*  Write to console, and return an empty string!
*/
function textConsole( str ) {
    console.log( str );
    return ''
}

/*
*  Function to break up a formula for easy evaluating
*/
function formulaToObj( formula ) {
//    formula = "N52 0[A+3].[B-9][C-8][D-2] E005 1[E-4].[F+2][G-1][H-5]";

    if (formula !== undefined) {

        var str = formula.replace(/\[/g, "|[");
        str = str.replace(/\]/g, "|");
        str = str.replace(/\|\|/g, "|");
        var arr = str.split("|");

        var obj = [];
        for (var i = 0; i < arr.length; i++) {
            var txt = arr[i];
            var calc = ( txt.substr(0,1) === "[" );
            if (calc) {
                txt = txt.substr(1);
            }
            if (txt.length > 0) {
                obj.push( { "part": txt, "eval": calc } )
            }
        }

        // console.log( JSON.stringify(obj) );
        // Resultaat:
        /*
        * [
        * {"eval":false,"part":"N52 0"},
        * {"eval":true, "part":"A+3"},
        * {"eval":false,"part":"."},
        * {"eval":true, "part":"B-9"},
        * {"eval":true, "part":"C-8"},
        * {"eval":true, "part":"D-2"},
        * {"eval":false,"part":" E005 1"},
        * {"eval":true, "part":"E-4"},
        * {"eval":false,"part":"."},
        * {"eval":true, "part":"F+2"},
        * {"eval":true, "part":"G-1"},
        * {"eval":true, "part":"H-5"}
        * ]
        */

        return obj
    }
    return {}
}

/*
*  Function to evaluate a formula
*/
function evalFormula( formstr, letters ) {
//    var formula = JSON.parse(formjson);
    var formula = formulaToObj(formstr);
    var result = "";
    var i, j;

    var arrLen = letters.length;
    for (i = 0; i < arrLen; i++) {
        var lett = letters[i].letter;
        var valu = letters[i].lettervalue;
        var leng = lett.length;
        if (leng > 1 && valu.length === leng) {
            for (j = 0; j < leng; j++) {
                var l = lett.slice( j, j + 1 );
                var v = valu.slice( j, j + 1 );
                letters.push({ letter: l, lettervalue: v });
            }
        }
    }

    for (i = 0; i < formula.length; i++) {
        if (formula[i].eval) {
            var str = formula[i].part;
            for (j = 0; j < letters.length; j++) {
                var val = letters[j].lettervalue;
                if (val !== "") {
                    var re = new RegExp(letters[j].letter,"g");
                    str = str.replace(re, val);
                }
            }
            try {
                var evaluated = eval(str);
                result += evaluated;
            }
            catch(err) {
                result += "[" + str + "]";
            }
        }
        else {
            result += formula[i].part;
        }
    }

    return result
}

/*
*  Function to show all letters and values
*/
function showLetters( letters ) {
    var result = "";
    var checksum = 0;
    for (var j = 0; j < letters.length; j++) {
        result += letters[j].letter + " = " + letters[j].lettervalue;
        if (letters[j].remark !== "") {
            result += ", " +letters[j].remark;
        }
        result += "\n";
        if (letters[j].lettervalue !== "") {
            checksum += Number(letters[j].lettervalue);
        }
    }
    result += "Checksum = " + checksum;
    return result
}

/*
*  Function to show all letters and values
*/
function reqWpLetters( letters, wayptid ) {
    var result = "";
    var checksum = 0;
    for (var j = 0; j < letters.length; j++) {
//        console.log("Vergelijk " + letters[j].wayptid + ", " + wayptid + ", " + letters[j].letter );
        if (letters[j].wayptid === wayptid) {
            result += (result === "" ? "" : ", ") + letters[j].letter;
        }
    }
    if (result !== "") {
        result = ", " + qsTr("find ") + result;
    }
//    console.log("wayptid: " + wayptid + ", " + result + ", " + JSON.stringify(letters));
    return result
}

/*
*  Function to show result for letters entry
*/
function lettersResult(txtLetters) {
    var letters = txtLetters.split(" ");
    var result = "";
    for (var j = 0; j < letters.length; j++) {
        result += (j===0 ? "" : ", ") + "'" + letters[j] + "'";
    }
}

/*
*  Function to extract information from raw text
*/
function coordsByRegEx(rawText, searchLength) {

    var regExNewlin = /\r?\n|\r/g;                             // to remove newlines
    var regExEmpty  = /N\/S[^_]+?__[^_]+?__[^_]+?___\sW\/E[^_]+?___[^_]+?__[^_]+?___/g;

    var regExGcCode = /(GC.{1,5})/;
    var regExGcName = /<groundspeak:name>([^<]*)/;

    // Stages in GPX file
//  var regExStages = /<wpt lat="([^"]*)" lon="([^"]*)">.+?<name>(.{2}).+?<\/name>.+?<cmt>(.*?)<\/cmt>.+?<desc>(.*?)<\/desc>.+?<sym>(.*?)<\/sym>.+?<\/wpt>/g;
    var regExWaypt  = /(<wpt lat=.+?<\/wpt)>/g;
    var regExStWayp = /<wpt lat="([^"]*)" lon="([^"]*)">/;
    var regExStName = /<name>(.{2}).+?<\/name>/;
    var regExStCmt  = /<cmt>(.*?)<\/cmt>/;
    var regExStDesc = /<desc>(.*?)<\/desc>/;
    var regExStSym  = /<sym>(.*?)<\/sym>/;

    // To do: Additional Hidden Waypoints
    var regExHidden = /Additional Hidden Waypoints(.*)<\/groundspeak:long_description>/;
    var regExHidCmt = /(..)7JV34\s-\s(.+?)&lt;br\s\/\&gt; \&lt;br \/\&gt;(.+?)\&lt;br \/\&gt;/g
    // Einde to do

    var regExCoords = /([NS]\s?[0-9]{1,2}°?\s[0-9]{1,2}\.[0-9]{1,3}\s[EW]\s?[0-9]{1,3}°?\s[0-9]{1,2}\.[0-9]{1,3})/g;
    var regExString = "([NS][^#]{5," + searchLength + "}\\s[EW][^#&,']{5," + searchLength + "})"
    var regExFormul = new RegExp(regExString, "g");
    // Should be like /([NS][^#]{5,40}\s[EW][^#&,']{5,40})/g

    var result = {code: '', name: '', coords: undefined };
    var arrCoord = [];
    var sortCoord = [];
    var waypt = 0;
    var res;
    var coordinate;
    var note;
    var toBeDeleted = [];

    rawText = rawText.replace(regExNewlin, "");
    rawText = rawText.replace(regExEmpty, "");

    // In case they entered a GPX file
    result.name = simpleRegEx(rawText, regExGcName);
    result.code = simpleRegEx(rawText, regExGcCode);

    var regex = /<wpt lat=.+?<\/wpt>/g;
    var m;

    // Stages in GPX file
    do {
        res = regExWaypt.exec(rawText);
        if (res !== null) {
            console.log("Stage GPX found: "+ res[1]);
            var wpt = res[1];

            var coordObj = coordLatLon(wpt);
            coordinate = coordObj.coord;
            if (coordinate !== "") {
                toBeDeleted.push(coordObj.regex);

                // We may have a full GPX, where main
                // coordinate shows up twice. If so, throw it out
                if (arrCoord.length >= 1) {
                    if (arrCoord[0].coord === coordinate) {
                        arrCoord.shift();
                    }
                }

                // Get information from waypoint
                var wpName = simpleRegEx(wpt, regExStName);
                var wpCmt  = simpleRegEx(wpt, regExStCmt );
                var wpDesc = simpleRegEx(wpt, regExStDesc);
                var wpSym  = simpleRegEx(wpt, regExStSym );

                if (wpName === "GC") {
                    var wpnr = 1;
                }
                else {
                    var nr = parseInt(wpName);
                    wpnr = isNaN(nr) ? 0 : nr;
                }

                note  = wpSym + " - " + wpDesc + " - " + wpCmt
                arrCoord.push({number: wpnr, coord: coordinate, note: note});
                console.log("added coord: " + waypt + ", coord:"  + coordinate + ", nr: " + wpnr + ", note: " + note)
                waypt = Math.max(wpnr, waypt);
            }
            waypt++;
        }
    } while (res !== null)

    for (var i = 0; i < toBeDeleted.length; i++) {
        // Remove coord from rawtext to prevent doubles
        var coordRe = toBeDeleted[i];
        rawText = rawText.replace(coordRe, "#");
    }
    toBeDeleted = [];

    // Stages in Hidden Waypoints within GPX file
    var hidden = simpleRegEx(rawText, regExHidden);

    do {
        res = regExHidCmt.exec(hidden);
        if (res !== null) {
            console.log("Hidden waypoint found: "+ JSON.stringify(res));

            if (res[1] === "FN") {
                 wpnr = waypt;
                console.log("Final Location, " + wpnr);
            }
            else {
                nr = parseInt(res[1]);
                wpnr = isNaN(nr) ? 0 : nr;
            }

            wpSym  = res[1];
            wpDesc = res[2];
            wpCmt  = res[3];
            coordinate = simpleRegEx(wpCmt, regExFormul);
//            console.log("wpSym " + wpSym + ", wpDesc " + wpDesc + ", coord: " + coordinate + ", wpCmt: " + wpCmt );

            if (coordinate === "") {
                var leng = Math.min(40, wpCmt.length + 1);
                coordinate = wpCmt.slice(0,leng);
            }

            coordRe = new RegExp(escapeRegExp(wpCmt));
            toBeDeleted.push(coordRe);

            note  = wpSym + " - " + wpDesc + " - " + wpCmt
            arrCoord.push({number: wpnr, coord: coordinate, note: note});
            console.log("added hidden: " + waypt + ", coord:"  + coordinate + ", nr: " + wpnr + ", note: " + note)
            waypt = Math.max(wpnr, waypt);

            waypt++;
        }
    } while (res !== null)

    // Remove hidden waypoints from rawtext to prevent doubles
    for (i = 0; i < toBeDeleted.length; i++) {
        coordRe = toBeDeleted[i];
        rawText = rawText.replace(coordRe, "#");
    }

    note = "";

    // Remove coord from rawtext to prevent doubles
    do {
        res = regExCoords.exec(rawText);
        if (res !== null) {
            console.log("Text coord found: " + res[1]);
            coordinate = res[1];
            // Remove coord from rawtext to prevent doubles
            coordRe = new RegExp(coordinate, 'g');
            rawText = rawText.replace(coordRe, "#");

            arrCoord.push({number: waypt, coord: coordinate, note: note});
            waypt++;
        }
    } while (res !== null)

    // Search for formulas within rawtext
    do {
        res = regExFormul.exec(rawText);
        if (res !== null) {
            console.log("Formula found: " + res[1]);
            coordinate = res[1];
            arrCoord.push({number: waypt, coord: coordinate, note: note});
            waypt++;
        }
    } while (res !== null)

    // Manual sort of coordinates
    var minNr = 99;
    var maxNr = -1;
    for (i = 0; i < arrCoord.length; i++) {
        minNr = Math.min(arrCoord[i].number, minNr);
        maxNr = Math.max(arrCoord[i].number, maxNr);
    }
    for (var j = minNr; j <= maxNr; j++) {
        for (i = 0; i < arrCoord.length; i++) {
            if (j === arrCoord[i].number) {
                sortCoord.push(arrCoord[i]);
            }
        }
    }

    result.coords = sortCoord;
    console.log(JSON.stringify(result));

    return result
}

function simpleRegEx(rawText, regEx) {
    var res = regEx.exec(rawText);
    if (res !== null) {
        return res[1];
    }
    return ""
}

function coordLatLon(rawText) {
    var regExLatLon = /<wpt\slat="([^"]*)"\slon="([^"]*)">/;
    var coordinate = "";
    var re;
    var res = regExLatLon.exec(rawText);
    if (res !== null) {
//        console.log(JSON.stringify(res) + " res1 " + res[1]+ " res2 " + res[2]  );
        var degLat = parseInt(res[1]);
        var degLon = parseInt(res[2]);
        var Lat = (parseFloat(res[1]) - degLat) * 60;
        var Lon = (parseFloat(res[2]) - degLon) * 60;
        var strLat = "00" + degLat.toString();
        var strLon = "00" + degLon.toString();
        var minLat = "00" + Lat.toFixed(3);
        var minLon = "00" + Lon.toFixed(3);

        coordinate  = (degLat > 0 ?  "N " :  "S ") + strLat.slice(-2) + "° " + minLat.slice(-6);
        coordinate += (degLon > 0 ? " E " : " W ") + strLon.slice(-3) + "° " + minLon.slice(-6);

        strLat = degLat.toString();
        strLon = degLon.toString();
        minLat = Lat.toFixed(3);
        minLon = Lon.toFixed(3);

        var regExStr = (degLat > 0 ?  "N" :  "S") + ".{0,1}" + strLat + ".{1,3}" + minLat + ".{1,5}" + strLon+ ".{1,3}" + minLon;
//        console.log(regExStr);
        re = new RegExp(regExStr, 'g');
    }
    else {
        console.log("No coord found from " + rawText);
    }

    return { coord: coordinate, regex: re}
}

function escapeRegExp(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}

function lettersFromRaw(rawText) {
    var result = "";
    var regExLetter1 = /(\b[A-Z]+?\b)/g
    var regExLetter2 = /(\b[a-z]\b)/g
    var res;

    rawText = " " + rawText + " ";
    console.log("rawText: '" + rawText + "'");
    do {
        res = regExLetter1.exec(rawText);
        if (res !== null) {
            console.log("Word found: " + res[1]);
            if (res[1] !== "WP" && result.search(res[1]) < 0) {
                result += (result === "" ? "" : " ") + res[1];
            }
        }
    } while (res !== null)
    do {
        res = regExLetter2.exec(rawText);
        if (res !== null) {
            console.log("Word found: " + res[1]);
            if (res[1] !== "WP" && result.search(res[1]) < 0) {
                result += (result === "" ? "" : " ") + res[1];
            }
        }
    } while (res !== null)

    return result
}
