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
.import QtQuick 2.0 as QtQuick
.import QtQuick.LocalStorage 2.0 as DB

var databaseHandler = null;
var cleanRecs = false;

function openDatabase() {
    if (databaseHandler === null)
    {
        try {
            databaseHandler = DB.LocalStorage.openDatabaseSync(
                                "gmfs-db", "0.1",
                                "GMFS Database", 1000000);
    //        upgradeDatabase();
            cleanTablesRecs();
            initializeDatabase();
            if (generic.deleteDatabase) {
                generic.deleteDatabase = false
                setSetting( "deleteDatabase", generic.deleteDatabase )
            }
        } catch (err) {
            console.log("initDatabase " + err);
        };    }
    return databaseHandler;
}

function cleanTablesRecs() {
    var db = openDatabase();

    db.transaction(function(tx) {
        if (generic.deleteDatabase) {
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
        else {
            if (cleanRecs) {
                tx.executeSql("\
                    DELETE FROM geocaches \
                        WHERE 1 \
                    ;");
                tx.executeSql("\
                    DELETE FROM geo_waypts \
                        WHERE 1 \
                    ;");
                tx.executeSql("\
                    DELETE FROM geo_letters \
                        WHERE 1 \
                    ;");
            }
        }
    });
}

function initializeDatabase()
{
    var db = openDatabase();

    db.transaction(function(tx) {
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

        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS geocaches ( \
                cacheid INTEGER PRIMARY KEY, \
                geocache TEXT UNIQUE, \
                name TEXT NOT NULL, \
                found INTEGER DEFAULT 0, \
                updatd DATETIME DEFAULT CURRENT_TIMESTAMP \
            );");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS found ON geocaches ( \
                found, \
                updatd \
            );");

        /*
         * Set up waypoints.
         */
        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS geo_waypts ( \
                wayptid INTEGER PRIMARY KEY, \
                cacheid INTEGER NOT NULL, \
                waypoint INTEGER NOT NULL, \
                formula TEXT NOT NULL, \
                note TEXT NOT NULL, \
                is_waypoint INTEGER DEFAULT 0, \
                found INTEGER DEFAULT 0
            )");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS waypt ON geo_waypts ( \
                cacheid, \
                waypoint \
            );");

        /*
         * Set up letters.
         */
        tx.executeSql("\
            CREATE TABLE IF NOT EXISTS geo_letters ( \
                letterid INTEGER PRIMARY KEY, \
                wayptid INTEGER NOT NULL, \
                cacheid INTEGER NOT NULL, \
                letter TEXT NOT NULL, \
                lettervalue TEXT DEFAULT '' \
            )");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS cache_letter ON geo_letters ( \
                cacheid, \
                letter \
            );");
        tx.executeSql("\
            CREATE INDEX IF NOT EXISTS waypt_letter ON geo_letters ( \
                wayptid, \
                letter \
            );");
        if (cleanRecs) {
            tx.executeSql("\
                DELETE FROM geo_letters \
                    WHERE 1 \
                ;");
        }

    });
}

/*
 * All records.
 */
function getGeocaches()
{
    var caches = [];
    var db = openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT geocache, \
                name, \
                cacheid, \
                found \
                FROM geocaches \
                ORDER BY found ASC, updatd DESC \
            ;");
        for (var i = 0; i < rs.rows.length; ++i) {
            caches.push(rs.rows.item(i));
        }
    });

    return caches;
}

function getWaypts(cacheid)
{
    var waypts = [];
    var db = openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT cacheid, \
                wayptid, \
                waypoint, \
                formula, \
                note, \
                is_waypoint, \
                found \
                FROM geo_waypts \
                WHERE cacheid=? \
                ORDER BY cacheid, waypoint \
            ;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            waypts.push(rs.rows.item(i));
        }
    });

    return waypts;
}

function getLettersWP(wayptid)
{
    var letters = [];
    var db = openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT cacheid, \
                wayptid, \
                letterid, \
                letter, \
                ifnull(lettervalue, '') AS lettervalue \
                FROM geo_letters \
                WHERE wayptid=? \
                ORDER BY letter \
            ;", [wayptid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            letters.push(rs.rows.item(i));
        }
    });

    return letters;
}

