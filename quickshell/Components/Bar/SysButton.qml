import qs
import qs.Components
import QtQuick
import Quickshell

StyledItem {
    MaterialIcon {
        anchors.centerIn: parent
        text: "bolt"
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                GlobalStates.togglePowerMenu();
            else
                GlobalStates.toggleSysWidgets();
        }
    }
}