class Wall {
    public static LEFT_BOUNDARY = "LEFT";
    public static TOP_BOUNDARY = "TOP";
    public static RIGHT_BOUNDARY = "RIGHT";
    public static BOTTOM_BOUNDARY = "BOTTOM";
}

class Canvas extends Wall {
  public context: CanvasRenderingContext2D;
  public constructor(
    public canvas: HTMLCanvasElement,
    public width: number = 30,
    public height: number = 40,
    public multiplier = 1,
    public backgroundColor: string = "rgb(46,46,46)"
  ) {
    super();
    this.context = this.canvas.getContext("2d")!;
  }

  public create(): void {
    this.canvas.width = this.width * this.multiplier;
    this.canvas.height = this.height * this.multiplier;
    this.canvas.style.backgroundColor = this.backgroundColor;
  }

  public clear(): void {
    this.context.clearRect(
      0,
      0,
      this.width * this.multiplier,
      this.height * this.multiplier
    );
  }
}