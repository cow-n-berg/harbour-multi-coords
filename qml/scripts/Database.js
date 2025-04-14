/*
 * Copyright (C) 2015 Markus Mayr <markus.mayr@outlook.com>
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
.import QtQuick.LocalStorage 2.0 as DB
.import "TextFunctions.js" as TF

var databaseHandler = null;
var deleteDatabase
var databaseVersion = ""

function openDatabase( dbversion ) {
    // optional parameter
    console.log("openDatabase started");
    if (dbversion === null) {
        dbversion = databaseVersion
    }
    else {
        databaseVersion = dbversion
    }

    if (databaseHandler === null)
    {
        try {
            databaseHandler = DB.LocalStorage.openDatabaseSync(
                                "gmfs-db", "",
                                "GMFS Database", 1000000);
            cleanTablesRecs();
            if (deleteDatabase) {
                deleteDatabase = false
                setSetting( "deleteDatabase", deleteDatabase )
            }

            initializeDatabase( databaseHandler );
            upgradeDatabase(dbversion);
        } catch (err) {
            console.log("initDatabase " + err);
        };    }
    return databaseHandler;
}

function cleanTablesRecs() {

    deleteDatabase = getSetting( "deleteDatabase" );

    console.log("cleanTablesRecs ");
    var db = databaseHandler || openDatabase();

    db.transaction(function(tx) {
        if (deleteDatabase) {
            tx.executeSql("\
                DROP TABLE IF EXISTS \
                    geocaches \
                ;");
            tx.executeSql("\
                DROP TABLE IF EXISTS \
                    geo_waypts \
                ;");
            tx.executeSql("\
                DROP TABLE IF EXISTS \
                    geo_letters \
                ;");
        }
    });
}

function initializeDatabase( dbH ) {
    var db = dbH || openDatabase();
    console.log("initializeDatabase started");
    if (typeof db.version !== "string" )
        db.version = "0.0";

    db.transaction(function(tx) {

        tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', ["databaseVersion",db.version]);

        /*
         * Set up settings.
         */
        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS settings ( \
                setting TEXT PRIMARY KEY, \
                value INTEGER NOT NULL \
            );");

        /*
         * Set up geocaches.
         */

        console.log("Set up geocaches");
        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS geocaches ( \
                cacheid INTEGER PRIMARY KEY, \
                geocache TEXT UNIQUE, \
                name TEXT NOT NULL, \
                description TEXT NOT NULL DEFAULT '', \
                attributes TEXT NOT NULL DEFAULT '', \
                hint TEXT NOT NULL DEFAULT '', \
                found INTEGER DEFAULT 0, \
                updatd DATETIME DEFAULT CURRENT_TIMESTAMP, \
                active INTEGER DEFAULT 0 \
            );");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS found ON geocaches ( \
                found, \
                updatd \
            );");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS active ON geocaches ( \
                active, \
                found, \
                name \
            );");

        /*
         * Set up waypoints.
         */
        console.log("Set up waypoints");
        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS geo_waypts ( \
                wayptid INTEGER PRIMARY KEY, \
                cacheid INTEGER NOT NULL, \
                waypoint INTEGER NOT NULL, \
                rawtext TEXT DEFAULT '', \
                formula TEXT NOT NULL, \
                note TEXT DEFAULT '', \
                is_waypoint INTEGER DEFAULT 1, \
                found INTEGER DEFAULT 0 \
            )");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS waypt ON geo_waypts ( \
                cacheid, \
                waypoint \
            );");

        /*
         * Set up letters.
         */
        console.log("Set up letters");
        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS geo_letters ( \
                letterid INTEGER PRIMARY KEY, \
                wayptid INTEGER NOT NULL, \
                cacheid INTEGER NOT NULL, \
                letter TEXT NOT NULL, \
                lettervalue TEXT DEFAULT '', \
                remark TEXT DEFAULT ''  \
            )");
        tx.executeSql("\
            CREATE UNIQUE INDEX IF NOT EXISTS cache_letter ON geo_letters ( \
                cacheid, \
                letter \
            );");
        tx.executeSql("\
            CREATE UNIQUE INDEX IF NOT EXISTS waypt_letter ON geo_letters ( \
                wayptid, \
                letter \
            );");

    });
    console.log("initialization completed");
}

