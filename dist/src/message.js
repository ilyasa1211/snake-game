"use strict";
class Message {
}
class CenterMessage extends Message {
    constructor(message, color = "white", font = "50px Arial") {
        super();
        this.message = message;
        this.color = color;
        this.font = font;
    }
    exec(context) {
        context.font = this.font;
        context.fillStyle = this.color;
        let measureText = context.measureText(this.message);
        context.fillText(this.message, (canvas.width * canvas.multiplier - measureText.width) / 2, (canvas.height * canvas.multiplier +
            measureText.actualBoundingBoxAscent) /
            2);
    }
}
