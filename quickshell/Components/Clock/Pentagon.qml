import qs.Appearance
import QtQuick

Canvas {
    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        ctx.fillStyle = Appearance.secondary_fixed
        const r = 5
        ctx.beginPath()
        ctx.moveTo(9.5, 7)
        ctx.arcTo(19, 0, 38, 14, r)
        ctx.arcTo(38, 14, 31, 36, r)
        ctx.arcTo(31, 36, 7, 36, r)
        ctx.arcTo(7, 36, 0, 14, r)
        ctx.arcTo(0, 14, 19, 0, r)
        ctx.closePath()
        ctx.fill()
    }
}