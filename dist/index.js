"use strict";
var htmlCanvas = document.querySelector("canvas");
var context = htmlCanvas.getContext("2d");
if (!context) {
    console.error("Your browser does not support Canvas 2d");
}
const snakeSize = 10;
const canvas = new Canvas(htmlCanvas, 30, 40, snakeSize);
const snake = new Snake({
    directionXY: Direction.RIGHT,
    speed: 1,
    size: snakeSize,
    positionX: [Utils.getCanvasMiddlePosition(canvas).positionX],
    positionY: [Utils.getCanvasMiddlePosition(canvas).positionY],
    color: "white",
});
const food = new Food(snakeSize);
const control = new Control(snake);
const game = new Game(snake, food, canvas, control);
let requestId = window.requestAnimationFrame(main);
function main() {
    if (game.isGameOver()) {
        game.setMessage(new CenterMessage("Game Over!"));
        return window.cancelAnimationFrame(requestId);
    }
    canvas.clear();
    game.play();
    setTimeout(() => {
        requestId = window.requestAnimationFrame(main);
    }, 1000 / 10);
}
