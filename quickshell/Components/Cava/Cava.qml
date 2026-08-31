import qs.Appearance
import qs.Services
import QtQuick

Canvas {
    id: cavaCanvas
    anchors.fill: parent

    Connections {
        target: CavaService
        function onLevelsChanged() {
            cavaCanvas.requestPaint();
        }
    }

    onPaint: {
        const ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);
        const levels = CavaService.levels;
        if (!levels.length)
            return;
        const step = width / (levels.length - 1);
        const y = i => height - (levels[i] / CavaService.maxValue) * 24;
        ctx.fillStyle = Appearance.primary_fixed;
        ctx.globalAlpha = 0.35;
        ctx.beginPath();
        ctx.moveTo(0, height);
        ctx.lineTo(0, y(0));
        for (let i = 0; i < levels.length - 1; i++)
            ctx.quadraticCurveTo(i * step, y(i), (i + 0.5) * step, (y(i) + y(i + 1)) / 2);
        ctx.lineTo(width, y(levels.length - 1));
        ctx.lineTo(width, height);
        ctx.fill();
    }
}
