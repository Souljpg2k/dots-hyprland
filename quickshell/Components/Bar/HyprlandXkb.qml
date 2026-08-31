import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import Quickshell

Item {
    width: 50
    height: 24

    MaterialIcon {
        anchors {
            left: parent.left
            leftMargin: 7
            verticalCenter: parent.verticalCenter
        }
        text: "keyboard"
        font.pixelSize: Appearance.base + 3
    }

    StyledText {
        anchors {
            left: parent.left
            leftMargin: 24
            verticalCenter: parent.verticalCenter
        }
        text: LayoutService.currentLayout
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Appearance.base
        width: 20
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"]);
        }
    }
}