/*
 * Handles updates of old databases.
 */
function upgradeDatabase( dbversion )
{
    console.log("upgradeDatabase ");
    var db = databaseHandler || openDatabase();
    var rs;

    console.log("Current version: " + db.version + ", New version: " + dbversion);
    if (db.version < dbversion )
    {
        db.changeVersion(db.version, dbversion, function (tx) {
            if (db.version < "1.0") {
                /*
                 * Enables remarks with geo_letters, and a (formula) rawtext with geo_waypts.
                 */
                rs = tx.executeSql("ALTER TABLE geo_waypts ADD COLUMN rawtext TEXT DEFAULT ''");
                console.log(rs);
                rs = tx.executeSql("ALTER TABLE geo_letters ADD COLUMN remark TEXT DEFAULT ''");
                console.log(rs);
                console.log("Tables altered 1.0");
                db.version = "1.0";
            }
            if (db.version < "1.2") {
                /*
                 * Enables remarks with geo_letters, and a (formula) rawtext with geo_waypts.
                 */
                rs = tx.executeSql("DROP INDEX IF EXISTS cache_letter;");
                rs = tx.executeSql("DROP INDEX IF EXISTS waypt_letter;");
                tx.executeSql("\
                    CREATE UNIQUE INDEX IF NOT EXISTS cache_letter ON geo_letters ( \
                        cacheid, \
                        letter \
                    );");
                tx.executeSql("\
                    CREATE UNIQUE INDEX IF NOT EXISTS waypt_letter ON geo_letters ( \
                        wayptid, \
                        letter \
                    );");
                db.version = "1.2";
                console.log("Tables altered 1.2");
            }
            // Version 1.3 and 1.4 got lost in upgrade problems
            if (db.version < "1.5") {
                /*
                 * Adds new column to geocaches.
                 */
                rs = tx.executeSql("ALTER TABLE geocaches ADD COLUMN active INTEGER DEFAULT 0");
                console.log(rs);
                rs = tx.executeSql("\
                    CREATE INDEX active ON geocaches ( \
                        active, \
                        found, \
                        name \
                    );");
                console.log(rs);
                db.version = "1.5";
                rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', ["databaseVersion",15]);
                console.log("Tables altered " + db.version);
            }
            if (db.version < "1.6") {
                /*
                 * Adds new column to geocaches.
                 */
                rs = tx.executeSql("ALTER TABLE geocaches ADD COLUMN active INTEGER DEFAULT ''");
                console.log(rs);
                db.version = "1.6";
                rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', ["databaseVersion",20]);
                console.log("Tables altered " + db.version);
            }
            if (db.version < "2.0") {
                /*
                 * Adds new columns to geocaches.
                 */
                rs = tx.executeSql("ALTER TABLE geocaches ADD COLUMN description TEXT NOT NULL DEFAULT ''");
                console.log(rs);
                rs = tx.executeSql("ALTER TABLE geocaches ADD COLUMN attributes TEXT NOT NULL DEFAULT ''");
                console.log(rs);
                rs = tx.executeSql("ALTER TABLE geocaches ADD COLUMN hint TEXT NOT NULL DEFAULT ''");
                console.log(rs);
                db.version = "2.0";
                rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', ["databaseVersion",16]);
                console.log("Tables altered " + db.version);
            }
            /*
             * Upgrade complete.
             */
        });
    }
}

/*
 * All records.
 */
function getGeocaches(hideFound) {
    var caches = [];
    console.log("getGeocaches ");
    var db = databaseHandler || openDatabase();
    if (hideFound) {
        db.transaction(function(tx) {
            var rs = tx.executeSql("\
                SELECT cacheid, \
                    geocache, \
                    name, \
                    found \
                    FROM geocaches \
                    WHERE found = 0 \
                    OR active = 1 \
                    ORDER BY active DESC, found ASC, name ASC \
                ;");
            for (var i = 0; i < rs.rows.length; ++i) {
                caches.push(rs.rows.item(i));
            }
        });
    }
    else {
        db.transaction(function(tx) {
            var rs = tx.executeSql("\
                SELECT cacheid, \
                    geocache, \
                    name, \
                    found \
                    FROM geocaches \
                    ORDER BY active DESC, found ASC, name ASC \
                ;");
            for (var i = 0; i < rs.rows.length; ++i) {
                caches.push(rs.rows.item(i));
            }
        });
    }

    return caches;
}

