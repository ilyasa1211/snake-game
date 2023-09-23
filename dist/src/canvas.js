"use strict";
class Wall {
}
Wall.LEFT_BOUNDARY = "LEFT";
Wall.TOP_BOUNDARY = "TOP";
Wall.RIGHT_BOUNDARY = "RIGHT";
Wall.BOTTOM_BOUNDARY = "BOTTOM";
class Canvas extends Wall {
    constructor(canvas, width = 30, height = 40, multiplier = 1, backgroundColor = "rgb(46,46,46)") {
        super();
        this.canvas = canvas;
        this.width = width;
        this.height = height;
        this.multiplier = multiplier;
        this.backgroundColor = backgroundColor;
        this.context = this.canvas.getContext("2d");
    }
    create() {
        this.canvas.width = this.width * this.multiplier;
        this.canvas.height = this.height * this.multiplier;
        this.canvas.style.backgroundColor = this.backgroundColor;
    }
    clear() {
        this.context.clearRect(0, 0, this.width * this.multiplier, this.height * this.multiplier);
    }
}
