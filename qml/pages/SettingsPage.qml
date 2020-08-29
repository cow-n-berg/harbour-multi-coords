import QtQuick 2.0
import Sailfish.Silica 1.0
import "../scripts/Database.js" as Database
import "../scripts/TextFunctions.js" as TF

Dialog {

    property var cache1Adding : false
    property var cache2Adding : false

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Settings" )
        }

        IconTextSwitch {
            text: qsTr("Show app name on cover")
            description: qsTr("'GMFS' for better recognition of app tiles")
            icon.source: "image://theme/icon-m-about"
            checked: generic.coverShowAppName
            onClicked: generic.coverShowAppName = !generic.coverShowAppName
        }

        SectionHeader {
            text: qsTr("Database actions")
        }

        IconTextSwitch {
            text: qsTr("Clear database next start-up")
            description: qsTr("Will be executed only once")
            icon.source: "image://theme/icon-m-levels"
            checked: generic.deleteDatabase
            onClicked: generic.deleteDatabase = !generic.deleteDatabase
        }

        IconTextSwitch {
            text: qsTr("(Re-)create Multi GC3A7RC")
            description: qsTr("'where it started' from Seattle. It may only be visible after restarting the app.")
            icon.source: "image://theme/icon-m-location"
            checked: cache1Adding
            onClicked: cache1Adding = !cache1Adding
        }

        IconTextSwitch {
            text: qsTr("(Re-)create Multi GC83QV1")
            description: qsTr("'Het Utrechts zonnestelsel...' from The Netherlands. It may only be visible after restarting the app.")
            icon.source: "image://theme/icon-m-location"
            checked: cache2Adding
            onClicked: cache2Adding = !cache2Adding
        }

    }

    onDone: {
        if (result == DialogResult.Accepted) {
            Database.setSetting( "coverShowAppName"    , generic.coverShowAppName   )
            Database.setSetting( "deleteDatabase"      , generic.deleteDatabase     )

            if (cache1Adding) {
                Database.addStd1Cache()
                generic.cachesDirty = true
            }
            if (cache2Adding) {
                Database.addStd2Cache()
                generic.cachesDirty = true
            }
        }
    }
}
