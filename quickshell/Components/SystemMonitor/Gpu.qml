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
        color: Colors.bg

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
            color: Colors.sf

            MaterialIcon {
                anchors.centerIn: parent
                text: "mode_fan"
                color: Colors.on_sf
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
                text: SystemMonitor.gpuUsage + "%"
                font {
                    pixelSize: 18
                    bold: true
                }
            }

            StyledText {
                text: "GPU"
            }
        }
    }
}
