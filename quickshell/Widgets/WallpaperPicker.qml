import qs
import qs.Appearance
import qs.Components
import qs.Services
import QtQuick
import Quickshell
import Quickshell.Widgets
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

    implicitWidth: 600
    implicitHeight: 320
    exclusiveZone: 0
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    function close() {
        if (closing)
            return;
        closing = true;
        animation.startExit();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()
    }

    Item {
        id: panel
        width: parent.width
        height: parent.height
        opacity: 0
        scale: 0.94

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
            color: Colors.bg
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 18
            }

            GridView {
                id: grid
                clip: true
                focus: true
                model: Wallpapers.wallpapers
                currentIndex: 0
                cellWidth: 180
                cellHeight: 140
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    margins: 20
                }

                function choose(index) {
                    const item = itemAtIndex(index);
                    if (!item)
                        return;
                    currentIndex = index;
                    Wallpapers.apply(item.filePath);
                    root.close();
                }

                Keys.onPressed: event => {
                    let next = currentIndex;

                    if (event.key === Qt.Key_Left) {
                        next--;
                    } else if (event.key === Qt.Key_Right) {
                        next++;
                    } else if (event.key === Qt.Key_Up) {
                        next -= 3;
                    } else if (event.key === Qt.Key_Down) {
                        next += 3;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        choose(currentIndex);
                        event.accepted = true;
                        return;
                    } else if (event.key === Qt.Key_Escape) {
                        root.close();
                        event.accepted = true;
                        return;
                    } else {
                        return;
                    }
                    currentIndex = Math.max(0, Math.min(count - 1, next));
                    event.accepted = true;
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
                        color: Colors.on_sf
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
                            color: Colors.bg
                            opacity: mouse.pressed ? 0.28 : mouse.containsMouse ? 0 : 0.15

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
                            color: Colors.sf
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

    Animations {
        id: animation
        target: panel

        enterX: 0
        enterY: 100

        exitX: 0
        exitY: 100

        onExited: GlobalStates.wallpaperPickerVisible = false
    }

    Connections {
        target: GlobalStates

        function onWallpaperCloseRequested() {
            root.close();
        }
    }

    Component.onCompleted: animation.startEnter()
}