function getDescription(cacheid) {
    var str  = qsTr("No description saved to this geocache");
    var list = [];
    console.log("getDescription ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT description \
                FROM geocaches \
                WHERE cacheid = ?;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            list.push(rs.rows.item(i));
        }
    });
    if (list.length === 0) {
        list.push( { description: str } );
    }
    return list;
}

function getAttributes(cacheid) {

    var str  = qsTr("No attributes saved to this geocache");
    var rec  = { attribute: str };
    var list = [];
    console.log("getAttributes ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT attributes \
                FROM geocaches \
                WHERE cacheid = ?;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            list.push(rs.rows.item(i));
        }
    });
    if (list.length === 0) {
        list.push( JSON.stringify(rec) );
    }
    return list;
}

function getHint(cacheid) {
    var str  = qsTr("No hint saved to this geocache");
    var list = [];
    console.log("getHint ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT hint \
                FROM geocaches \
                WHERE cacheid = ?;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            list.push(rs.rows.item(i));
        }
    });
    if (list.length === 0) {
        list.push( { hint: str } );
    }
    return str;
}

function getWaypts(cacheid, hideFound) {
    var waypts = [];
    console.log("getWaypts ");
    var db = databaseHandler || openDatabase();
    var i;

    db.transaction(function(tx) {
        tx.executeSql('\
                UPDATE geocaches \
                SET active = 0 \
                WHERE active = 1;');
        tx.executeSql('\
            UPDATE geocaches \
            SET active = 1 \
            WHERE cacheid = ? \
            ;', [cacheid]);
    });

    if (hideFound) {
        db.transaction(function(tx) {
            var rs = tx.executeSql("\
                SELECT cacheid, \
                    wayptid, \
                    waypoint, \
                    formula, \
                    '' AS calculated, \
                    note, \
                    is_waypoint, \
                    found \
                FROM geo_waypts \
                WHERE cacheid = ? \
                  AND found = 0\
                ORDER BY cacheid, waypoint \
                ;", [cacheid]);
            for (i = 0; i < rs.rows.length; ++i) {
                waypts.push(rs.rows.item(i));
            }
        });
    }
    else {
        db.transaction(function(tx) {
            var rs = tx.executeSql("\
                SELECT cacheid, \
                    wayptid, \
                    waypoint, \
                    formula, \
                    '' AS calculated, \
                    note, \
                    is_waypoint, \
                    found \
                    FROM geo_waypts \
                    WHERE cacheid = ? \
                    ORDER BY cacheid, waypoint \
                ;", [cacheid]);
            for (i = 0; i < rs.rows.length; ++i) {
                waypts.push(rs.rows.item(i));
            }
        });
    }
    var allLetters = getLetters(cacheid);
    for (i = 0; i < waypts.length; ++i) {
        waypts[i].calculated = TF.evalFormula(waypts[i].formula, allLetters) ;
    }
    console.log(JSON.stringify(waypts));
    return waypts;
}

function getLetters(cacheid) {
    var letters = [];
    console.log("getLetters ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT * \
                FROM geo_letters \
                WHERE cacheid = ? \
                ORDER BY letter \
            ;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            letters.push(rs.rows.item(i));
        }
    });
    console.log(JSON.stringify(letters));
    return letters;
}

function getLettersWP(wayptid) {
    var letters = [];
    console.log("getLettersWP ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT * \
                FROM geo_letters \
                WHERE wayptid = ? \
                ORDER BY letter \
            ;", [wayptid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            letters.push(rs.rows.item(i));
        }
    });

    return letters;
}

function allLettersWpFound(wayptid) {
    var found = true;
    console.log("allLettersWpFound ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT COUNT(*) AS nr \
                FROM geo_letters \
                WHERE wayptid = ? \
                AND lettervalue = '' \
            ;", [wayptid]);
        if (rs.rows.item(0).nr === 1)
            found = false;
    });

    return found;
}

