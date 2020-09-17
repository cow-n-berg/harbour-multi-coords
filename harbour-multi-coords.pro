# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-multi-coords

CONFIG += sailfishapp_qml

DISTFILES += qml/harbour-multi-coords.qml \
    qml/Database.js \
    qml/cover/CoverPage.qml \
    qml/pages/CachesPage.qml \
    qml/pages/LaArboro.qml \
    qml/pages/LetterPage.qml \
    qml/pages/MultiAddPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/MultiShowPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/WayptAddPage.qml \
    qml/pages/WayptShowPage.qml \
    qml/scripts/Calculations.js \
    qml/scripts/TextFunctions.js \
    rpm/harbour-multi-coords.changes.in \
    rpm/harbour-multi-coords.changes.run.in \
    rpm/harbour-multi-coords.spec \
    rpm/harbour-multi-coords.yaml \
    translations/*.ts \
    harbour-multi-coords.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-multi-coords-de.ts
