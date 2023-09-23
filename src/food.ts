class Food {
  public positionX: number = 0;
  public positionY: number = 0;

  public constructor(
    public size: number,
    public color: string = 'red'
  ) { }
  public setPosition(positionX: number, positionY: number): void {
    this.positionX = positionX;
    this.positionY = positionY;
  }

  public draw(context: CanvasRenderingContext2D): void {
    context.fillStyle = "red";
    context.beginPath();
    context.rect(
      this.positionX,
      this.positionY,
      this.size,
      this.size,
    );
    context.fill();
    context.closePath();
  }
}


