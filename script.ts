var canvas = document.querySelector("canvas") as HTMLCanvasElement;
var context = canvas.getContext("2d") as CanvasRenderingContext2D;

type Direction = -1 | 0 | 1;
type Snake = {
  directionXY: Array<Direction>;
  speed: number;
  positionX: number;
  positionY: number;
};

const SNAKE_SIZE: number = 10;

canvas.width = 30 * SNAKE_SIZE;
canvas.height = 40 * SNAKE_SIZE;

const SNAKE: Snake = {
  directionXY: [1, 0],
  speed: 1,
  positionX: Math.floor(canvas.width / 2),
  positionY: Math.floor(canvas.height / 2),
};
canvas.style.backgroundColor = "rgb(46,46,46)";

window.addEventListener("keydown", function (event: KeyboardEvent): void {
  if (event.key === "ArrowLeft") SNAKE.directionXY = [-1, 0];
  if (event.key === "ArrowRight") SNAKE.directionXY = [1, 0];
  if (event.key === "ArrowDown") SNAKE.directionXY = [0, 1];
  if (event.key === "ArrowUp") SNAKE.directionXY = [0, -1];
});

window.requestAnimationFrame(() => game(context));

let move: number = setInterval((): void => {
  const nextPosX: number = SNAKE.positionX +
    SNAKE.directionXY[0] * SNAKE.speed * SNAKE_SIZE;
  const nextPosY: number = SNAKE.positionY +
    SNAKE.directionXY[1] * SNAKE.speed * SNAKE_SIZE;
  SNAKE.positionX = Math.max(Math.min(nextPosX, canvas.width - SNAKE_SIZE), 0);
  SNAKE.positionY = Math.max(Math.min(nextPosY, canvas.height - SNAKE_SIZE), 0);
}, 200);

function game(context: CanvasRenderingContext2D): void {
  clearCanvas(context);
  context.fillStyle = "white";
  drawSnake(context);
  window.requestAnimationFrame(() => game(context));
}
function drawSnake(context: CanvasRenderingContext2D): void {
  context.beginPath();
  context.fillRect(SNAKE.positionX, SNAKE.positionY, SNAKE_SIZE, SNAKE_SIZE);
  context.fill();
  context.closePath();
}

function clearCanvas(context: CanvasRenderingContext2D): void {
  context.clearRect(0, 0, canvas.width, canvas.height);
}
