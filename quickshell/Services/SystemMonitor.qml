pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int cpuUsage: 0
    property int gpuUsage: 0
    property int memUsage: 0

    property real previousTotal: 0
    property real previousIdle: 0

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: line => {
                if (!line.startsWith("cpu "))
                    return;
                const p = line.trim().split(/\s+/);
                const idle = Number(p[4]) + Number(p[5]);
                const total = p.slice(1, 8).reduce((a, b) => a + Number(b), 0);
                if (root.previousTotal > 0) {
                    const totalDelta = total - root.previousTotal;
                    const idleDelta = idle - root.previousIdle;
                    if (totalDelta > 0)
                        root.cpuUsage = Math.max(0, Math.min(100, Math.round(100 * (1 - idleDelta / totalDelta))));
                }
                root.previousTotal = total;
                root.previousIdle = idle;
            }
        }
    }

    Process {
        id: gpuProc
        command: [
            "sh", 
            "-c", 
            "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 0"]
        stdout: SplitParser {
            onRead: data => {
                const usage = Number(data.trim());
                if (!isNaN(usage))
                    root.gpuUsage = Math.max(0, Math.min(100, Math.round(usage)));
            }
        }
    }

    Process {
        id: memProc
        command: [
            "awk", 
            "/MemTotal/{t=$2} /MemAvailable/{a=$2} END{if (t>0) print (t-a)*100/t}", 
            "/proc/meminfo"]
        stdout: SplitParser {
            onRead: data => {
                const usage = Number(data.trim());
                if (!isNaN(usage))
                    root.memUsage = Math.round(usage);
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            gpuProc.running = true;
            memProc.running = true;
        }
    }
}