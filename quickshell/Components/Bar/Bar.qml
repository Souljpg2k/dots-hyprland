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
    implicitHeight: 40
    color: Appearance.background

    property int h: 35

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
            HyprlandXkb {}
        }
    }

    RowLayout {
        anchors {
            right: parent.right
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }

        Item {
            width: 280
            height: bar.h

            RowLayout {
                anchors.fill: parent
                spacing: -24

                Item {
                    width: 100
                    height: 24

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: -8

                        Hyprshot {}
                        HyprPicker {}
                        DarkModeBtn {}
                    }
                }
                DateTime {}
                SysButton {}
            }
        }
    }
}