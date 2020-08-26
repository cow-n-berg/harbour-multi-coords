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
function coverIconUrl(darkTheme) {
    var url;
    var filename = "../images/icon-cover-";
    if (darkTheme) {
        filename += "white.svg";
    }
    else {
        filename += "black.svg";
    }
    url = Qt.resolvedUrl(filename)
//    console.log(url);
    return url
}

function coverGithubUrl(darkTheme) {
    var url;
    var filename = "../images/icon-github-";
    if (darkTheme) {
        filename += "white.png";
    }
    else {
        filename += "black.png";
    }
    url = Qt.resolvedUrl(filename)
    return url
}

function foundIconUrl(found, darkTheme) {
    var url;
    var filename = "../images/icon-";
    if (found) {
        filename += "found-";
    }
    else {
        filename += "blank-";
    }
    if (darkTheme) {
        filename += "white.svg";
    }
    else {
        filename += "black.svg";
    }
    url = Qt.resolvedUrl(filename)
    return url
}

function wayptIconUrl(isWpt, darkTheme) {
    var url;
    var filename = "../images/icon-";
    if (isWpt) {
        filename += "waypt-";
    }
    else {
        filename += "cache-";
    }
    if (darkTheme) {
        filename += "white.svg";
    }
    else {
        filename += "black.svg";
    }
    url = Qt.resolvedUrl(filename)
    return url
}

/*
*  Building up an button text
*/
function wayptFoundButton(isWpt, isFound) {
    //qsTr("Mark waypoint as Found")
    var text = qsTr("Mark ");
    if (isWpt) {
        text += qsTr("waypoint as ");
    }
    else {
        text += qsTr("geocache as ");
    }
    if (isFound) {
        text += qsTr("Not Found");
    }
    else {
        text += qsTr("Found");
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

/*
*  Function to evaluate a formula
*/
function evalFormula( formstr, letters ) {
//    var formula = JSON.parse(formjson);
    var formula = formulaToObj(formstr);
    var result = "";

    for (var i = 0; i < formula.length; i++) {
        if (formula[i].eval) {
            var str = formula[i].part;
            for (var j = 0; j < letters.length; j++) {
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
        result += letters[j].letter + " = " + letters[j].lettervalue + "\n";
        if (letters[j].lettervalue !== "") {
            checksum += Number(letters[j].lettervalue);
        }
    }
    result += "Checksum = " + checksum;
    return result
}
