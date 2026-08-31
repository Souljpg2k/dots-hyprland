import qs
import qs.Appearance
import qs.Components
import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    width: 60
    height: 24

    Row {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: - 4
        spacing: 8

        ClippingRectangle {
            width: 20
            height: 20
            radius: Appearance.radius

            Image {
                anchors.fill: parent
                source: "../../Assets/2.png"
                fillMode: Image.PreserveAspectCrop
            }
        }

        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: Quickshell.env("USER")
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                GlobalStates.toggleWallpaperPicker();
            else
                GlobalStates.toggleUserWidgets();
        }
    }
}
