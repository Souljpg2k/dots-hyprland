import qs
import qs.Components.Clock
import qs.Services
import QtQuick

Item {
    id: root
    anchors.fill: parent

    required property LockContext context
    property bool unlocking: false

    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        Image {
            anchors.fill: parent
            source: Wallpapers.wallpaperPath
            fillMode: Image.PreserveAspectCrop
        }

        Clock {
            id: clock
            anchors.centerIn: parent
            width: 150
            height: 150
            opacity: 0
            scale: 0.85
            rotation: -180
        }

        LockInterface {
            context: root.context
        }
    }

    ParallelAnimation {
        id: fadeIn

        NumberAnimation {
            target: content
            property: "opacity"
            from: 0
            to: 1
            duration: 550
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: clock
            property: "opacity"
            from: 0
            to: 1
            duration: 480
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: clock
            property: "scale"
            from: 0.85
            to: 1
            duration: 560
            easing.type: Easing.OutBack
            easing.overshoot: 1.1
        }
        NumberAnimation {
            target: clock
            property: "rotation"
            from: -180
            to: 0
            duration: 560
            easing.type: Easing.OutBack
            easing.overshoot: 1.1
        }
    }

    SequentialAnimation {
        id: fadeOut

        ParallelAnimation {
            NumberAnimation {
                target: content
                property: "opacity"
                to: 0
                duration: 550
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: clock
                property: "opacity"
                to: 0
                duration: 320
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: clock
                property: "scale"
                to: 0.85
                duration: 360
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: clock
                property: "rotation"
                to: 180
                duration: 360
                easing.type: Easing.InCubic
            }
        }

        ScriptAction {
            script: GlobalStates.screenLocked = false
        }
    }

    Component.onCompleted: fadeIn.start()

    Connections {
        target: root.context
        function onUnlocked() {
            if (root.unlocking)
                return
            root.unlocking = true
            fadeIn.stop()
            fadeOut.start()
        }
    }
}
