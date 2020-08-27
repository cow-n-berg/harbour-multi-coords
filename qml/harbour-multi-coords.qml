import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "pages"
import "scripts/Database.js" as DB

ApplicationWindow
{
    id: generic

    property string version            : "0.5"
    property var browserUrl            : "https://coord.info/"

    property var gcName
    property var gcCode
    property var gcId
    property var wpId
    property var wpNumber
    property var wpForm
    property var wpCalc
    property var wpNote
    property var wpIsWp
    property var wpFound
    property var allLetters
    property var lettEdit

    Component.onCompleted: { DB.openDatabase() }

    property bool stdCacheAdded        : DB.getSetting( "stdCacheAdded", false )
    property bool stdCache2Added       : DB.getSetting( "stdCache2Added", false )
    property bool coverShowAppName     : DB.getSetting( "coverShowAppName", false )
    property bool deleteDatabase       : DB.getSetting( "deleteDatabase", false )

    initialPage: Component { CachesPage { } }
    cover: Qt.resolvedUrl("pages/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

}
