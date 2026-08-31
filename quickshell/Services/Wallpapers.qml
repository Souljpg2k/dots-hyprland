pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string home: Quickshell.env("HOME")
    property url wallpaperDir: "file://" + home + "/Wallpapers"
    property url wallpaperPath: ""
    property bool darkMode: false

    function path(value) {
        const p = String(value ?? "")
        return p.startsWith("file://") ? p.slice(7) : p
    }

    function fileUrl(value) {
        const p = String(value ?? "")
        return p.startsWith("file://") ? p : "file://" + p
    }

    function updateColors() {
        const p = path(wallpaperPath)
        if (!p)
            return

        Quickshell.execDetached([
            "matugen","image",p,
            "--source-color-index", "0",
            "-m", darkMode ? "dark" : "light"
        ])
    }

    function apply(value) {
        const p = path(value)
        if (!p)
            return

        wallpaperPath = fileUrl(p)

        Quickshell.execDetached([
            "awww", "img", p,
            "--transition-type", "random",
            "--transition-fps", "60",
            "--transition-duration", "2"
        ])
        updateColors()
    }

    function toggleDarkMode() {
        darkMode = !darkMode
        updateColors()
    }

    FolderListModel {
        id: model
        folder: root.wallpaperDir
        nameFilters: [
            "*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif",
            "*.JPG", "*.JPEG", "*.PNG", "*.WEBP", "*.GIF"
        ]
        showDirs: false
        showOnlyReadable: true
    }

    property alias wallpapers: model

    Process {
        id: query
        command: ["awww", "query"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                for (const line of lines) {
                    const index = line.indexOf("image:")
                    if (index < 0)
                        continue
                    const p = line.slice(index + 6).trim()
                    if (p) {
                        root.wallpaperPath = root.fileUrl(p)
                        break
                    }
                }
            }
        }
    }

    Component.onCompleted: query.running = true
}
