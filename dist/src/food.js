"use strict";
class Food {
    constructor(size, color = 'red') {
        this.size = size;
        this.color = color;
        this.positionX = 0;
        this.positionY = 0;
    }
    setPosition(positionX, positionY) {
        this.positionX = positionX;
        this.positionY = positionY;
    }
    draw(context) {
        context.fillStyle = "red";
        context.beginPath();
        context.rect(this.positionX, this.positionY, this.size, this.size);
        context.fill();
        context.closePath();
    }
}
