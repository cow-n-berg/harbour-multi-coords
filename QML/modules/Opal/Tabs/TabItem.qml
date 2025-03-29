//@ This file is part of Opal.Tabs.
//@ SPDX-FileCopyrightText: 2024 Mirian Margiani
//@ SPDX-FileCopyrightText: Copyright (C) 2019 Open Mobile Platform LLC.
//@ SPDX-License-Identifier: GPL-3.0-or-later
//@ Original license: BSD-3-Clause (see separate license file SILICA-LICENSE)
//@ Original copyright notices are listed above.

import QtQuick 2.0
import Sailfish.Silica 1.0
import "private/Util.js" as Util

// WARNING possible future issue: this component uses private __silica_page.isPortrait

SilicaControl {
    id: root

    default property alias contents: bodyItem.data

    property int topMargin: parent._ctxTopMargin || _ctxTopMargin || 0
    property int bottomMargin: parent._ctxBottomMargin || _ctxBottomMargin || 0

    property Flickable flickable
    property bool allowDeletion: true
    readonly property bool isCurrentItem: _tabContainer && _tabContainer.PagedView.isCurrentItem

    property Item _tabContainer: parent._ctxTabContainer || _ctxTabContainer || root
    property Item _page: parent._ctxPage || _ctxPage

    readonly property real _yOffset: flickable && flickable.pullDownMenu
            ? flickable.contentY - flickable.originY
            : 0
    property alias _cacheExpiry: cleanupTimer.interval

    property bool _hasPullDownMenu: !!flickable && !!flickable.pullDownMenu
    property bool _hasPushUpMenu: !!flickable && !!flickable.pushUpMenu

    implicitWidth: _tabContainer ? _tabContainer.PagedView.contentWidth : (
        __silica_page.isPortrait ? Screen.width : Screen.height)
    implicitHeight: {
        if (!_tabContainer || !_tabContainer.PagedView) {
            return (__silica_page.isPortrait ? Screen.height : Screen.width)
        } else if (flickable && flickable.pullDownMenu && _tabContainer.PagedView.view) {
            return _tabContainer.PagedView.view.height
        } else {
            return _tabContainer.PagedView.contentHeight
        }
    }

    // TabItem is transparent by default and is faded in when
    // it is fully loaded by TabView
    opacity: 0

    clip: !flickable || !flickable.pullDownMenu || !flickable.pushUpMenu

    Component.onCompleted: {
        if (_tabContainer && !!_tabContainer.DelegateModel) {
            _tabContainer.DelegateModel.inPersistedItems = true
        }

        if (!flickable) {
            for (var child in children) {
                if (child.hasOwnProperty('maximumFlickVelocity') &&
                        !child.hasOwnProperty('__silica_hidden_flickable')) {
                    flickable = child
                    break
                }
            }
        }
    }

    Binding {
        target: !!flickable && !!flickable.pullDownMenu ?
                    flickable.pullDownMenu : null
        property: "y"
        when: topMargin > 0
        value: flickable.originY
               - (!!flickable.pullDownMenu ?
                      flickable.pullDownMenu.height : 0)
               - root.topMargin
               + (_page.orientation & Orientation.PortraitMask ?
                      0 : Theme.paddingMedium)
    }

    // FIXME If the tab bar is at the bottom and the view has
    // a PushUpMenu, it gets positioned above the tab bar.
    // This is ugly and inconsistent: it should be placed below
    // the tab bar just as when the tab bar is at the top.
    //
    // It is possible to position the menu at the bottom of
    // the screen but then it is impossible to pull it open.
    // It is better to have it ugly and working, than nice
    // but broken.

    /*
    Binding {
        target: !!flickable && flickable.pushUpMenu ?
            flickable.pushUpMenu : null
        property: "y"
        when: bottomMargin > 0
        value: flickable.originY
               + flickable.contentHeight
               + flickable.pushUpMenu._contentDeficit
               + root.bottomMargin
               - (_page.orientation & Orientation.PortraitMask ?
                      0 : Theme.paddingMedium)
    }

    Binding {
        target: !!flickable && flickable.pushUpMenu ?
            flickable.pushUpMenu : null
        property: "bottomMargin"
        when: bottomMargin > 0
        value: bottomMargin + Theme.itemSizeMedium
    }
    */

    Timer {
        id: cleanupTimer

        running: root.allowDeletion && root._tabContainer && !root._tabContainer.PagedView.exposed
        interval: 30000

        onTriggered: {
            if (!!_tabContainer && !!_tabContainer.DelegateModel) {
                _tabContainer.DelegateModel.inPersistedItems = false
            }
        }
    }

    SilicaItem {
        id: bodyItem
        anchors {
            top: parent.top
            topMargin: _hasPullDownMenu ? root.topMargin : 0
        }

        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight
                        - anchors.topMargin
                        - parent.bottomMargin
    }
}
