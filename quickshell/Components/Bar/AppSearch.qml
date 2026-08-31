import qs.Appearance
import qs.Components
import QtQuick
import Quickshell

Item {
    width: 24
    height: 24

    StyledText {
        anchors.centerIn: parent
        text: ""
        font.pixelSize: Appearance.base + 6
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["rofi", "-show", "drun"])
    }
}