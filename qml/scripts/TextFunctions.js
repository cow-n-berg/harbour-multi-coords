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
.import QtQuick 2.2 as QtQuick

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

function copyIconUrl(darkTheme, nightMode) {
    var url;
    var filename = "../images/icon-cover-copy-";
    if (nightMode){
        filename += "white.svg";
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
*  Building up a button text
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
*  Building up a button text
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
    var regExNonDigit = /[^0-9]/;
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
            if (simpleRegEx(str, regExNonDigit) === "") {
                // Only digits, that's what we want
                result += str;
            }
            else {
                // Won't probably be evaluated
                try {
                    var evaluated = eval(str);
                    if (evaluated === undefined) {
                        result += "[" + str + "]";
                    }
                    else {
                        result += evaluated;
                    }
                }
                catch(err) {
                    result += "[" + str + "]";
                }
            }
        }
        else {
            result += formula[i].part;
        }
    }

    return result
}

/*
*  Function to show all letters and values for the geocache
*/
function showLetters( letters ) {
    var result = "";
    var checksum = 0;
    for (var j = 0; j < letters.length; j++) {
        if (typeof letters[j].remark !== "undefined") {
            result += letters[j].letter + " = " + letters[j].lettervalue;
            if (letters[j].remark !== "") {
                result += ", " +letters[j].remark;
            }
            result += "\n";
            if (letters[j].lettervalue !== "") {
                checksum += Number(letters[j].lettervalue);
            }
        }
    }
    result += "Checksum = " + checksum;
    return result
}

