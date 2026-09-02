import qs
import qs.Components
import qs.Components.Clock
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property bool closing: false

    implicitWidth: 150
    implicitHeight: 150
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Bottom

    Clock {
        id: clock
        anchors.fill: parent
    }

    Animations {
        id: animation
        target: clock

        enterRotation: -45
        exitRotation: 145

        onExited: GlobalStates.clockClosing = false
    }

    Component.onCompleted: animation.startEnter()

    Connections {
        target: GlobalStates

        function onClockVisibleChanged() {
            if (GlobalStates.clockVisible) {
                root.closing = false
                animation.startEnter()
            } else {
                root.closing = true
                animation.startExit()
            }
        }
    }
}