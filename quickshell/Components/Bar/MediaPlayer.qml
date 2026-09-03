import qs.Appearance
import qs.Components
import qs.Components.Cava
import qs.Services
import QtQuick
import Quickshell
import Quickshell.Widgets

Rectangle {
    width: 220
    height: 24
    radius: Appearance.radius
    color: "transparent"
    
    ClippingRectangle {
        anchors.fill: parent
        radius: Appearance.radius
        color: "transparent"

        Cava {}
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                MprisService.previous();
            else if (mouse.button === Qt.RightButton)
                MprisService.next();
        }
        onWheel: wheel => {
            if (wheel.angleDelta.y > 0)
                AudioService.volumeUp();
            else
                AudioService.volumeDown();
        }
    }

    Row {
        anchors.fill: parent
        leftPadding: 2

        ClippingRectangle {
            width: 20
            height: 20
            radius: Appearance.radius
            color: Appearance.background
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.fill: parent
                source: MprisService.activeTrack?.artUrl || "../../Assets/1.jpg"
                fillMode: Image.PreserveAspectCrop
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: MprisService.togglePlaying()
            }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            StyledText {
                id: a
                width: 80
                text: MprisService.activeTrack.artist
                font.pixelSize: Appearance.base
                elide: Text.ElideRight
                leftPadding: 8
            }

            StyledText {
                text: "•"
            }

            StyledText {
                width: a.width
                text: MprisService.activeTrack.title
                font.pixelSize: Appearance.base
                elide: Text.ElideRight
                leftPadding: 8
            }
        }
    }
}