function getOneWaypt(wayptid) {
    var waypt
    console.log("getOneWaypt ");
    var db = databaseHandler || openDatabase();
    var letters = []
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT waypoint, \
                rawtext, \
                formula, \
                note, \
                is_waypoint, \
                found \
                FROM geo_waypts \
                WHERE wayptid = ? \
            ;", [wayptid]);
        waypt = { waypoint  : rs.rows.item(0).waypoint,
                  rawtext   : rs.rows.item(0).rawtext,
                  formula   : rs.rows.item(0).formula,
                  note      : rs.rows.item(0).note,
                  iswp      : rs.rows.item(0).is_waypoint,
                  found     : rs.rows.item(0).found,
                  letterstr : undefined,
                  letters   : undefined };
        rs = tx.executeSql("\
            SELECT letterid, \
                letter,\
                lettervalue \
                FROM geo_letters \
                WHERE wayptid = ? \
                ORDER BY letter \
            ;", [wayptid]);
        var str = "";
        for (var i = 0; i < rs.rows.length; ++i) {
            str += (rs.rows.item(i).letter) + " ";
            letters.push(rs.rows.item(i));
        }
        waypt.letterstr = str.trim();
        waypt.letters = letters;
//        console.log(JSON.stringify(waypt));
    });

    return waypt;

}

function getOneLetter(letterid) {
    var letters = [];
    console.log("getOneLetter ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT letter, \
                lettervalue, \
                remark \
                FROM geo_letters \
                WHERE letterid = ? \
            ;", [letterid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            letters.push(rs.rows.item(i));
        }
    });

    return letters;
}

function showAllData() {
    var rs
    console.log("showAllData ");
    var db = databaseHandler || openDatabase();

    db.transaction(function(tx) {
        rs = tx.executeSql("\
            SELECT * \
                FROM geocaches \
                ORDER BY found ASC, updatd DESC \
            ;");
        for (var i = 0; i < rs.rows.length; ++i) {
            console.log(JSON.stringify(rs.rows.item(i)));
        }
    });

    console.log("Waypoints");
    db.transaction(function(tx) {
        rs = tx.executeSql("\
            SELECT * \
                FROM geo_waypts \
                ORDER BY cacheid, waypoint \
            ;");
        for (var i = 0; i < rs.rows.length; ++i) {
            console.log(JSON.stringify(rs.rows.item(i)));
        }
    });

    console.log("Letters");
    db.transaction(function(tx) {
        rs = tx.executeSql("\
            SELECT * \
                FROM geo_letters \
                ORDER BY cacheid, letter \
            ;");
        for (var i = 0; i < rs.rows.length; ++i) {
            console.log(JSON.stringify(rs.rows.item(i)));
        }
    });

    return 1
}

/*
*  Function to show all waypoints and letters
*/
function showCacheLetters( cacheid ) {
    var result = "";
    var oldWpt = "";
    console.log("showCacheLetters ");
    var db = databaseHandler || openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT w.waypoint, \
                l.letter \
                FROM geo_waypts AS w
                INNER JOIN geo_letters AS l ON w.wayptid = l.wayptid\
                WHERE w.cacheid=? \
                ORDER BY w.waypoint, l.letter \
            ;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            if (rs.rows.item(i).waypoint === oldWpt) {
                result += ", '" + rs.rows.item(i).letter + "'";
            }
            else {
                oldWpt = rs.rows.item(i).waypoint;
                result += (i === 0 ? "" : "\n") + "WP " + oldWpt + qsTr(", requires: '") + rs.rows.item(i).letter + "'";
            }
        }
    });
    return result
}

/*
 * Adds a new geocache.
 */
