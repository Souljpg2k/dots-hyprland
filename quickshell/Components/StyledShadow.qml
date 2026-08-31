import qs.Appearance
import QtQuick.Effects

RectangularShadow {
    anchors.centerIn: parent
    radius: Appearance.radius + 4
    color: Appearance.shadow
    opacity: 0.6
    blur: 5
    spread: 1
}
