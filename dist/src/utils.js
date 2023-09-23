"use strict";
class Utils {
    static getIntegerRandomNumberBetween(min, max) {
        return Math.floor(Math.random() * (max - min) + min);
    }
    static getCanvasMiddlePosition(canvas) {
        return {
            positionX: Math.floor(canvas.width / 2),
            positionY: Math.floor(canvas.height / 2),
        };
    }
}
