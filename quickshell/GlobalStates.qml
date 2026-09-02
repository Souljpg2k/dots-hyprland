pragma Singleton

import Quickshell

Singleton {
    id: root

    property bool screenLocked: false
    property bool powerMenuVisible: false
    property bool powerMenuClosing: false
    property bool wallpaperPickerVisible: false
    property bool userWidgetsVisible: false
    property bool sysWidgetsVisible: true

    property bool clockVisible: true
    property bool clockClosing: false
    property bool clockHiddenByPowerMenu: false
    property bool clockHiddenByWallpaperPicker: false

    signal wallpaperCloseRequested
    signal userWidgetsCloseRequested
    signal sysWidgetsCloseRequested

    function showClock() {
        clockVisible = true;
        clockClosing = false;
    }

    function hideClock() {
        if (!clockVisible)
            return;
        clockClosing = true;
        clockVisible = false;
    }

    function toggleClock() {
        if (clockVisible)
            hideClock();
        else
            showClock();
    }

    function toggleSysWidgets() {
        if (sysWidgetsVisible)
            sysWidgetsCloseRequested();
        else
            sysWidgetsVisible = true;
    }

    function togglePowerMenu() {
        if (powerMenuVisible)
            closePowerMenu();
        else
            openPowerMenu();
    }

    function openPowerMenu() {
        powerMenuVisible = true;
        powerMenuClosing = false;

        if (clockVisible) {
            clockHiddenByPowerMenu = true;
            hideClock();
        }
    }

    function closePowerMenu() {
        powerMenuClosing = true;

        if (clockHiddenByPowerMenu) {
            clockHiddenByPowerMenu = false;
            showClock();
        }
    }

    onWallpaperPickerVisibleChanged: {
        if (wallpaperPickerVisible) {
            if (clockVisible) {
                clockHiddenByWallpaperPicker = true;
                hideClock();
            }
        } else if (clockHiddenByWallpaperPicker) {
            clockHiddenByWallpaperPicker = false;
            showClock();
        }
    }

    function toggleWallpaperPicker() {
        if (wallpaperPickerVisible)
            wallpaperCloseRequested();
        else
            wallpaperPickerVisible = true;
    }

    function toggleUserWidgets() {
        if (userWidgetsVisible)
            userWidgetsCloseRequested();
        else
            userWidgetsVisible = true;
    }
}