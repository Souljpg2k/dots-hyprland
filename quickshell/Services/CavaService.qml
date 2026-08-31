pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property int barCount: 50
    readonly property real maxValue: 1000
    property var levels: []

    Process {
        running: true
        command: ["cava", "-p", Quickshell.env("HOME") + "/.config/quickshell/Components/Cava/raw_output.txt"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                root.levels = data.split(";").filter(v => v.length > 0).map(Number);
            }
        }
    }
}