function addStd1Cache() {
    var geocache = 'GC3A7RC';
    var name = 'where it started';
    var found = false;
    var defaultWpts =
        [
            { waypt: "1", is_waypt: "1", found: "0", formula: "N 47 36.600 W 122 20.555",                 letters: ["A", "B"], note: "green wooden boards = A, bolts under awning = B" },
            { waypt: "2", is_waypt: "1", found: "0", formula: "N 47 36.[580+A] W 122 20.[507+B]",         letters: ["C", "D"], note: "red seat holes (even) = C and green seat holes (odd) = D" },
            { waypt: "3", is_waypt: "1", found: "0", formula: "N 47 36.[547+C] W 122 20.[494+D]",         letters: ["E", "F"], note: "number of letters in the first word = E and the second word = F, both are even numbers" },
            { waypt: "4", is_waypt: "0", found: "0", formula: "N 47 36.[589+A+B+C] W 122 20.[542+D+E+F]", letters: [],         note: "PLEASE WATCH OUT FOR MUGGLES" }
        ];

    console.log("addStd1Cache ");
    var db = databaseHandler || openDatabase();

    db.transaction(function(tx) {
        var rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geocaches \
                    (geocache, name, found) \
                    VALUES (?,?,?);", [geocache,name,found]);
        console.log(JSON.stringify(rs));
        var cacheId = rs.insertId;
        console.log(cacheId);
        for (var i = 0; i < defaultWpts.length; ++i) {
            var lt = defaultWpts[i].letters;
            rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geo_waypts \
                    (cacheid, waypoint, formula, rawtext, note, is_waypoint, found) \
                    VALUES (?,?,?,?,?,?,?);", [cacheId, defaultWpts[i].waypt, defaultWpts[i].formula, defaultWpts[i].formula, defaultWpts[i].note, defaultWpts[i].is_waypt, defaultWpts[i].found]);
            var wayptId = rs.insertId;
            for (var j = 0; j < lt.length; ++j) {
                tx.executeSql("\
                    INSERT OR REPLACE INTO geo_letters \
                    (wayptid, cacheid, letter) \
                    VALUES (?,?,?);", [wayptId, cacheId, lt[j]]);
            }
        }
    });
    return 1
}

function addStd2Cache() {
    var geocache = 'GC83QV1';
    var name = 'Het Utrechts zonnestelsel (op zoek naar Pluto)';
    var found = false;
    var defaultWpts =
        [
            { waypt: "0", is_waypt: "1", found: "0", formula: "N 52 05.417 E 005 07.330",              letters: [],    note: "De Zon." },
            { waypt: "1", is_waypt: "1", found: "0", formula: "58 mln. km / 58 meter",                 letters: ["A"], note: "Mercurius. Welke letter komt hier op beide blauwe bordjes voor? Neem de letterwaarde. = A" },
            { waypt: "2", is_waypt: "1", found: "0", formula: "108 mln. km / 108 meter",               letters: ["B"], note: "Venus. Neem hier het huisnummer. = B" },
            { waypt: "3", is_waypt: "1", found: "0", formula: "150 mln. km / 150 meter",               letters: ["C"], note: "Aarde/maan. Neem het nummer van de 'Pijke Koch' (zwarte lantaarnpaal). = C" },
            { waypt: "4", is_waypt: "1", found: "0", formula: "228 mln. km / 228 meter",               letters: ["D"], note: "Mars. Hoeveel maagden worden hier genoemd (stapeltellen)? = D" },
            { waypt: "5", is_waypt: "1", found: "0", formula: "778 mln. km / 778 meter",               letters: ["E"], note: "Jupiter. Wie verzorgt hier de verwarming (even teruglopen naar de NW hoek vanaf Jupiter)? Het aantal letters. = E" },
            { waypt: "6", is_waypt: "1", found: "0", formula: "1427 mln. km / 1427 meter",             letters: ["F"], note: "Saturnus. Met hoeveel grote bouten zit het stootblok op het ijzer vast? = F" },
            { waypt: "7", is_waypt: "1", found: "0", formula: "2871 mln. km / 2871 meter",             letters: ["G"], note: "Uranus. Hoeveel lampen zitten er ter hoogte van Uranus naast het fietspad onder de brug? =G" },
            { waypt: "8", is_waypt: "1", found: "0", formula: "4498 mln. km / 4498 meter",             letters: ["H"], note: "Neptunus. Aan de overkant van het water zie je een zwarte letter op een geel bord. Neem de letterwaarde (stapeltellen). = H" },
            { waypt: "9", is_waypt: "0", found: "0", formula: "N52 0[A+3].[B-9][C-8][D-2] E005 1[E-4].[F+2][G-1][H-5]", letters: [], note: " " }
        ];

    console.log("AddStd2Cache ");
    var db = databaseHandler || openDatabase();

    db.transaction(function(tx) {
        var rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geocaches \
                    (geocache, name, found) \
                    VALUES (?,?,?);", [geocache,name,found]);
        console.log(JSON.stringify(rs));
        var cacheId = rs.insertId;
        console.log(cacheId);
        for (var i = 0; i < defaultWpts.length; ++i) {
            var lt = defaultWpts[i].letters;
            rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geo_waypts \
                    (cacheid, waypoint, formula, rawtext, note, is_waypoint, found) \
                    VALUES (?,?,?,?,?,?,?);", [cacheId, defaultWpts[i].waypt, defaultWpts[i].formula, defaultWpts[i].formula, defaultWpts[i].note, defaultWpts[i].is_waypt, defaultWpts[i].found]);
            var wayptId = rs.insertId;
            for (var j = 0; j < lt.length; ++j) {
                tx.executeSql("\
                    INSERT OR REPLACE INTO geo_letters \
                    (wayptid, cacheid, letter) \
                    VALUES (?,?,?);", [wayptId, cacheId, lt[j]]);
            }
        }
    });
    return 1
}

