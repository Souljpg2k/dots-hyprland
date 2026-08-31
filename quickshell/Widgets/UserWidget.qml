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

    anchors.top: true
    margins.top: 1
    implicitWidth: 200
    implicitHeight: 130
    exclusiveZone: 0
    color: "transparent"

    function requestClose() {
        if (closing)
            return;
        closing = true;
        fadeIn.stop();
        fadeOut.start();
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        scale: 0.94
        transformOrigin: Item.Bottom

        StyledShadow {
            anchors.centerIn: b
            width: b.width
            height: b.height
        }

        Rectangle {
            id: b
            anchors.centerIn: parent
            width: 180
            height: 110
            radius: Appearance.radius
            color: Appearance.on_secondary

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
        ScriptAction { script: GlobalStates.userWidgetsVisible = false }
    }

    Component.onCompleted: fadeIn.start()

    Connections {
        target: GlobalStates
        function onUserWidgetsCloseRequested() {
            w.requestClose();
        }
    }
}