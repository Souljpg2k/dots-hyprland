import qs.Appearance
import qs.Components
import qs.Services
import QtQuick

Item {
    width: 110
    height: 110

    StyledShadow {
        width: 102
        height: 102
    }

    Rectangle {
        anchors.centerIn: parent
        width: 100
        height: 100
        radius: Appearance.base + 8
        color: Appearance.on_secondary

        Rectangle {
            anchors {
                right: parent.right
                top: parent.top
                rightMargin: 10
                topMargin: 10
            }

            width: 30
            height: 30
            radius: Appearance.radius
            color: Appearance.secondary_fixed

            MaterialIcon {
                anchors.centerIn: parent
                text: "earthquake"
                color: Appearance.on_secondary_fixed_variant
            }
        }

        Column {
            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: 10
                bottomMargin: 10
            }

            StyledText {
                text: SystemMonitor.cpuUsage + "%"
                font.pixelSize: 18
                font.bold: true
            }

            StyledText {
                text: "CPU"
            }
        }
    }
}
