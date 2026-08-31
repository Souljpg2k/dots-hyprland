pragma Singleton

import Quickshell

Singleton {
    id: root

    function setVolume(c) {
        Quickshell.execDetached([
            "wpctl", 
            "set-volume", 
            "-l", "1", "@DEFAULT_AUDIO_SINK@", 
            c
        ]);
    }

    function volumeUp() {
        setVolume("5%+");
    }

    function volumeDown() {
        setVolume("5%-");
    }
}
