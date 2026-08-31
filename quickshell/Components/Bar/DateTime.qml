import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import QtQuick.Layouts

StyledItem {
    width: 128

    Rectangle {
        anchors {
            right: parent.right
            rightMargin: 14
            verticalCenter: parent.verticalCenter
        }
        width: 110
        height: 24
        color: "transparent"
        radius: Appearance.radius

        RowLayout {
            anchors.centerIn: parent
            spacing: 4

            StyledText {
                text: DateTimeService.date
                leftPadding: 2
            }

            Item {
                width: time.implicitWidth + 12
                height: time.height

                Rectangle {
                    id: time
                    radius: Appearance.radius
                    height: 20
                    implicitWidth: timeText.implicitWidth + 16
                    color: Appearance.surface_bright

                    StyledText {
                        id: timeText
                        text: DateTimeService.time
                        anchors.centerIn: parent
                        color: Appearance.secondary_fixed_dim
                        font.weight: Font.DemiBold
                    }
                }

                Rectangle {
                    width: 22
                    height: 22
                    radius: Appearance.radius
                    color: Appearance.on_secondary
                    anchors {
                        right: parent.right
                        verticalCenter: time.verticalCenter
                        rightMargin: -5
                    }

                    StyledText {
                        text: DateTimeService.ap
                        anchors.centerIn: parent
                        font.pixelSize: 10
                    }
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: GlobalStates.toggleClock()
        }
    }
}
