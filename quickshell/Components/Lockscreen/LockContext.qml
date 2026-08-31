import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked()
    signal flashMsg()

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false

    onCurrentTextChanged: showFailure = false

    function tryUnlock(): void {
        if (currentText === "" || unlockInProgress) return
        unlockInProgress = true
        passwd.start()
    }

    PamContext {
        id: passwd
        config: "quickshell"
        configDirectory: "pam.d"
        onPamMessage: {
            if (this.responseRequired) {
                this.respond(root.currentText)
            }
        }
        onCompleted: result => {
            root.unlockInProgress = false
            if (result === PamResult.Success) {
                root.unlocked()
            } else {
                root.currentText = ""
                root.showFailure = true
                root.flashMsg()
            }
        }
    }
}