function addCache(geocache, name, waypts)
{
    console.log("addCache ");
    var db = databaseHandler || openDatabase();
    var rs;
    console.log(JSON.stringify(waypts))
    db.transaction(function(tx) {
        tx.executeSql('\
                UPDATE geocaches \
                SET active = 0 \
                WHERE active = 1;');
        rs = tx.executeSql('\
                INSERT OR REPLACE INTO geocaches \
                (geocache, name, found, active) \
                VALUES (?,?,0,1);', [geocache,name]);
        var cacheId = rs.insertId;
        console.log("Geocache inserted, id=" + cacheId);
        for (var i = 0; i < waypts.length; ++i) {
            console.log("WP: " + JSON.stringify(waypts[i]));
            var number  = waypts[i].number;
            var formula = waypts[i].coord;
            var note    = waypts[i].note;
            var raw     = waypts[i].raw;
            if (note === "") {
                rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geo_waypts \
                    (cacheid, waypoint, formula, rawtext, note, is_waypoint, found) \
                    VALUES (?,?,?,?,'',1,0);", [cacheId, number, formula, raw]);
            }
            else {
                rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geo_waypts \
                    (cacheid, waypoint, formula, rawtext, note, is_waypoint, found) \
                    VALUES (?,?,?,?,?,1,0);", [cacheId, number, formula, raw, note]);
                }
            var wayptId = rs.insertId;
            console.log(cacheId + " WP " + wayptId);
        }

    } );
    return 1;
}

function addWaypt(cacheid, wpid, number, formula, rawtext, note, is_waypoint, is_found, letters)
{
    var db = openDatabase();
    var rs, i, j;
    var wayptId = wpid || "";

    var nr = parseInt(number);
    var iswp  = is_waypoint ? 1 : 0;
    var found = is_found    ? 1 : 0;
    var letterstr = "";
    var currLett = [];

    db.transaction(function(tx) {
        // Save waypoint
        rs = tx.executeSql("\
            INSERT OR REPLACE INTO geo_waypts \
            (cacheid, wayptid, waypoint, formula, rawtext, note, is_waypoint, found) \
            VALUES (?,?,?,?,?,?,?,?);", [cacheid, wayptId, nr, formula, rawtext, note, iswp, found]);
        wayptId = rs.insertId;
        console.log("Waypoint inserted, id=" + wayptId);

        // Format of letters is 'A B C DEF', to be splitted by space
        var arrLett = letters.split(" ");
        if (arrLett.length === 0) {
            arrLett = [letters];
        }

        // Let's see what letters we have right now at this waypoint
        rs = tx.executeSql("\
            SELECT * \
                FROM geo_letters \
                WHERE wayptid = ? \
                ORDER BY letter \
            ;", [wayptId]);
        for (i = 0; i < rs.rows.length; ++i) {
            currLett.push(rs.rows.item(i));
        }

        // Match existing records with newly entered letters
        for (i = 0; i < currLett.length; ++i) {
            var foundLett = false;
            for (j = 0; j < arrLett.length; ++j) {
                if (currLett[i].letter === arrLett[j]) {
                    foundLett = true;
                    // Existing record, so new insert isnot appropriate
                    arrLett[j] = "";
                }
            }
            if (!foundLett) {
                // Fill 'letterstr' as preparation for deletion from geo-letters
                letterstr += (letterstr.length === 0 ? "" : ",") + currLett[i].letter;
            }
        }

        // Inserting letters into geo_letters
        for (i = 0; i < arrLett.length; ++i) {
            if (arrLett[i]) {
                rs = tx.executeSql("\
                    INSERT OR REPLACE INTO geo_letters \
                    (cacheid, wayptid, letter) \
                    VALUES (?,?,?);", [cacheid, wayptId, arrLett[i]]);
                var lettId = rs.insertId;
            }
        }

        // Deleting superfluous letters
        console.log("Delete from letters, not in: " + letterstr)
        rs = tx.executeSql("\
            DELETE FROM geo_letters \
            WHERE cacheid = ? \
              AND wayptid = ? \
              AND letter IN (?);", [cacheid, wayptId, letterstr]);
        console.log(JSON.stringify(rs));
    } );
    return 1;
}

