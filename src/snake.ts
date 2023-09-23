class Snake {
  public directionXY: [Coordinate, Coordinate];
  public speed: number;
  public size: number;
  public positionXY: Position[];
  public _isEatSelf: boolean = false;
  public color: string;
  public constructor(snake: TSnake) {
    this.directionXY = snake.directionXY;
    this.speed = snake.speed;
    this.size = snake.size;
    this.color = snake.color;
    this.positionXY = [
      {
        positionX: snake.positionX[0] * this.size,
        positionY: snake.positionY[0] * this.size,
      },
    ];
  }

  public isEatThePrey(food: Food): boolean {
    const foodCenterPositionX = food.positionX + food.size / 2;
    const foodCenterPositionY = food.positionY + food.size / 2;
    const isEatInX =
      foodCenterPositionX > this.positionXY[0].positionX &&
      foodCenterPositionX < this.positionXY[0].positionX + this.size;
    const isEatInY =
      foodCenterPositionY > this.positionXY[0].positionY &&
      foodCenterPositionY < this.positionXY[0].positionY + this.size;
    const isPreyInsideSnakeMouth = isEatInX && isEatInY;
    return isPreyInsideSnakeMouth;
  }

  // public isEatSelf(set?: boolean): boolean | void {
  //   if (typeof set === "undefined") {
  //     return this._isEatSelf;
  //   }
  //   this._isEatSelf = set;
  // }

  public grow(): void {
    this.positionXY.push({
      positionX: this.positionXY[this.positionXY.length - 1].positionX,
      positionY: this.positionXY[this.positionXY.length - 1].positionY,
    });
  }

  public draw(context: CanvasRenderingContext2D): void {
    this.positionXY.forEach((bodyPosition) => {
      context.fillStyle = this.color;
      context.beginPath();
      context.fillRect(
        bodyPosition.positionX,
        bodyPosition.positionY,
        this.size,
        this.size
      );
      context.fill();
      context.closePath();
    });
  }

  public move(): void {
    const nextPositionX = this.nextMovePosition().positionX;
    const nextPositionY = this.nextMovePosition().positionY;

    const snakeHeadHitboxSingularX: number = nextPositionX + this.size / 2;
    const snakeHeadHitboxSingularY: number = nextPositionY + this.size / 2;

    for (let index = this.positionXY.length - 1; index > 0; index--) {
      const nextTailPositionX = this.positionXY[index - 1].positionX;
      const nextTailPositionY = this.positionXY[index - 1].positionY;

      this.positionXY[index].positionX = nextTailPositionX;
      this.positionXY[index].positionY = nextTailPositionY;
    }

    this.positionXY[0].positionX = nextPositionX;
    this.positionXY[0].positionY = nextPositionY;
  }

  public nextMovePosition(): Position {
    return {
      positionX:
        this.positionXY[0].positionX +
        this.directionXY[0] * this.speed * this.size,
      positionY:
        this.positionXY[0].positionY +
        this.directionXY[1] * this.speed * this.size,
    };
  }

  public isCollideWithWall(
    canvas: Canvas,
    whatWall?: Exclude<keyof typeof Wall, "prototype">
  ) {
    const isCollideWith: Record<
      Exclude<keyof typeof Wall, "prototype">,
      boolean
    > = {
      RIGHT_BOUNDARY:
        this.positionXY[0].positionX + this.size >
        canvas.width * canvas.multiplier,
      LEFT_BOUNDARY: this.positionXY[0].positionX < 0,
      BOTTOM_BOUNDARY:
        this.positionXY[0].positionY + this.size >
        canvas.height * canvas.multiplier,
      TOP_BOUNDARY: this.positionXY[0].positionY < 0,
    };
    const isCollideWithSomeWall = Object.values(isCollideWith).some(
      (partIsColliding: boolean) => partIsColliding
    );
    return whatWall ? isCollideWith[whatWall] : isCollideWithSomeWall;
  }
}