function getLetters(cacheid)
{
    var letters = [];
    var db = openDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql("\
            SELECT letter, \
                ifnull(lettervalue, '') AS lettervalue \
                FROM geo_letters \
                WHERE cacheid=? \
                ORDER BY letter \
            ;", [cacheid]);
        for (var i = 0; i < rs.rows.length; ++i) {
            letters.push(rs.rows.item(i));
        }
    });

    return letters;
}

/*
 * Adds a new geocache.
 */
function addCache(geocache, name, found)
{
    var db = openDatabase();
    db.transaction(function (tx) {
        var invoiceId = tx.executeSql("INSERT INTO geocaches (at, shop) VALUES (?, ?)", [date.getTime() / 1000, shop.id]).insertId;
        for (var i = 0; i < items.length; ++i) {
            var itemId = tx.executeSql("INSERT INTO invoice_items (invoice, category, price, currency, pri_price) VALUES (?, ?, ?, ?, ?)",
                                       [invoiceId, items[i].category.id, items[i].price, getPrimaryCurrency().id, items[i].price]).insertId;
        }
    });
}

function addStdCache()
{
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

    var db = openDatabase();

    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT OR REPLACE INTO geocaches (geocache, name, found) VALUES (?,?,?);", [geocache,name,found]);
        console.log(JSON.stringify(rs));
        var cacheId = rs.insertId;
        console.log(cacheId);
        for (var i = 0; i < defaultWpts.length; ++i) {
            var lt = defaultWpts[i].letters;
            rs = tx.executeSql("INSERT OR REPLACE INTO geo_waypts (cacheid, waypoint, formula, note, is_waypoint, found) VALUES (?,?,?,?,?,?);", [cacheId, defaultWpts[i].waypt, defaultWpts[i].formula, defaultWpts[i].note, defaultWpts[i].is_waypt, defaultWpts[i].found]);
            var wayptId = rs.insertId;
            for (var j = 0; j < lt.length; ++j) {
                tx.executeSql("INSERT OR REPLACE INTO geo_letters (wayptid, cacheid, letter) VALUES (?,?,?);", [wayptId, cacheId, lt[j]]);
            }
        }

    });
    return 1
}

function addStd2Cache()
{
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

    var db = openDatabase();

    db.transaction(function(tx) {
        var rs = tx.executeSql("INSERT OR REPLACE INTO geocaches (geocache, name, found) VALUES (?,?,?);", [geocache,name,found]);
        console.log(JSON.stringify(rs));
        var cacheId = rs.insertId;
        console.log("Cache" + cacheId);
        for (var i = 0; i < defaultWpts.length; ++i) {
            var lt = defaultWpts[i].letters;
            rs = tx.executeSql("INSERT OR REPLACE INTO geo_waypts (cacheid, waypoint, formula, note, is_waypoint, found) VALUES (?,?,?,?,?,?);", [cacheId, defaultWpts[i].waypt, defaultWpts[i].formula, defaultWpts[i].note, defaultWpts[i].is_waypt, defaultWpts[i].found]);
            var wayptId = rs.insertId;
            console.log(cacheId + " WP " + wayptId);
            for (var j = 0; j < lt.length; ++j) {
                tx.executeSql("INSERT OR REPLACE INTO geo_letters (wayptid, cacheid, letter) VALUES (?,?,?);", [wayptId, cacheId, lt[j]]);
                console.log("Letter " + lt[j]);
            }
        }

    });
    return 1
}

function setCache(geocache, name, found, waypts, vals)
{
    var db = openDatabase();
    var res = "";
    db.transaction(function(tx) {
        tx.executeSql(createTableGeocaches);
        var rs = tx.executeSql('INSERT OR REPLACE INTO geocaches VALUES (?,?,?,?,?);', [geocache,name,found,waypts,vals]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    } )
    return res;
}

function setCacheFound(id, found)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('\
            UPDATE geocaches \
            SET found = ? \
            WHERE cacheid = ?;', [id,found]);
    } )
}
function setWayptFound(id, found)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('\
            UPDATE geo_waypts \
            SET found = ? \
            WHERE wayptid = ?;', [id,found]);
    } )
}
function setLetter(letter, value)
{
    var db = openDatabase();
    db.transaction(function(tx) {
        tx.executeSql('\
            UPDATE geo_letters \
            SET lettervalue = ? \
            WHERE letter = ?;', [value,letter]);
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