function addLetters(cacheid, wpid, letters) {
}

function setCacheFound(cacheid, found)
{
    var sqlFound = found ? 1 : 0
    var db = openDatabase();
    var rs;
    db.transaction(function(tx) {
        rs = tx.executeSql('\
            UPDATE geocaches \
            SET found = ?, \
                updatd = CURRENT_TIMESTAMP, \
                active = 1 \
            WHERE cacheid = ?;', [sqlFound,cacheid]);
    } )
}

function setWayptFound(cacheid, wayptid, found)
{
    var sqlFound = found ? 1 : 0
    var db = openDatabase();
    var rs;
    db.transaction(function(tx) {
        rs = tx.executeSql('\
            UPDATE geocaches \
            SET updatd = CURRENT_TIMESTAMP \
            WHERE cacheid = ?;', [cacheid]);
        rs = tx.executeSql('\
            UPDATE geo_waypts \
            SET found = ? \
            WHERE wayptid = ?;', [sqlFound,wayptid]);
        rs = tx.executeSql('\
            SELECT * FROM geo_waypts \
            WHERE cacheid = ?;', [cacheid]);
    } )
}

function setLetter(cacheid, wayptId, letterid, letter, value, remark)
{
    var valuestr = value.toString();
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql("\
            UPDATE geo_letters \
            SET lettervalue = ?,
                remark = ? \
            WHERE letterid = ? \
        ;", [value,remark,letterid]);
    } )
}

function deleteCache(cacheid)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql("\
            DELETE FROM geocaches \
                WHERE cacheid=? \
            ;", [cacheid]);
        tx.executeSql("\
            DELETE FROM geo_waypts \
                WHERE cacheid=? \
            ;", [cacheid]);
        tx.executeSql("\
            DELETE FROM geo_letters \
                WHERE cacheid=? \
            ;", [cacheid]);
    });

    return 1;
}

function deleteWaypt(wayptid, cacheid)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('\
            UPDATE geocaches \
            SET updatd = CURRENT_TIMESTAMP \
            WHERE cacheid = ?;', [cacheid]);
        tx.executeSql("\
            DELETE FROM geo_waypts \
                WHERE wayptid=? \
            ;", [wayptid]);
        tx.executeSql("\
            DELETE FROM geo_letters \
                WHERE wayptid=? \
            ;", [wayptid]);
    });

    return 1;
}

function deleteLetters(wayptid)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql("\
            DELETE FROM geo_letters \
                WHERE wayptid=? \
            ;", [wayptid]);
    });

    return 1;
}

function clearValues(cacheid)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql("\
            UPDATE geo_letters \
                SET lettervalue = '',
                    remark = '' \
                WHERE cacheid=? \
            ;", [cacheid]);
    });

    return 1;
}

function getSetting(setting, default_value)
{
    var db = openDatabase();
    var res="";
    try {
        db.transaction(function(tx) {
        var rs = tx.executeSql("SELECT value FROM settings WHERE setting=?;", [setting]);
        if (rs.rows.length > 0) {
            res = rs.rows.item(0).value;
        } else {
            res = default_value;
        }
        })
    } catch (err) {
        console.log("Database " + err);
        res = default_value;
    };
    return res
}

function setSetting(setting, value)
{
    var db = openDatabase();
    var res = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [setting,value]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    } )
    return res;
}

