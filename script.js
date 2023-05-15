var canvas = document.querySelector("canvas");
var context = canvas.getContext("2d");
var Meat = /** @class */ (function () {
    function Meat(_a) {
        var size = _a.size;
        this.size = size;
        this.positionX = getIntegerRandomNumberBetween(0, TILE.width) *
            this.size;
        this.positionY = getIntegerRandomNumberBetween(0, TILE.height) *
            this.size;
    }
    return Meat;
}());
var Snake = /** @class */ (function () {
    function Snake(snake) {
        this.directionXY = snake.directionXY;
        this.speed = snake.speed;
        this.size = snake.size;
        this.positionX = snake.positionX * this.size;
        this.positionY = snake.positionY * this.size;
    }
    return Snake;
}());
var TILE = {
    width: 30,
    height: 40,
};
var DIRECTION = {
    left: [-1, 0],
    right: [1, 0],
    down: [0, 1],
    up: [0, -1],
};
var SNAKE = new Snake({
    directionXY: [1, 0],
    speed: 1,
    size: 10,
    positionX: Math.floor(TILE.width / 2),
    positionY: Math.floor(TILE.height / 2),
});
var MEAT = new Meat(SNAKE);
var TAIL = [];
var PREVIOUS = {
    positionX: 0,
    positionY: 0,
};
canvas.width = TILE.width * SNAKE.size;
canvas.height = TILE.height * SNAKE.size;
canvas.style.backgroundColor = "rgb(46,46,46)";
window.addEventListener("keydown", function (event) {
    if (event.key === "ArrowLeft" && directionIsNot(DIRECTION.right, SNAKE)) {
        SNAKE.directionXY = DIRECTION.left;
    }
    else if (event.key === "ArrowRight" && directionIsNot(DIRECTION.left, SNAKE))
        SNAKE.directionXY = DIRECTION.right;
    else if (event.key === "ArrowDown" && directionIsNot(DIRECTION.up, SNAKE)) {
        SNAKE.directionXY = DIRECTION.down;
    }
    else if (event.key === "ArrowUp" && directionIsNot(DIRECTION.down, SNAKE)) {
        SNAKE.directionXY = DIRECTION.up;
    }
});
window.requestAnimationFrame(function () { return game(context, TAIL, SNAKE, MEAT); });
var moveId = setInterval(function () { return move(SNAKE, PREVIOUS, MEAT, TAIL, TILE); }, 100);
function directionIsNot(direction, snake) {
    return direction.toString() !== snake.directionXY.toString();
}
function updateTailPosition(previous, tails) {
    for (var index = tails.length - 1; index >= 0; index--) {
        tails[index].positionX = index === 0
            ? previous.positionX
            : tails[index - 1].positionX;
        tails[index].positionY = index === 0
            ? previous.positionY
            : tails[index - 1].positionY;
    }
}
function move(snake, previous, meat, tails, tile) {
    var nextPosX = snake.positionX +
        snake.directionXY[0] * snake.speed * snake.size;
    var nextPosY = snake.positionY +
        snake.directionXY[1] * snake.speed * snake.size;
    previous.positionX = snake.positionX;
    previous.positionY = snake.positionY;
    snake.positionX = Math.max(Math.min(nextPosX, canvas.width - snake.size), 0);
    snake.positionY = Math.max(Math.min(nextPosY, canvas.height - snake.size), 0);
    if (isEatThePrey(snake, meat)) {
        meat.positionX = getIntegerRandomNumberBetween(0, tile.width) * snake.size;
        meat.positionY = getIntegerRandomNumberBetween(0, tile.height) * snake.size;
        tails.push({
            positionX: previous.positionX,
            positionY: previous.positionY,
        });
    }
    updateTailPosition(previous, tails);
}
function game(context, tails, snake, meat) {
    clearCanvas(context);
    context.fillStyle = "white";
    drawSnake(context, snake);
    drawTail(context, tails, snake);
    drawFood(context, meat);
    window.requestAnimationFrame(function () { return game(context, tails, snake, meat); });
}
function drawSnake(context, snake) {
    context.beginPath();
    context.fillRect(snake.positionX, snake.positionY, snake.size, snake.size);
    context.fill();
    context.closePath();
}
function drawFood(context, meat) {
    context.fillStyle = "red";
    context.beginPath();
    context.rect(meat.positionX, meat.positionY, meat.size, meat.size);
    context.fill();
    context.closePath();
}
function drawTail(context, tails, snake) {
    context.fillStyle = "white";
    tails.forEach(function (tail) {
        context.beginPath();
        context.rect(tail.positionX, tail.positionY, snake.size, snake.size);
        context.fill();
        context.closePath();
    });
}
function isEatThePrey(snake, meat) {
    var foodCenterPositionX = meat.positionX + meat.size / 2;
    var foodCenterPositionY = meat.positionY + meat.size / 2;
    var isEatInX = foodCenterPositionX > snake.positionX &&
        foodCenterPositionX < snake.positionX + snake.size;
    var isEatInY = foodCenterPositionY > snake.positionY &&
        foodCenterPositionY < snake.positionY + snake.size;
    var isPreyInsideSnakeMouth = isEatInX && isEatInY;
    return isPreyInsideSnakeMouth;
}
function clearCanvas(context) {
    context.clearRect(0, 0, canvas.width, canvas.height);
}
function getIntegerRandomNumberBetween(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}
