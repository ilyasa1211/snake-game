var canvas = document.querySelector("canvas");
var context = canvas.getContext("2d");
const SNAKE_SIZE = 10;
canvas.width = 30 * SNAKE_SIZE;
canvas.height = 40 * SNAKE_SIZE;
const SNAKE = {
    directionXY: [1, 0],
    speed: 1,
    positionX: Math.floor(canvas.width / 2),
    positionY: Math.floor(canvas.height / 2),
};
canvas.style.backgroundColor = "rgb(46,46,46)";
window.addEventListener("keydown", function (event) {
    if (event.key === "ArrowLeft")
        SNAKE.directionXY = [-1, 0];
    if (event.key === "ArrowRight")
        SNAKE.directionXY = [1, 0];
    if (event.key === "ArrowDown")
        SNAKE.directionXY = [0, 1];
    if (event.key === "ArrowUp")
        SNAKE.directionXY = [0, -1];
});
window.requestAnimationFrame(() => game(context));
let move = setInterval(() => {
    const nextPosX = SNAKE.positionX +
        SNAKE.directionXY[0] * SNAKE.speed * SNAKE_SIZE;
    const nextPosY = SNAKE.positionY +
        SNAKE.directionXY[1] * SNAKE.speed * SNAKE_SIZE;
    SNAKE.positionX = Math.max(Math.min(nextPosX, canvas.width - SNAKE_SIZE), 0);
    SNAKE.positionY = Math.max(Math.min(nextPosY, canvas.height - SNAKE_SIZE), 0);
}, 200);
function game(context) {
    clearCanvas(context);
    context.fillStyle = "white";
    drawSnake(context);
    window.requestAnimationFrame(() => game(context));
}
function drawSnake(context) {
    context.beginPath();
    context.fillRect(SNAKE.positionX, SNAKE.positionY, SNAKE_SIZE, SNAKE_SIZE);
    context.fill();
    context.closePath();
}
function clearCanvas(context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
}
