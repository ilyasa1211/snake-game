var canvas = document.querySelector("canvas") as HTMLCanvasElement;
var context = canvas.getContext("2d") as CanvasRenderingContext2D;

type Direction = -1 | 0 | 1;
interface Snake {
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

  constructor({ size }: Snake) {
    this.size = size;
    this.positionX = getIntegerRandomNumberBetween(0, TILE.width) *
      this.size;
    this.positionY = getIntegerRandomNumberBetween(0, TILE.height) *
      this.size;
  }
}
class Reptile implements Snake {
  public directionXY: Direction[];
  public speed: number;
  public size: number;
  public positionX: number;
  public positionY: number;
  constructor(snake: Snake) {
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

const SNAKE: Reptile = new Reptile({
  directionXY: [1, 0],
  speed: 1,
  size: 10,
  positionX: Math.floor(TILE.width / 2),
  positionY: Math.floor(TILE.height / 2),
});

const FOOD: Meat = new Meat(SNAKE);

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
  if (event.key === "ArrowRight") SNAKE.directionXY = [1, 0];
  if (event.key === "ArrowDown") SNAKE.directionXY = [0, 1];
  if (event.key === "ArrowUp") SNAKE.directionXY = [0, -1];
});

window.requestAnimationFrame(() => game(context, PREVIOUS, TAIL));

let move: number = setInterval((): void => {
  const nextPosX: number = SNAKE.positionX +
    SNAKE.directionXY[0] * SNAKE.speed * SNAKE.size;
  const nextPosY: number = SNAKE.positionY +
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

function game(
  context: CanvasRenderingContext2D,
  previous: Previous,
  tails: Array<Tail>,
): void {
  clearCanvas(context);
  context.fillStyle = "white";
  drawSnake(context);
  drawTail(context, previous, tails);
  drawFood(context, FOOD);
  window.requestAnimationFrame(() => game(context, previous, tails));
}
function drawSnake(context: CanvasRenderingContext2D): void {
  context.beginPath();
  context.fillRect(SNAKE.positionX, SNAKE.positionY, SNAKE.size, SNAKE.size);
  context.fill();
  context.closePath();
}
function drawFood(context: CanvasRenderingContext2D, food: Food): void {
  context.fillStyle = "red";
  context.beginPath();
  context.rect(
    food.positionX,
    food.positionY,
    food.size,
    food.size,
  );
  context.fill();
  context.closePath();
}
function drawTail(
  context: CanvasRenderingContext2D,
  prev: Previous,
  tails: Array<Tail>,
): void {
  context.fillStyle = "white";
  tails.forEach((tail) => {
    context.beginPath();
    context.rect(tail.positionX, tail.positionY, SNAKE.size, SNAKE.size);
    context.fill();
    context.closePath();
  });
}
function isEatThePrey(snake: Snake, food: Food): boolean {
  const foodCenterPositionX = food.positionX + food.size / 2;
  const foodCenterPositionY = food.positionY + food.size / 2;
  const isEatInX = foodCenterPositionX > snake.positionX &&
    foodCenterPositionX < snake.positionX + snake.size;
  const isEatInY = foodCenterPositionY > snake.positionY &&
    foodCenterPositionY < snake.positionY + snake.size;
  const isEat = isEatInX && isEatInY;
  return isEat;
}

function clearCanvas(context: CanvasRenderingContext2D): void {
  context.clearRect(0, 0, canvas.width, canvas.height);
}

function getIntegerRandomNumberBetween(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min) + min);
}
