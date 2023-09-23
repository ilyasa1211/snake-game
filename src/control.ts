
class Control {
    public constructor(public snake: Snake) { }
    public init(): void {
        window.addEventListener("keydown", (event: KeyboardEvent): void => {
            if (event.key === "ArrowLeft" && !Direction.isSameDirection(Direction.RIGHT, this.snake.directionXY)) {
                this.snake.directionXY = Direction.LEFT;
            }
            if (event.key === "ArrowRight" && !Direction.isSameDirection(Direction.LEFT, this.snake.directionXY)) {
                this.snake.directionXY = Direction.RIGHT;
            }
            if (event.key === "ArrowDown" && !Direction.isSameDirection(Direction.UP, this.snake.directionXY)) {
                this.snake.directionXY = Direction.DOWN;
            }
            if (event.key === "ArrowUp" && !Direction.isSameDirection(Direction.DOWN, this.snake.directionXY)) {
                this.snake.directionXY = Direction.UP;
            }
        });
    }
}