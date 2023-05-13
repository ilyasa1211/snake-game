var canvas = document.querySelector("canvas");
var context = canvas.getContext("2d");
class Meat {
    constructor({ size }) {
        this.size = size;
        this.positionX = getIntegerRandomNumberBetween(0, TILE.width) *
            this.size;
        this.positionY = getIntegerRandomNumberBetween(0, TILE.height) *
            this.size;
    }
}
class Reptile {
    constructor(snake) {
        this.directionXY = snake.directionXY;
        this.speed = snake.speed;
        this.size = snake.size;
        this.positionX = snake.positionX * this.size;
        this.positionY = snake.positionY * this.size;
    }
}
const TILE = {
    width: 30,
    height: 40,
};
const SNAKE = new Reptile({
    directionXY: [1, 0],
    speed: 1,
    size: 10,
    positionX: Math.floor(TILE.width / 2),
    positionY: Math.floor(TILE.height / 2),
});
const FOOD = new Meat(SNAKE);
const TAIL = [];
const PREVIOUS = {
    positionX: 0,
    positionY: 0,
};
canvas.width = TILE.width * SNAKE.size;
canvas.height = TILE.height * SNAKE.size;
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
window.requestAnimationFrame(() => game(context, PREVIOUS, TAIL));
let move = setInterval(() => {
    const nextPosX = SNAKE.positionX +
        SNAKE.directionXY[0] * SNAKE.speed * SNAKE.size;
    const nextPosY = SNAKE.positionY +
        SNAKE.directionXY[1] * SNAKE.speed * SNAKE.size;
    PREVIOUS.positionX = SNAKE.positionX;
    PREVIOUS.positionY = SNAKE.positionY;
    SNAKE.positionX = Math.max(Math.min(nextPosX, canvas.width - SNAKE.size), 0);
    SNAKE.positionY = Math.max(Math.min(nextPosY, canvas.height - SNAKE.size), 0);
    if (isEatThePrey(SNAKE, FOOD)) {
        FOOD.positionX = getIntegerRandomNumberBetween(0, TILE.width) * SNAKE.size;
        FOOD.positionY = getIntegerRandomNumberBetween(0, TILE.height) * SNAKE.size;
        TAIL.push({
            positionX: PREVIOUS.positionX,
            positionY: PREVIOUS.positionY,
        });
    }
    for (let index = TAIL.length - 1; index >= 0; index--) {
        TAIL[index].positionX = index === 0
            ? PREVIOUS.positionX
            : TAIL[index - 1].positionX;
        TAIL[index].positionY = index === 0
            ? PREVIOUS.positionY
            : TAIL[index - 1].positionY;
    }
}, 100);
function game(context, previous, tails) {
    clearCanvas(context);
    context.fillStyle = "white";
    drawSnake(context);
    drawTail(context, previous, tails);
    drawFood(context, FOOD);
    window.requestAnimationFrame(() => game(context, previous, tails));
}
function drawSnake(context) {
    context.beginPath();
    context.fillRect(SNAKE.positionX, SNAKE.positionY, SNAKE.size, SNAKE.size);
    context.fill();
    context.closePath();
}
function drawFood(context, food) {
    context.fillStyle = "red";
    context.beginPath();
    context.rect(food.positionX, food.positionY, food.size, food.size);
    context.fill();
    context.closePath();
}
function drawTail(context, prev, tails) {
    context.fillStyle = "white";
    tails.forEach((tail) => {
        context.beginPath();
        context.rect(tail.positionX, tail.positionY, SNAKE.size, SNAKE.size);
        context.fill();
        context.closePath();
    });
}
function isEatThePrey(snake, food) {
    const foodCenterPositionX = food.positionX + food.size / 2;
    const foodCenterPositionY = food.positionY + food.size / 2;
    const isEatInX = foodCenterPositionX > snake.positionX &&
        foodCenterPositionX < snake.positionX + snake.size;
    const isEatInY = foodCenterPositionY > snake.positionY &&
        foodCenterPositionY < snake.positionY + snake.size;
    const isEat = isEatInX && isEatInY;
    return isEat;
}
function clearCanvas(context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
}
function getIntegerRandomNumberBetween(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}
