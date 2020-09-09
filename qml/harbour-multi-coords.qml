import QtQuick 2.2
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0
import "pages"
import "scripts/Database.js" as DB

ApplicationWindow
{
    id: generic

    property string version               : "1.7"
    property string dbversion             : "1.3"
    property var    dbhandler             : DB.openDatabase(dbversion)
    property bool   debug                 : false

    // Settings                           
    property bool coverShowAppName        : DB.getSetting( "coverShowAppName", false )
    property bool showDialogHints         : DB.getSetting( "showDialogHints", true )
    property bool deleteDatabase          : DB.getSetting( "deleteDatabase", false )
    property bool nightCacheMode          : DB.getSetting( "nightCacheMode", false )
    property bool formulaCopyMode         : DB.getSetting( "formulaCopyMode", false )

    property var browserUrl               : "https://coord.info/"
    property var primaryColor             : nightCacheMode ? "firebrick" : Theme.primaryColor
    property var secondaryColor           : nightCacheMode ? "maroon"    : Theme.secondaryColor
    property var highlightColor           : nightCacheMode ? "red"       : Theme.highlightColor
    property var secondaryHighlightColor  : nightCacheMode ? "crimson"   : Theme.secondaryHighlightColor
    property var highlightBackgroundColor : nightCacheMode ? "maroon"    : Theme.highlightBackgroundColor

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

    // Work-around for refreshing pages
    property bool cachesDirty : false
    property bool multiDirty  : false
    property bool wayptDirty  : false

    Component.onCompleted: { DB.openDatabase() }

    initialPage: Component { CachesPage { } }
    cover: Qt.resolvedUrl("pages/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

}
