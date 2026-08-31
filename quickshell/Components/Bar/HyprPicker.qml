import qs.Components
import QtQuick
import Quickshell

StyledItem {
    MaterialIcon {
        anchors.centerIn: parent
        text: "colorize"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["hyprpicker", "-a"])
    }
}