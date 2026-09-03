import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: p

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    exclusiveZone: 0
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    property int focusIndex: 0
    property bool closing: false

    readonly property int iconSize: Appearance.base + 60
    readonly property var actions: [
        {
            icon: "lock",
            action: () => PowerService.lock()
        },
        {
            icon: "logout",
            action: () => PowerService.logout()
        },
        {
            icon: "restart_alt",
            action: () => PowerService.restart()
        },
        {
            icon: "power_settings_new",
            action: () => PowerService.shutdown()
        }
    ]

    function runAction(index) {
        actions[index].action();
        requestClose();
    }

    function requestClose() {
        if (closing)
            return;
        closing = true;
        focusGrab.active = false;
        GlobalStates.closePowerMenu(); 
    }

    function moveFocus(step) {
        focusIndex = (focusIndex + step + actions.length) % actions.length;
    }

    contentItem.focus: true

    contentItem.Keys.onPressed: event => {
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
            moveFocus(-1);
        } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
            moveFocus(1);
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            runAction(focusIndex);
        } else if (event.key === Qt.Key_Escape) {
            requestClose();
        } else {
            return;
        }
        event.accepted = true;
    }

    Component.onCompleted: animation.startEnter()

    HyprlandFocusGrab {
        id: focusGrab
        windows: [p]
        onCleared: p.requestClose()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: p.requestClose()
    }

    Item {
        id: content
        anchors.centerIn: parent
        width: 550
        height: 120

        RowLayout {
            anchors.fill: parent
            spacing: 10

            Repeater {
                model: p.actions

                delegate: Item {
                    required property var modelData
                    required property int index

                    Layout.preferredWidth: 130
                    Layout.preferredHeight: 120

                    StyledShadow {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                    }

                    Rectangle {
                        id: card
                        anchors.fill: parent

                        property bool hovered: mouseArea.containsMouse
                        property bool focused: p.focusIndex === index

                        color: hovered || focused ? Appearance.primary_fixed : Appearance.background
                        radius: Appearance.radius

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }

                        MaterialIcon {
                            anchors.centerIn: parent
                            text: modelData.icon
                            font.pixelSize: p.iconSize
                            color: card.hovered || card.focused ? Appearance.on_primary : Appearance.on_surface
                            scale: card.hovered || card.focused ? 1.12 : 1

                            Behavior on scale {
                                NumberAnimation {
                                    duration: 300
                                    easing.type: Easing.OutBack
                                    easing.overshoot: 1.05
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onEntered: p.focusIndex = index
                            onClicked: {
                                p.focusIndex = index;
                                p.runAction(index);
                            }
                        }
                    }
                }
            }
        }
    }

    Animations {
        id: animation
        target: content

        onExited: {
            GlobalStates.powerMenuVisible = false;
            GlobalStates.powerMenuClosing = false;
        }
    }

    Connections {
        target: GlobalStates

        function onPowerMenuClosingChanged() {
            if (GlobalStates.powerMenuClosing)
                animation.startExit();
        }
    }
}
