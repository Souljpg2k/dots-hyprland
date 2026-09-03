import qs.Appearance
import qs.Components
import QtQuick.Effects

RectangularShadow {
    anchors.centerIn: parent
    radius: Appearance.radius
    color: Colors.shadow
    opacity: 0.6
    blur: 5
    spread: 1
}