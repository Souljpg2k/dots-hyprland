pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string username: Quickshell.env("USER")
    readonly property string hostname: hostnameFile.text().trim()
    property string uptimeText: "..."

    FileView {
        id: hostnameFile
        path: "/etc/hostname"
    }

    Process {
        id: uptimeProc
        command: ["cat", "/proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: {
                const totalSeconds = parseFloat(text.trim().split(/\s+/)[0]);
                if (!isNaN(totalSeconds)) {
                    const h = Math.floor(totalSeconds / 3600);
                    const m = Math.floor((totalSeconds % 3600) / 60);
                    root.uptimeText = `up • ${h}h ${m}m`;
                }
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!uptimeProc.running)
                uptimeProc.running = true;
        }
    }
}