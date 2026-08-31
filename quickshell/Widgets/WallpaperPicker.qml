import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root

    property bool closing: false

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    exclusiveZone: 0
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    function close() {
        if (closing)
            return

        closing = true
        fadeIn.stop()
        fadeOut.start()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Item {
        id: panel
        width: 600
        height: 320
        opacity: 0
        scale: 0.94
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 8
        }

        StyledShadow {
            anchors.centerIn: box
            width: box.width
            height: box.height
            opacity: 0.6
        }

        Rectangle {
            id: box
            width: 580
            height: 310
            radius: Appearance.radius
            color: Appearance.on_secondary
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: -18
            }

            StyledText {
                id: title
                text: "Wallpapers"
                opacity: 0
                anchors {
                    top: parent.top
                    left: parent.left
                    topMargin: 14
                    leftMargin: 24
                }
                font {
                    pixelSize: Appearance.base + 5
                    bold: true
                }
            }

            GridView {
                id: grid
                clip: true
                focus: true
                model: Wallpapers.wallpapers
                currentIndex: 0
                cellWidth: 180
                cellHeight: 125
                anchors {
                    top: title.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 20
                }

                function choose(index) {
                    const item = itemAtIndex(index)
                    if (!item)
                        return
                    currentIndex = index
                    Wallpapers.apply(item.filePath)
                    root.close()
                }

                Keys.onPressed: event => {
                    let next = currentIndex

                    switch (event.key) {
                    case Qt.Key_Left:
                        next--
                        break
                    case Qt.Key_Right:
                        next++
                        break
                    case Qt.Key_Up:
                        next -= 3
                        break
                    case Qt.Key_Down:
                        next += 3
                        break
                    case Qt.Key_Return:
                    case Qt.Key_Enter:
                    case Qt.Key_Space:
                        choose(currentIndex)
                        event.accepted = true
                        return
                    case Qt.Key_Escape:
                        root.close()
                        event.accepted = true
                        return
                    default:
                        return
                    }
                    currentIndex = Math.max(0, Math.min(count - 1, next))
                    event.accepted = true
                }

                Component.onCompleted: forceActiveFocus()

                delegate: Item {
                    id: cell

                    required property string filePath
                    required property int index

                    width: 168
                    height: 112
                    opacity: loaded ? 1 : 0
                    scale: loaded ? 1 : 0.9

                    property bool loaded: false
                    property bool selected: GridView.isCurrentItem

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 180
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: 180
                            easing.type: Easing.OutCubic
                        }
                    }

                    Timer {
                        interval: 70 + Math.min(cell.index, 10) * 32
                        running: panel.opacity > 0.5
                        onTriggered: cell.loaded = true
                    }

                    ClippingRectangle {
                        id: thumbnail
                        anchors.fill: parent
                        radius: Appearance.radius
                        color: Appearance.on_secondary_fixed
                        scale: mouse.pressed ? 0.96 : 1

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                            }
                        }

                        Image {
                            anchors.fill: parent
                            source: cell.filePath
                            sourceSize: Qt.size(200, 200)
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            smooth: true
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: Appearance.background
                            opacity: mouse.pressed? 0.28 : mouse.containsMouse ? 0 : 0.15

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 140
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: thumbnail
                        radius: Appearance.radius
                        color: "transparent"
                        border {
                            width: cell.selected ? 2 : 0
                            color: Appearance.secondary_fixed
                        }
                    }

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: grid.choose(cell.index)
                    }
                }
            }
        }
    }

    ParallelAnimation {
        id: fadeIn

        NumberAnimation {
            target: panel;
            property: "opacity";
            to: 1;
            duration: 260;
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: panel
            property: "scale"
            to: 1
            duration: 320
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: box
            property: "anchors.bottomMargin"
            to: 4
            duration: 320
            easing.type: Easing.OutCubic
        }
        
        SequentialAnimation {
            PauseAnimation {
                duration: 80
            }
            PropertyAction {
                target: title
                property: "opacity"
                value: 1
            }
        }
    }

    SequentialAnimation {
        id: fadeOut

        ParallelAnimation {
            NumberAnimation {
                target: panel
                property: "opacity"
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: panel
                property: "scale"
                to: 0.94
                duration: 220
                easing.type: Easing.InCubic
            }
            NumberAnimation {
                target: box
                property: "anchors.bottomMargin"
                to: -14
                duration: 220
                easing.type: Easing.InCubic
            }
        }
        PropertyAction {
            target: GlobalStates
            property: "wallpaperPickerVisible"
            value: false
        }
    }

    HyprlandFocusGrab {
        windows: [root]
        active: GlobalStates.wallpaperPickerVisible
        onCleared: root.close()
    }

    Connections {
        target: GlobalStates

        function onWallpaperCloseRequested() {
            root.close()
        }
    }

    Component.onCompleted: fadeIn.start()
}