/*
*  Function to show all letters and values for this waypoint
*/
function reqWpLetters( letters, wayptid ) {
    var result = "";
    var checksum = 0;
    var allFound = true;
    for (var j = 0; j < letters.length; j++) {
//        console.log("Vergelijk " + letters[j].wayptid + ", " + wayptid + ", " + letters[j].letter );
        if (letters[j].wayptid === wayptid) {
            result += (result === "" ? "" : ", ") + letters[j].letter;
            result += (letters[j].lettervalue === "" ? "" : " = ") + letters[j].lettervalue;
            if (letters[j].lettervalue === "")
                allFound = false;
        }
    }
    if (result !== "") {
        result = ", " + (allFound ? qsTr("find ") : qsTr("found ")) + result;
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
*  Function to show analysis for remark entry
*/
function remarkValues( remark ) {
    var regExCapitals = /[A-Z]/g;
    var regExNumbers = /\d/g;
    var firstValue   = 0;
    var valueLetters = 0;
    var valueNumbers = 0;
    var countLetters = 0;
    var countNumbers = 0;
    var countChars   = remark.length;
    var crossLetters = 0;
    var crossNumbers = 0;
    var strNumbers = "0";
    var res;

    if (remark !== "" ) {
        // Extract all letters
        do {
            res = regExCapitals.exec( remark.toUpperCase() );
//            console.log(res);
            if (res !== null) {
                countLetters++;
                valueLetters += res[0].charCodeAt(0) - 64;
                firstValue = firstValue === 0 ? res[0].charCodeAt(0) - 64 : firstValue;
            }
        } while (res !== null)

        crossLetters = valueLetters % 9;

        // Extract all numbers
        do {
            res = regExNumbers.exec( remark );
            if (res !== null) {
                countNumbers++;
                valueNumbers += Number(res[0]);
                strNumbers += res[0];
            }
        } while (res !== null)

        crossNumbers = Number(strNumbers) % 9;
    }

    // Modulo result 0 should be a 9
    if (countLetters > 0 && crossLetters === 0) {
        crossLetters = 9
    }
    if (countNumbers > 0 && crossNumbers === 0) {
        crossNumbers = 9
    }

    var str = "Letters: " + countLetters + ", sum: " + valueLetters + ", cross sum: " + crossLetters + ", first letter: " + firstValue + "\n";
    str +=    "Numbers: " + countNumbers + ", sum: " + valueNumbers + ", cross sum: " + crossNumbers + "\n";
    str +=    "Chars: " + countChars;

    return str;
}

/*
*  Function to extract information from raw text
*/
function extractDescr(rawText) {}

function extractHint(rawText) {
    var regExHint = /Additional Hidden Waypoints(.*)<\/groundspeak:long_description>/;

}

function coordsByRegEx(rawText, searchLength) {

    var regExNewlin = /\r?\n|\r/g;                             // to remove newlines
    var regExEmpty  = /N\/S[^_]+?__[^_]+?__[^_]+?___\sW\/E[^_]+?___[^_]+?__[^_]+?___/g;

    var regExGcCode = /(GC[0-9A-Z]{1,5})/;
    var regExGcName = /<groundspeak:name>([^<]*)/;

    // Stages in GPX file
//  var regExStages = /<wpt lat="([^"]*)" lon="([^"]*)">.+?<name>(.{2}).+?<\/name>.+?<cmt>(.*?)<\/cmt>.+?<desc>(.*?)<\/desc>.+?<sym>(.*?)<\/sym>.+?<\/wpt>/g;
    var regExWaypt  = /(<wpt lat=.+?<\/wpt)>/g;
    var regExStWayp = /<wpt lat="([^"]*)" lon="([^"]*)">/;
    var regExStName = /<name>(.{2}).+?<\/name>/;
    var regExWpNr   = /([0-9]+?)/;
    var regExStCmt  = /<cmt>(.*?)<\/cmt>/;
    var regExStDesc = /<desc>(.*?)<\/desc>/;
    var regExStSym  = /<sym>(.*?)<\/sym>/;

    // Additional Hidden Waypoints
    var regExHidden = /Additional Hidden Waypoints(.*)<\/groundspeak:long_description>/;
    var regExHidCmt = /([A-Z0-9]{2})[A-Z0-9]{2,5}\s-\s(.*?)&lt;br\s\/&gt;(.*?)&lt;br\s\/&gt;(.*?)&lt;br\s\/&gt/g;

    // Coordinates and formulas in plain text
    var regExCoords = /([NS]\s?[0-9]{1,2}°?\s[0-9]{1,2}\.[0-9]{1,3}\s[EW]\s?[0-9]{1,3}°?\s[0-9]{1,2}\.[0-9]{1,3})/g;
    var regExString = "([NS][^#]{5," + searchLength + "}\\s[EW][^#&,']{5," + searchLength + "})"
    var regExFormul = new RegExp(regExString, "g");
    // Should be like /([NS][^#]{5,40}\s[EW][^#&,']{5,40})/g

    var result = {code: '', name: '', coords: undefined };
    var arrCoord = [];
    var sortCoord = [];
    var wpCoord;
    var waypt = 0;
    var res;
    var coordinate;
    var raw;
    var note;
    var i, coordRe;
    var toBeDeleted = [];

    rawText = rawText.replace(regExNewlin, "");
    rawText = rawText.replace(regExEmpty, "");

    // In case they entered a GPX file
    result.name = simpleRegEx(rawText, regExGcName).trim();
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
            raw = coordinate;
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
                    wpName = simpleRegEx(wpName, regExWpNr);
                    if (wpName === "" ) wpName = simpleRegEx(wpDesc, regExWpNr);
                    wpnr = ( wpName === "" ? 0 : parseInt(wpName) );
                }

                note  = wpSym + " - " + wpDesc + " - " + wpCmt
                arrCoord.push({number: wpnr, coord: coordinate, note: note, raw: raw});
                console.log("added coord: " + waypt + ", coord:"  + coordinate + ", nr: " + wpnr + ", note: " + note)
                waypt = Math.max(wpnr, waypt);
            }
            waypt++;
        }
    } while (res !== null)

    for (i = 0; i < toBeDeleted.length; i++) {
        // Remove coord from rawtext to prevent doubles
        coordRe = toBeDeleted[i];
        rawText = rawText.replace(coordRe, "#DeletedWP#");
    }
    toBeDeleted = [];

    // Stages in Hidden Waypoints within GPX file
    var hidden = simpleRegEx(rawText, regExHidden);
    if (hidden !== "") {
        console.log("Section with Hidden Waypoints found");
        console.log(hidden);

        do {
            res = regExHidCmt.exec(hidden);

            if (res !== null) {
                console.log("Hidden waypoint found: "+ JSON.stringify(res));

                wpSym   = res[1];
                wpDesc  = res[2];
                wpCoord = res[3].trim();
                wpCmt   = res[4];

                if (res[1] === "FN") {
                    wpnr = waypt;
                    console.log("Final Location, " + wpnr);
                }
                else {
                    wpName = simpleRegEx(wpName, regExWpNr);
                    if (wpName === "" ) wpName = simpleRegEx(wpDesc, regExWpNr);
                    wpnr = ( wpName === "" ? 0 : parseInt(wpName) );
                }

                console.log("wpSym " + wpSym + ", wpDesc " + wpDesc + ", wpCoord: " + wpCoord + ", wpCmt: " + wpCmt );

                var res2 = regExFormul.exec(wpCmt);
                if (res2 !== null) {
                    coordinate = res2[1];
                }
                else {
                    if (wpCoord === "") {
//                        var leng = Math.min(40, wpCmt.length + 1);
//                        coordinate = wpCmt.slice(0,leng);
                        coordinate = wpCmt;
                    }
                    else {
                        coordinate = wpCoord;
                    }
                }

//                console.log(coordinate);
//                console.log("wpSym " + wpSym + ", wpDesc " + wpDesc + ", coord: " + coordinate + ", wpCmt: " + wpCmt );

                coordRe = new RegExp(escapeRegExp(wpCmt));
                toBeDeleted.push(coordRe);

                // Clean up coordinate here
                raw = coordinate;
                coordinate = cleanUpFormula(coordinate);

                note  = wpSym + " - " + wpDesc + " - " + wpCmt
                arrCoord.push({number: wpnr, coord: coordinate, note: note, raw: raw});
                console.log("added hidden: " + waypt + ", coord:"  + coordinate + ", nr: " + wpnr + ", note: " + note)
                waypt = Math.max(wpnr, waypt);

                waypt++;
            }
        } while (res !== null)
    }

    // Remove hidden waypoints from rawtext to prevent doubles
    for (i = 0; i < toBeDeleted.length; i++) {
        coordRe = toBeDeleted[i];
        rawText = rawText.replace(coordRe, " # ");
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

            arrCoord.push({number: waypt, coord: coordinate, note: note, raw: coordinate});
            waypt++;
        }
    } while (res !== null)

    // Search for formulas within rawtext
    do {
        res = regExFormul.exec(rawText);
        if (res !== null) {
            console.log("Formula found: " + res[1]);
            coordinate = res[1];
            raw = coordinate;
            // Clean up here
            coordinate = cleanUpFormula(coordinate);
            arrCoord.push({number: waypt, coord: coordinate, note: note, raw: raw});
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

function cleanUpFormula(formula) {
    var regExCleanUp= /([NS])\s?(.*)\s+([^.]+?[\.].*)\s([EW])\s?(.*)\s+([^.,]*[\.,].*)/
    var regExDivid  = /÷/g;
    var regExDegree = /°/g;
    var regExSecond = /'/g;
    var regExNonDig = /[^0-9.]/;
    var regExSpace  = /\s/g;
    var regExComma  = /,/g;
    var regExBrack1 = /\[/g;
    var regExBrack2 = /\]/g;
    var regExNoBrack= /[^0-9./]/;
    var north, east;
    var parts = [];
    var part;

//    console.log("Raw formula: " + formula);

    // The least to clean up is the dividing symbol
    formula = formula.replace(regExDivid, "/");
    var result = formula;

    formula = formula.replace(regExDegree, " ");
    formula = formula.replace(regExSecond, " ");

//    console.log("After first cleaning: " + formula);

    var res = regExCleanUp.exec(formula);
    // Resulting in 6 groups; group 2, 3, 5, 6 to clean up

    if (res !== null && res.length === 7) {
        north = res[1];
        parts.push(res[2]);
        parts.push(res[3]);
        east = res[4];
        parts.push(res[5]);
        parts.push(res[6]);

//        console.log(parts.toString());

        for ( var i = 0; i < parts.length; i++ ) {
            part = parts[i];
            part = part.replace(regExSpace, "");
            // Let's replace all commas with dots, as Europeans are prone to use them instead of digital dots
            // And all brackets with parentheses for proper detection of parentheses levels
            part = part.replace(regExComma, "");
            part = part.replace(regExBrack1, "(");
            part = part.replace(regExBrack2, ")");

//            console.log("part " + i + " of formula is: " + part);

            if (part.search(regExNonDig) >= 0) {

                // Now split the parts in subparts
                var subs = [];
                var sub = "";
                var level = 0;
                var start;
                var j = 0;
                do {
                    if ( level === 0 ) {
                        if (part.charAt(j) === "(" ) {
                            subs.push(sub);
                            sub = part.charAt(j);
                            level++;
                        }
                        else if (part.charAt(j) === ".") {
                            subs.push(sub);
                            subs.push(part.charAt(j));
                            sub = "";
                        }
                        else {
                            sub += part.charAt(j);
                        }
                    }
                    else {
                        if (part.charAt(j) === "(" ) {
                            sub += part.charAt(j);
                            level++;
                        }
                        else if (part.charAt(j) === ")" ) {
                            sub += part.charAt(j);
                            level--;
                            if (level === 0) {
                                subs.push(sub);
                                sub = "";
                            }
                        }
                        else {
                            sub += part.charAt(j);
                        }
                    }
                    j++;
                } while ( j < part.length );
                subs.push(sub);

//                console.log("subs: " + subs.toString());

                // Glue the subparts together again, if needed using brackets
                part = "";
                for (j = 0; j< subs.length; j++ ) {
                    sub = subs[j];
                    if (sub.search(regExNoBrack) >= 0) {
                        part += "[" + sub + "]";
                    }
                    else {
                        part += sub;
                    }
                }
            }
            parts[i] = part;
//            console.log("cleaned up part " + i + " of formula is: " + part);
        }

        // Glue parts together again into a cleaned up formula
//        console.log("After cleaning and glueing: " + parts.toString());

        var degLat = parts[0];
        var minLat = parts[1];
        var degLon = parts[2];
        var minLon = parts[3];

        if (degLat.length < 2) {
            degLat = ("0" + degLat).slice(-2);
        }
        if (degLon.length < 3) {
            degLon = ("0" + degLon).slice(-3);
        }

        result = north + " " + degLat + "° " + minLat + " " + east + " " + degLon + "° " + minLon;
//        console.log(result);
    }

    return result
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

function lettersFromRaw(rawText, allLetters, wayptid) {
    var result = "";
    var regExNSEW = /([NS])\s?[0-9]{1,2}°?\s+[^.]+?[\.].*\s([EW])\s?[0-9]{1,3}°?\s+[^.]+?\./
    var regExLetter1 = /(\b[A-Z]+?\b)/g
    var regExLetter2 = /(\b[a-z]\b)/g
    var res;
    var unwanted = ["WP", "FN", "PK"];
    var found = false;
    var options = [];

    if (wayptid === undefined)
        wayptid = -1;
    if (allLetters === undefined)
        allLetters = [];

    // We don't want to suggest NSEW
    res = regExNSEW.exec(rawText);
    if (res !== null) {
//        console.log(JSON.stringify(res));
        unwanted.push(res[1]);
        unwanted.push(res[2]);
    }

    // We don't want any letters already searched in other waypoints
    for (var i = 0; i < allLetters.length; i++) {
        if (allLetters[i].wayptid !== wayptid) {
            unwanted.push(allLetters[i].letter);
        }
    }

//    console.log(unwanted.toString());

    // Find candidates
    rawText = " " + rawText + " ";
    do {
        res = regExLetter1.exec(rawText);
        if (res !== null) {
            options.push(res[1]);
        }
    } while (res !== null)
    do {
        res = regExLetter2.exec(rawText);
        if (res !== null) {
            options.push(res[1]);
        }
    } while (res !== null)

    options.sort();

    for (i = 0; i < options.length; i++) {
        found = false;
        for (var j = 0; j < unwanted.length; j++) {
            if (options[i] === unwanted [j])
                found = true;
        }
        if (!found && result.search(options[i]) < 0) {
            result += (result === "" ? "" : " ") + options[i];
        }
    }

    return result
}

function addParentheses(formula, newLetterstr, allLetters) {
    var reCardinals = /[NSEW]/;

    // First replace the known letters
    for (var i = 0; i < allLetters.length; i++) {
        var letter = allLetters[i].letter;
        // We won't change N, S, E, W
        if (letter !== "" && reCardinals.exec(letter) === null) {
            var re = new RegExp(allLetters[i].letter, "g")
            formula = formula.replace(re, "[" + letter + "]");
        }
    }

    // Then, strangely but it happens, this waypoint uses new letters
    // Format of newLetterstr is 'A B C DEF', to be splitted by space
    var arrLett = newLetterstr.split(" ");
    if (arrLett.length === 0 && arrLet !== "") {
        arrLett = [newLetterstr];
    }
    console.log(JSON.stringify(arrLett));
    if (arrLett.length > 0) {
        for (var j = 0; j < arrLett.length; j++) {
            letter = arrLett[j];
            var found = false;
            for (i = 0; i < allLetters.length; i++) {
                if (letter === allLetters[i].letter) {
                    found = true;
                }
            }
            // We won't replace twice, and we won't change N, S, E, W
            if (!found && reCardinals.exec(letter) === null) {
                re = new RegExp(letter, "g")
                formula = formula.replace(re, "[" + letter + "]");
            }
        }
    }

    // Get rid of double brackets
    formula = formula.replace(/\[\]/g, "");
    formula = formula.replace(/\[\[/g, "[");
    formula = formula.replace(/\]\]/g, "]");

    return formula
}

function simpleRegEx(rawText, regEx) {
    var res = regEx.exec(rawText);
    if (res !== null) {
        return res[1];
    }
    return ""
}

function formulaSolved (formula) {
    var regExSolved = /[^\d NSEW°'.]/g;
    console.log("formula");
    var res = regExSolved.exec(formula);
    if (res !== null) {
        console.log( res[0] )
    }

    return res === null
}

function escapeRegExp(string) {
  return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
}

function copyText( wpCalc, copyFirstPart ) {
    var regExPartOne = /[NS]\s?[0-9]{1,2}°?\s([0-9]{1,2}\.[0-9]{1,3})\s[EW]\s?[0-9]{1,3}°?\s[0-9]{1,2}\.[0-9]{1,3}/;
    var regExPartTwo = /[NS]\s?[0-9]{1,2}°?\s[0-9]{1,2}\.[0-9]{1,3}\s[EW]\s?[0-9]{1,3}°?\s([0-9]{1,2}\.[0-9]{1,3})/;
    var res;

    if (copyFirstPart) {
        res = regExPartOne.exec(wpCalc);
    }
    else {
        res = regExPartTwo.exec(wpCalc);
    }


    if (res !== null) {
        return res[1];
    }
    return "00.000"
}

function formulaTemplate( formula ) {
    var regEx = /([NS]\s?[0-9]{1,2}°?\s[0-9]{1,2}\.)[0-9]{1,3}\D*?(\s[EW]\s?[0-9]{1,3}°?\s[0-9]{1,2}\.)[0-9]{1,3}/;
    var res = regEx.exec(formula);

    if (res !== null) {
        return res[1] + res[2];
    }
    return ""
}

