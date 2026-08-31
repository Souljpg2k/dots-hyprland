pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property int temperatureK: 4500
    property bool enabled: false

    function toggle() {
        enabled = !enabled;
        Quickshell.execDetached(enabled
            ? ["hyprctl", "hyprsunset", "temperature", String(temperatureK)]
            : ["hyprctl", "hyprsunset", "identity"]);
    }
}