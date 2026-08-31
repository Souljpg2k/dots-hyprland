import qs.Appearance
import qs.Components
import Quickshell
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: bar
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 35
    color: Appearance.on_secondary

    property int h: 30

    RowLayout {
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        Item {
            width: 260
            height: bar.h

            RowLayout {
                anchors.fill: parent
                spacing: 7

                AppSearch {
                    Layout.leftMargin: 3
                }
                ActiveWindow {}
                MediaPlayer {}
            }
        }
    }

    Item {
        anchors.centerIn: parent
        width: 390
        height: bar.h

        RowLayout {
            anchors.centerIn: parent
            spacing: -2

            UserName {}
            Workspaces {}
            SysButton {}
            HyprlandXkb {}
        }
    }

    RowLayout {
        anchors {
            right: parent.right
            rightMargin: 20
            verticalCenter: parent.verticalCenter
        }

        Item {
            width: 195
            height: bar.h

            RowLayout {
                anchors.fill: parent
                spacing: -1

                Item {
                    width: 75
                    height: 24
                    Layout.leftMargin: 3

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: -8

                        Hyprshot {}
                        HyprPicker {}
                        DarkModeBtn {}
                    }
                }

                DateTime {}
            }
        }
    }
}