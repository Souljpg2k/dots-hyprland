import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

PanelWindow {
    id: w

    property bool closing: false

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    implicitWidth: 200
    implicitHeight: 130
    exclusiveZone: 0
    color: "transparent"

    function requestClose() {
        if (closing)
            return;
        closing = true;
        animation.startExit();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: w.requestClose()
    }

    Item {
        id: content
        width: parent.width
        height: parent.height
        opacity: 0
        scale: 0.94
        transformOrigin: Item.Top

        StyledShadow {
            anchors.centerIn: b
            width: b.width
            height: b.height
        }

        Rectangle {
            id: b
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 15
            }
            width: 180
            height: 110
            radius: Appearance.radius
            color: Appearance.background

            ClippingRectangle {
                width: 50
                height: 50
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 10
                    leftMargin: 10
                }
                radius: Appearance.radius + 8
                color: Appearance.on_background

                Image {
                    anchors.fill: parent
                    source: "../Assets/2.png"
                    fillMode: Image.PreserveAspectCrop
                }
            }

            Column {
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 20
                    leftMargin: 70
                }
                spacing: 2

                StyledText {
                    text: `${SystemInfo.username}@${SystemInfo.hostname}`
                }
                StyledText {
                    text: SystemInfo.uptimeText
                    font.pixelSize: Appearance.base - 2
                    opacity: 0.7
                }
            }

            RowLayout {
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 10
                    left: parent.left
                    leftMargin: 10
                }
                spacing: 8

                Rectangle {
                    width: 80
                    height: 30
                    radius: Appearance.radius
                    color: Appearance.secondary_fixed

                    StyledText {
                        anchors.centerIn: parent
                        text: "󰌾  Lock"
                        color: Appearance.on_secondary_fixed_variant
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: GlobalStates.screenLocked = true
                    }
                }

                Rectangle {
                    width: 30
                    height: 30
                    color: "transparent"
                    radius: Appearance.radius + 4
                    border {
                        width: 1
                        color: Appearance.secondary_fixed
                    }

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: NightLight.enabled ? "nightlight" : "light_mode"
                        font.pixelSize: Appearance.base
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NightLight.toggle()
                    }
                }

                Rectangle {
                    width: 30
                    height: 30
                    color: "transparent"
                    radius: Appearance.radius + 4
                    border {
                        width: 1
                        color: Appearance.secondary_fixed
                    }

                    MaterialIcon {
                        anchors.centerIn: parent
                        text: "power_settings_new"
                        font.pixelSize: Appearance.base
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: GlobalStates.togglePowerMenu()
                    }
                }
            }
        }
    }

    Animations {
        id: animation
        target: content

        enterX: 0
        enterY: -50

        exitX: 0
        exitY: -24

        onExited: GlobalStates.userWidgetsVisible = false
    }

    Component.onCompleted: animation.startEnter()

    Connections {
        target: GlobalStates
        function onUserWidgetsCloseRequested() {
            w.requestClose();
        }
    }
}
