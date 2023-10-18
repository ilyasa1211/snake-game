var htmlCanvas = document.querySelector("canvas") as HTMLCanvasElement;
var context = htmlCanvas.getContext("2d") as CanvasRenderingContext2D;

if (!context) {
  throw new Error("Your browser does not support Canvas 2d");
}

type Coordinate = -1 | 0 | 1;

type TSnake = {
  directionXY: [Coordinate, Coordinate];
  speed: number;
  size: number;
  positionX: number[];
  positionY: number[];
  color: string;
};
type Position = {
  positionX: number;
  positionY: number;
};

const snakeSize = 10;
const canvas = new Canvas(htmlCanvas, 30, 40, snakeSize);
const snake: Snake = new Snake({
  directionXY: Direction.RIGHT,
  speed: 1,
  size: snakeSize,
  positionX: [Utils.getCanvasMiddlePosition(canvas).positionX],
  positionY: [Utils.getCanvasMiddlePosition(canvas).positionY],
  color: "white",
});
const food: Food = new Food(snakeSize);
const control = new Control(snake);
const game = new Game(snake, food, canvas, control);

let requestId: number = window.requestAnimationFrame(main);

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
