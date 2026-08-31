import qs.Components
import QtQuick
import Quickshell

StyledItem {
    MaterialIcon {
        anchors.centerIn: parent
        text: "screenshot_region"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                Quickshell.execDetached(["sh", "-c", "hyprshot -m region -o $HOME/Screenshots"])
            } else {
                Quickshell.execDetached(["sh", "-c", "hyprshot -m window -o $HOME/Screenshots"])
            }
        }
    }
}