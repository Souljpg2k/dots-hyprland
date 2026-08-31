pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: root

    property MprisPlayer trackedPlayer: null
    property MprisPlayer activePlayer: trackedPlayer ?? root.firstPlayer()

    property var activeTrack: ({
            uniqueId: 0,
            artUrl: "",
            title: "Unknown Title",
            artist: "Unknown Artist",
            album: "Unknown Album"
        })

    property bool __reverse: false

    function firstPlayer(): MprisPlayer {
        return Mpris.players.values[0] ?? null;
    }

    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData
            target: modelData
            Component.onCompleted: {
                if (root.trackedPlayer == null || modelData.isPlaying) {
                    root.trackedPlayer = modelData;
                }
            }

            Component.onDestruction: {
                if (root.trackedPlayer == modelData) {
                    root.trackedPlayer = null;
                    for (const player of Mpris.players.values) {
                        if (player.isPlaying) {
                            root.trackedPlayer = player;
                            break;
                        }
                    }
                    if (root.trackedPlayer == null) {
                        root.trackedPlayer = root.firstPlayer();
                    }
                }
            }

            function onPlaybackStateChanged() {
                if (modelData.isPlaying)
                    root.trackedPlayer = modelData;
            }
        }
    }

    Connections {
        target: root.activePlayer
        function onPostTrackChanged() {
            root.updateTrack();
        }
        function onTrackArtUrlChanged() {
            if (root.activePlayer && root.activePlayer.uniqueId === root.activeTrack.uniqueId && root.activePlayer.trackArtUrl !== root.activeTrack.artUrl) {
                const r = root.__reverse;
                root.updateTrack();
                root.__reverse = r;
            }
        }
    }

    onActivePlayerChanged: root.updateTrack()

    function updateTrack() {
        root.activeTrack = {
            uniqueId: root.activePlayer?.uniqueId ?? 0,
            artUrl: root.activePlayer?.trackArtUrl ?? "",
            title: root.activePlayer?.trackTitle || "Unknown Title",
            artist: root.activePlayer?.trackArtist || "Unknown Artist",
            album: root.activePlayer?.trackAlbum || "Unknown Album"
        };
        root.__reverse = false;
    }

    property bool canTogglePlaying: root.activePlayer?.canTogglePlaying ?? false
    function togglePlaying() {
        if (root.canTogglePlaying)
            root.activePlayer.togglePlaying();
    }

    property bool canGoPrevious: root.activePlayer?.canGoPrevious ?? false
    function previous() {
        if (root.canGoPrevious) {
            root.__reverse = true;
            root.activePlayer.previous();
        }
    }

    property bool canGoNext: root.activePlayer?.canGoNext ?? false
    function next() {
        if (root.canGoNext) {
            root.__reverse = false;
            root.activePlayer.next();
        }
    }
}
