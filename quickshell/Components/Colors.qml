pragma Singleton

import qs.Appearance
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property color primary: Appearance.primary
    readonly property color pf: Appearance.primary_fixed
    readonly property color bg: Appearance.background
    readonly property color on_bg: Appearance.on_background
    readonly property color shadow: Appearance.shadow
    readonly property color sf: Appearance.secondary_fixed
    readonly property color on_sf: Appearance.on_secondary_fixed_variant
    readonly property color error: Appearance.error
    readonly property color tertiary: Appearance.tertiary
    readonly property color outline: Appearance.outline
}