import qs.Widgets
import qs.Components
import qs.Components.Bar
import qs.Components.Lockscreen
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: root

    Bar {}
    GlobalShortcuts {}
    ScreenCorner {}

    LazyLoader {
        active: GlobalStates.powerMenuVisible
        component: PowerMenu {}
    }
    LazyLoader {
        active: GlobalStates.sysWidgetsVisible
        component: SysWidget {}
    }
    LazyLoader {
        active: GlobalStates.userWidgetsVisible
        component: UserWidget {}
    }
    LazyLoader {
        active: GlobalStates.clockVisible || GlobalStates.clockClosing
        component: ClockWidget {}
    }
    LazyLoader {
        active: GlobalStates.wallpaperPickerVisible
        component: WallpaperPicker {}
    }

    LockContext {
        id: lockContext
    }
    WlSessionLock {
        id: sessionLock
        locked: GlobalStates.screenLocked

        WlSessionLockSurface {
            color: "transparent"

            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }
}
