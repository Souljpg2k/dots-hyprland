import qs.Appearance
import qs.Components
import QtQuick
import Quickshell
import Quickshell.Hyprland

Item {
    id: root
    width: wsRow.width + rowPadding * 2
    height: parent.height

    readonly property int workspaceCount: 10
    readonly property int rowPadding: 8
    readonly property int itemWidth: 26
    readonly property int workspaceHeight: 28
    readonly property int indicatorSize: 22
    readonly property int animDuration: 250
    readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1

    function indicatorX(id) {
        return wsRow.x + (id - 1) * itemWidth + (itemWidth - indicatorSize) / 2;
    }

    function focusWorkspace(id) {
        if (id < 1 || id > workspaceCount)
            return;
        if (Hyprland.usingLua) {
            Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })");
        } else {
            Hyprland.dispatch("workspace " + id);
        }
    }

    function focusRelative(delta) {
        focusWorkspace(activeId + delta);
    }

    Rectangle {
        id: activeIndicator
        height: indicatorSize
        radius: Appearance.radius
        color: Appearance.primary_fixed
        anchors.verticalCenter: parent.verticalCenter

        property int prevId: root.activeId
        property int currId: root.activeId

        x: Math.min(root.indicatorX(prevId), root.indicatorX(currId))
        width: Math.abs(root.indicatorX(currId) - root.indicatorX(prevId)) + indicatorSize

        Behavior on x {
            NumberAnimation {
                duration: root.animDuration
                easing.type: Easing.OutCubic
            }
        }

        Behavior on width {
            NumberAnimation {
                duration: root.animDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    Timer {
        id: resetTimer
        interval: 150
        onTriggered: activeIndicator.prevId = activeIndicator.currId
    }

    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged() {
            activeIndicator.prevId = activeIndicator.currId;
            activeIndicator.currId = Hyprland.focusedWorkspace?.id ?? 1;
            resetTimer.restart();
        }
    }

    Row {
        id: wsRow
        x: rowPadding
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: workspaceCount

            Item {
                id: workspaceItem
                width: itemWidth
                height: workspaceHeight

                readonly property int workspaceId: index + 1
                readonly property var workspace: Hyprland.workspaces.values.find(workspace => workspace.id === workspaceId)
                readonly property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId

                Rectangle {
                    id: inactiveWorkspaceBg
                    anchors.centerIn: parent
                    width: indicatorSize
                    height: indicatorSize
                    radius: Appearance.radius
                    color: Appearance.secondary_fixed_dim
                    opacity: workspace && !isActive ? 0.2 : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Text {
                    id: workspaceLabel
                    anchors.centerIn: parent
                    text: isActive ? "󰮯" : ""
                    color: isActive ? Appearance.secondary_fixed_dim : workspace ? Appearance.secondary_fixed : Appearance.outline
                    font {
                        family: "JetBrainsMono Nerd Font"
                        pixelSize: isActive ? Appearance.base : Appearance.base - 3
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: focusWorkspace(workspaceId)
                    onWheel: wheel => focusRelative(wheel.angleDelta.y > 0 ? -1 : 1)
                }
            }
        }
    }
}
