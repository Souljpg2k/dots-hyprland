import qs.Appearance
import QtQuick
import QtQuick.Effects

Rectangle {
    id: root
    color: Colors.bg
    radius: Appearance.radius
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Colors.shadow
        shadowBlur: 0.4
    }
}