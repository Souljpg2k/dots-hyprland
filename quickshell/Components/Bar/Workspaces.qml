import qs.Appearance
import qs.Components
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Item {
    id: root
    width: wsRow.width + rowPadding * 2
    height: parent.height

    readonly property int wsCount: 10
    readonly property int rowPadding: 8
    readonly property int itemWidth: 26
    readonly property int dotSize: 22
    readonly property int animDuration: 350
    readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1

    function indicatorX(id) {
        return wsRow.x + (id - 1) * itemWidth + (itemWidth - dotSize) / 2;
    }

    function focusWorkspace(id) {
        if (id < 1 || id > wsCount)
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
        id: pill
        height: dotSize
        radius: Appearance.radius
        color: Colors.pf
        anchors.verticalCenter: parent.verticalCenter

        property int prevId: root.activeId
        property int currId: root.activeId

        x: Math.min(root.indicatorX(prevId), root.indicatorX(currId))
        width: Math.abs(root.indicatorX(currId) - root.indicatorX(prevId)) + dotSize

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
        onTriggered: pill.prevId = pill.currId
    }

    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged() {
            pill.prevId = pill.currId;
            pill.currId = Hyprland.focusedWorkspace?.id ?? 1;
            resetTimer.restart();
        }
    }

    Row {
        id: wsRow
        x: rowPadding
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: wsCount

            Item {
                width: itemWidth
                height: 28

                readonly property int workspaceId: index + 1
                readonly property var workspace: Hyprland.workspaces.values.find(workspace => workspace.id === workspaceId)
                readonly property bool isActive: Hyprland.focusedWorkspace?.id === workspaceId

                readonly property var wsToplevel: {
                    if (!workspace || isActive)
                        return null;
                    const toplevels = Hyprland.toplevels.values.filter(t => t.workspace?.id === workspaceId);
                    return toplevels.find(t => t.activated) ?? toplevels[toplevels.length - 1] ?? null;
                }
                readonly property string wsIconName: wsToplevel ? (
                    DesktopEntries.heuristicLookup(wsToplevel.wayland?.appId ?? "")?.icon ?? "") : ""

                Rectangle {
                    id: dotBg
                    anchors.centerIn: parent
                    width: dotSize
                    height: dotSize
                    radius: Appearance.radius
                    color: Colors.on_bg
                    opacity: workspace && !isActive ? 0.08 : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Text {
                    id: wsLabel
                    anchors.centerIn: parent
                    text: isActive ? "󰮯" : ""
                    color: isActive ? Colors.bg : workspace ? Colors.sf : Colors.outline
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

                IconImage {
                    id: wsIcon
                    anchors.centerIn: parent
                    implicitSize: dotSize - 8
                    source: wsIconName ? Quickshell.iconPath(wsIconName, true) : ""
                    opacity: wsIconName ? 0.9 : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: root.animDuration
                            easing.type: Easing.OutCubic
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
