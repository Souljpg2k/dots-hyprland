import qs.Services
import qs.Appearance
import qs.Components
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland

Item {
    id: root
    width: 80
    height: parent.height

    readonly property var activeWindow: ToplevelManager.activeToplevel
    property string desktopName: "Desktop"

    Column {
        spacing: -4
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: root.activeWindow?.appId ?? root.desktopName
            font {
                pixelSize: Appearance.base - 2
                weight: Font.DemiBold
            }
            width: root.width
            elide: Text.ElideRight
            opacity: 0.5
        }

        StyledText {
            text: "workspace " + Hyprland.focusedMonitor?.activeWorkspace?.id ?? ""
            width: root.width
            elide: Text.ElideRight
        }
    }
}
