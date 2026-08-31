import qs
import qs.Components.Clock
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    implicitWidth: 150
    implicitHeight: 150
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Bottom

    Clock {
        id: clock
        anchors.fill: parent
        opacity: 0
        scale: 0.85
        rotation: -180
    }

    ParallelAnimation {
        id: fadeIn

        NumberAnimation {
            target: clock
            property: "opacity"
            from: 0
            to: 1
            duration: 420
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
            script: GlobalStates.clockClosing = false
        }
    }

    Component.onCompleted: fadeIn.start()

    Connections {
        target: GlobalStates
        function onClockVisibleChanged() {
            if (GlobalStates.clockVisible) {
                fadeOut.stop();
                fadeIn.start();
            } else {
                fadeIn.stop();
                fadeOut.start();
            }
        }
    }
}