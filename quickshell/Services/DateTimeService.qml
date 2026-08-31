pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string time: Qt.formatDateTime(clock.date, "HH:mm")
    readonly property int hours: Qt.formatDateTime(clock.date, "HH")
    readonly property int minutes: Qt.formatDateTime(clock.date, "mm")
    readonly property int seconds: Qt.formatDateTime(clock.date, "ss")
    readonly property string date: Qt.formatDateTime(clock.date, "dd/MM")
    readonly property string day: Qt.formatDateTime(clock.date, "dddd")
    readonly property string month: Qt.formatDateTime(clock.date, "MMMM")
    readonly property string ap: Qt.formatDateTime(clock.date, "ap")

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
