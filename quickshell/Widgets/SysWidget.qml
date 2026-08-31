import qs
import qs.Appearance
import qs.Components
import qs.Components.SystemMonitor
import qs.Services
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property bool closing: false

    anchors {
        right: true
        top: true
    }

    implicitWidth: 110
    implicitHeight: 350

    margins {
        top: 10
        right: 8
    }

    color: "transparent"
    WlrLayershell.layer: WlrLayer.Bottom

    Column {
        id: content
        anchors.centerIn: parent
        anchors.fill: parent

        Cpu {}
        Gpu {}
        Mem {}
    }

    ParallelAnimation {
        id: fadeIn

        NumberAnimation {
            target: content
            property: "opacity"
            from: 0
            to: 1
            duration: 240
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: content
            property: "scale"
            from: 0.94
            to: 1
            duration: 300
            easing.type: Easing.OutBack
            easing.overshoot: 1.05
        }
    }

    SequentialAnimation {
        id: fadeOut

        ParallelAnimation {
            NumberAnimation {
                target: content
                property: "opacity"
                to: 0
                duration: 180
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: content
                property: "scale"
                to: 0.94
                duration: 200
                easing.type: Easing.InCubic
            }
        }

        ScriptAction {
            script: GlobalStates.sysWidgetsVisible = false
        }
    }

    Component.onCompleted: fadeIn.start()

    Connections {
        target: GlobalStates
        function onSysWidgetsCloseRequested() {
            if (root.closing)
                return;
            root.closing = true;
            fadeIn.stop();
            fadeOut.start();
        }
    }
}
