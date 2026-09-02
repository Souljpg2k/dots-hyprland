import QtQuick

SequentialAnimation {
    id: root

    property Item target

    property real enterX: 0
    property real enterY: 0
    property real exitX: 0
    property real exitY: 0

    property real enterRotation: 0
    property real exitRotation: 0
    property real scaleOvershoot: 1.1

    property bool closing: false

    signal entered
    signal exited

    ParallelAnimation {
        NumberAnimation {
            target: root.target
            property: "opacity"
            from: root.closing ? root.target.opacity : 0
            to: root.closing ? 0 : 1
            duration: root.closing ? 200 : 260
            easing.type: root.closing ? Easing.InCubic : Easing.OutCubic
        }

        NumberAnimation {
            target: root.target
            property: "x"
            from: root.closing ? root.target.x : root.enterX
            to: root.closing ? root.exitX : 0
            duration: root.closing ? 220 : 320
            easing.type: root.closing ? Easing.InCubic : Easing.OutCubic
        }

        NumberAnimation {
            target: root.target
            property: "y"
            from: root.closing ? root.target.y : root.enterY
            to: root.closing ? root.exitY : 0
            duration: root.closing ? 220 : 320
            easing.type: root.closing ? Easing.InCubic : Easing.OutCubic
        }

        NumberAnimation {
            target: root.target
            property: "scale"
            from: root.closing ? root.target.scale : 0.94
            to: root.closing ? 0.94 : 1
            duration: root.closing ? 220 : 320
            easing.type: root.closing ? Easing.InCubic : Easing.OutBack
            easing.overshoot: root.scaleOvershoot
        }

        NumberAnimation {
            target: root.target
            property: "rotation"
            from: root.closing ? root.target.rotation : root.enterRotation
            to: root.closing ? root.exitRotation : 0
            duration: root.closing ? 220 : 320
            easing.type: root.closing ? Easing.InCubic : Easing.OutBack
        }
    }

    ScriptAction {
        script: {
            if (root.closing)
                root.exited();
            else
                root.entered();
        }
    }

    function startEnter() {
        stop();

        closing = false;
        target.x = enterX;
        target.y = enterY;
        target.opacity = 0;
        target.scale = 0.94;
        target.rotation = enterRotation;

        start();
    }

    function startExit() {
        stop();

        closing = true;
        start();
    }
}
