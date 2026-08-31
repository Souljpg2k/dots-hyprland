import qs.Appearance
import QtQuick
import QtQuick.Effects

Rectangle {
    id: root
    color: Appearance.background
    radius: Appearance.radius
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Appearance.shadow
        shadowBlur: 0.4
    }
}