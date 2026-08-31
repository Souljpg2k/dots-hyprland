import qs
import qs.Components
import QtQuick
import Quickshell

StyledItem {
    MaterialIcon {
        id: fanIcon
        anchors.centerIn: parent
        text: "bolt"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: GlobalStates.toggleSysWidgets()
    }
}
