import qs.Appearance
import qs.Components
import qs.Services
import QtQuick

Item {
    id: root

    implicitWidth: 150
    implicitHeight: 150
    
    Rosette {}

    Repeater {
        model: 4

        StyledText {
            required property int index
            readonly property string number: ["12", "3", "6", "9"][index]
            readonly property real angle: index * 90 - 90
            readonly property real radius: parent.width / 2 - 35

            text: number
            color: Appearance.secondary
            font {
                pixelSize: Appearance.base + 30
                bold: true
            }
            opacity: 0.2
            x: parent.width / 2 + Math.cos(angle * Math.PI / 180) * radius - width / 2
            y: parent.height / 2 + Math.sin(angle * Math.PI / 180) * radius - height / 2
        }
    }

    Pentagon {
        id: hourL
        width: 38
        height: 36

        anchors {
            left: parent.left
            top: parent.top
            leftMargin: 11
            topMargin: 8
        }

        StyledText {
            anchors {
                centerIn: parent
                verticalCenterOffset: 2
            }
            font {
                pixelSize: Appearance.base + 1
                bold: true
            }
            text: DateTimeService.hours
            color: Appearance.on_secondary_fixed_variant
        }
    }

    Rectangle {
        id: minuteR
        width: 36
        height: 24
        radius: height / 2
        color: Appearance.secondary_fixed
        rotation: 145

        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 12
            bottomMargin: 9
        }

        StyledText {
            anchors.centerIn: parent
            text: DateTimeService.minutes
            color: Appearance.on_secondary_fixed_variant
            rotation: -145
            font {
                pixelSize: Appearance.base + 1
                bold: true
            }
        }
    }

    Rectangle {
        id: seconds
        width: 3
        height: 66
        radius: width / 2
        color: Appearance.tertiary
        x: (parent.width - width) / 2
        y: parent.height / 2 - height + 14
        transform: Rotation {
            origin.x: seconds.width / 2
            origin.y: seconds.height - 14
            angle: DateTimeService.seconds * 6
        }
    }

    Rectangle {
        id: minutes
        width: 7
        height: 62
        radius: width / 2
        color: Appearance.secondary_fixed
        x: (parent.width - width) / 2
        y: parent.height / 2 - height + 5
        transform: Rotation {
            origin.x: minutes.width / 2
            origin.y: minutes.height - 5
            angle: DateTimeService.minutes * 6 + DateTimeService.seconds * 0.1
        }
    }

    Rectangle {
        id: hours
        width: 11
        height: 43
        radius: width / 2
        color: Appearance.secondary_fixed
        x: (parent.width - width) / 2
        y: parent.height / 2 - height + 5
        transform: Rotation {
            origin.x: hours.width / 2
            origin.y: hours.height - 5
            angle: (DateTimeService.hours % 12) * 30 + DateTimeService.minutes * 0.5
        }
    }

    Rectangle {
        id: dot
        width: 6
        height: 6
        radius: width / 2
        anchors.centerIn: parent
        color: Appearance.on_secondary_fixed_variant
    }
}
