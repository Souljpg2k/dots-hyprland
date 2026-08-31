pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    function run(command: string): void {
        Quickshell.execDetached(["sh", "-c", command])
    }

    function lock(): void {
        run("loginctl lock-session")
    }

    function logout(): void {
        run("hyprshutdown -t 'Logging out...' --post-cmd 'hyprctl dispatch exit'")
    }

    function restart(): void {
        run("hyprshutdown -t 'Restarting...' --post-cmd 'reboot'")
    }

    function shutdown(): void {
        run("hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'")
    }
}