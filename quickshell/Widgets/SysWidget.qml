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

    Item {
        id: content
        width: parent.width
        height: parent.height

        Column {
            anchors.fill: parent
            anchors.centerIn: parent

            Cpu {}
            Gpu {}
            Mem {}
        }
    }

    function close() {
        if (closing)
            return;
        closing = true;
        animation.startExit();
    }

    Animations {
        id: animation
        target: content

        enterX: 50
        enterY: 0

        exitX: 100
        exitY: 0

        onExited: GlobalStates.sysWidgetsVisible = false
    }

    Component.onCompleted: animation.startEnter()

    Connections {
        target: GlobalStates

        function onSysWidgetsCloseRequested() {
            root.close();
        }
    }
}
