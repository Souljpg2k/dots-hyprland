import qs.Services
import Quickshell
import Quickshell.Hyprland

Scope {
    id: root

    GlobalShortcut {
        name: "lock"
        description: "Lock screen"
        onPressed: GlobalStates.screenLocked = true
    }
    GlobalShortcut {
        name: "wallpaper"
        description: "Toggle WallpaperPicker"
        onPressed: GlobalStates.toggleWallpaperPicker()
    }
    GlobalShortcut {
        name: "user"
        description: "Toggle UserWidget"
        onPressed: GlobalStates.toggleUserWidgets()
    }
    GlobalShortcut {
        name: "clock"
        description: "Toggle ClockWidget"
        onPressed: GlobalStates.toggleClock()
    }
    GlobalShortcut {
        name: "sys"
        description: "Toggle SystemMonitor"
        onPressed: GlobalStates.toggleSysWidgets()
    }
    GlobalShortcut {
        name: "power"
        description: "Toggle PowerMenu"
        onPressed: GlobalStates.togglePowerMenu()
    }
    GlobalShortcut {
        name: "darkmode"
        description: "DarkMode"
        onPressed: Wallpapers.toggleDarkMode()
    }
}
