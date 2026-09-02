pragma Singleton

import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string home: Quickshell.env("HOME")
    property string wallpaperDir: home + "/Wallpapers"
    property string wallpaperPath: ""
    property alias darkMode: stateAdapter.darkMode
    property alias wallpapers: wallpaperModel

    FileView {
        path: Quickshell.stateDir + "/wallpaper.json"
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: stateAdapter
            property bool darkMode: false
        }
    }

    Timer {
        id: colorUpdateTimer
        interval: 500
        onTriggered: updateColors()
    }

    FolderListModel {
        id: wallpaperModel
        folder: "file://" + root.wallpaperDir
        showFiles: true
        showDirs: false
        showOnlyReadable: true
        nameFilters: [
            "*.jpg", "*.jpeg", "*.png", "*.webp", "*.gif",
            "*.JPG", "*.JPEG", "*.PNG", "*.WEBP", "*.GIF"
        ]
    }

    Process {
        id: wallpaperQuery
        command: ["awww", "query"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")

                for (const line of lines) {
                    const index = line.indexOf("image:")
                    if (index < 0)
                        continue

                    const currentPath = line.slice(index + 6).trim()
                    if (!currentPath)
                        continue

                    root.wallpaperPath = filePath(currentPath)
                    colorUpdateTimer.restart()
                    break
                }
            }
        }
    }

    function filePath(path) {
        const value = String(path)

        if (value.startsWith("file://"))
            return decodeURIComponent(value.replace("file://", ""))

        return value
    }

    function updateColors() {
        if (!wallpaperPath)
            return

        Quickshell.execDetached([
            "matugen",
            "image",
            wallpaperPath,
            "--source-color-index", "0",
            "-m",
            darkMode ? "dark" : "light"
        ])
    }

    function apply(p) {
        if (!p)
            return

        const path = filePath(p)
        wallpaperPath = path

        Quickshell.execDetached([
            "awww",
            "img",
            path,
            "--transition-type", "random",
            "--transition-fps", "60",
            "--transition-duration", "2"
        ])

        colorUpdateTimer.restart()
    }

    function toggleDarkMode() {
        darkMode = !darkMode
        colorUpdateTimer.restart()
    }

    Component.onCompleted: {
        wallpaperQuery.running = true
    }
}