var canvas = document.querySelector("canvas") as HTMLCanvasElement;
var context = canvas.getContext("2d") as CanvasRenderingContext2D;

type Direction = -1 | 0 | 1;
interface Reptile {
  directionXY: Array<Direction>;
  speed: number;
  size: number;
  positionX: number;
  positionY: number;
}
type Previous = {
  positionX: number;
  positionY: number;
};
type Tile = {
  width: number;
  height: number;
};
type Tail = {
  positionX: number;
  positionY: number;
};
interface Food {
  positionX: number;
  positionY: number;
  size: number;
}
class Meat implements Food {
  public size: number;
  public positionX: number;
  public positionY: number;

  constructor({ size }: Reptile) {
    this.size = size;
    this.positionX = getIntegerRandomNumberBetween(0, TILE.width) *
      this.size;
    this.positionY = getIntegerRandomNumberBetween(0, TILE.height) *
      this.size;
  }
}
class Snake implements Reptile {
  public directionXY: Direction[];
  public speed: number;
  public size: number;
  public positionX: number;
  public positionY: number;
  constructor(snake: Reptile) {
    this.directionXY = snake.directionXY;
    this.speed = snake.speed;
    this.size = snake.size;
    this.positionX = snake.positionX * this.size;
    this.positionY = snake.positionY * this.size;
  }
}

const TILE: Tile = {
  width: 30,
  height: 40,
};

const SNAKE: Snake = new Snake({
  directionXY: [1, 0],
  speed: 1,
  size: 10,
  positionX: Math.floor(TILE.width / 2),
  positionY: Math.floor(TILE.height / 2),
});

const MEAT: Meat = new Meat(SNAKE);

const TAIL: Array<Tail> = [];

const PREVIOUS: Previous = {
  positionX: 0,
  positionY: 0,
};

canvas.width = TILE.width * SNAKE.size;
canvas.height = TILE.height * SNAKE.size;
canvas.style.backgroundColor = "rgb(46,46,46)";

window.addEventListener("keydown", function (event: KeyboardEvent): void {
  if (event.key === "ArrowLeft") SNAKE.directionXY = [-1, 0];
  else if (event.key === "ArrowRight") SNAKE.directionXY = [1, 0];
  else if (event.key === "ArrowDown") SNAKE.directionXY = [0, 1];
  else if (event.key === "ArrowUp") SNAKE.directionXY = [0, -1];
});

window.requestAnimationFrame(() => game(context, TAIL, SNAKE, MEAT));

let moveId: number = setInterval(
  () => move(SNAKE, PREVIOUS, MEAT, TAIL, TILE),
  100,
);

function updateTailPosition(previous: Previous, tails: Array<Tail>) {
  for (let index = tails.length - 1; index >= 0; index--) {
    tails[index].positionX = index === 0
      ? previous.positionX
      : tails[index - 1].positionX;
    tails[index].positionY = index === 0
      ? previous.positionY
      : tails[index - 1].positionY;
  }
}

function move(
  snake: Snake,
  previous: Previous,
  meat: Meat,
  tails: Array<Tail>,
  tile: Tile,
) {
  const nextPosX: number = snake.positionX +
    snake.directionXY[0] * snake.speed * snake.size;
  const nextPosY: number = snake.positionY +
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

function game(
  context: CanvasRenderingContext2D,
  tails: Array<Tail>,
  snake: Snake,
  meat: Meat,
): void {
  clearCanvas(context);
  context.fillStyle = "white";
  drawSnake(context, snake);
  drawTail(context, tails, snake);
  drawFood(context, meat);
  window.requestAnimationFrame(() => game(context, tails, snake, meat));
}
function drawSnake(context: CanvasRenderingContext2D, snake: Snake): void {
  context.beginPath();
  context.fillRect(snake.positionX, snake.positionY, snake.size, snake.size);
  context.fill();
  context.closePath();
}
function drawFood(context: CanvasRenderingContext2D, meat: Meat): void {
  context.fillStyle = "red";
  context.beginPath();
  context.rect(
    meat.positionX,
    meat.positionY,
    meat.size,
    meat.size,
  );
  context.fill();
  context.closePath();
}
function drawTail(
  context: CanvasRenderingContext2D,
  tails: Array<Tail>,
  snake: Snake,
): void {
  context.fillStyle = "white";
  tails.forEach((tail: Tail) => {
    context.beginPath();
    context.rect(tail.positionX, tail.positionY, snake.size, snake.size);
    context.fill();
    context.closePath();
  });
}
function isEatThePrey(snake: Snake, meat: Meat): boolean {
  const foodCenterPositionX = meat.positionX + meat.size / 2;
  const foodCenterPositionY = meat.positionY + meat.size / 2;
  const isEatInX = foodCenterPositionX > snake.positionX &&
    foodCenterPositionX < snake.positionX + snake.size;
  const isEatInY = foodCenterPositionY > snake.positionY &&
    foodCenterPositionY < snake.positionY + snake.size;
  const isPreyInsideSnakeMouth = isEatInX && isEatInY;
  return isPreyInsideSnakeMouth;
}

function clearCanvas(context: CanvasRenderingContext2D): void {
  context.clearRect(0, 0, canvas.width, canvas.height);
}

function getIntegerRandomNumberBetween(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min) + min);
}
