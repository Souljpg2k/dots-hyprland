import qs.Appearance
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

Instantiator {
    id: cornerInstantiator

    readonly property var cornerPlacements: [
        { pos: "TopLeft", gap: false }, { pos: "TopLeft", gap: true },
        { pos: "TopRight", gap: false }, { pos: "TopRight", gap: true },
        { pos: "BottomLeft", gap: false },
        { pos: "BottomRight", gap: false },
    ]

    model: cornerPlacements

    delegate: PanelWindow {
        id: root

        required property var modelData

        readonly property string placement: modelData.pos
        readonly property bool fillsBarGap: modelData.gap
        property color surfaceColor: Appearance.background

        readonly property int cornerSize: 26
        readonly property bool anchorsLeft: placement === "BottomLeft" || placement === "TopLeft"
        readonly property bool anchorsBottom: placement === "BottomLeft" || placement === "BottomRight"
        readonly property color fillColor: fillsBarGap ? Appearance.shadow : surfaceColor

        anchors {
            bottom: anchorsBottom
            top: !anchorsBottom
            left: anchorsLeft
            right: !anchorsLeft
        }

        color: "transparent"
        implicitWidth: cornerSize
        implicitHeight: cornerSize
        exclusionMode: fillsBarGap ? ExclusionMode.Ignore : ExclusionMode.Auto
        WlrLayershell.layer: WlrLayer.Top

        Shape {
            width: root.cornerSize
            height: root.cornerSize
            layer.enabled: true
            layer.samples: 4

            ShapePath {
                fillColor: root.fillColor
                strokeColor: "transparent"
                startX: root.anchorsLeft ? 0 : root.cornerSize
                startY: root.anchorsBottom ? root.cornerSize : 0

                PathLine {
                    x: root.anchorsLeft ? root.cornerSize : 0
                    y: root.anchorsBottom ? root.cornerSize : 0
                }

                PathQuad {
                    x: root.anchorsLeft ? 0 : root.cornerSize
                    y: root.anchorsBottom ? 0 : root.cornerSize
                    controlX: root.anchorsLeft ? 0 : root.cornerSize
                    controlY: root.anchorsBottom ? root.cornerSize : 0
                }

                PathLine {
                    x: root.anchorsLeft ? 0 : root.cornerSize
                    y: root.anchorsBottom ? root.cornerSize : 0
                }
            }
        }
    }
}