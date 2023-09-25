abstract class Message {
  public abstract show(context: CanvasRenderingContext2D): void;
}

class CenterMessage extends Message {
  public constructor(
    public message: string,
    public color: string = "white",
    public font = "50px Arial"
  ) {
    super();
  }

  public show(context: CanvasRenderingContext2D): void {
    context.font = this.font;
    context.fillStyle = this.color;
    let measureText = context.measureText(this.message);
    context.fillText(
      this.message,
      (canvas.width * canvas.multiplier - measureText.width) / 2,
      (canvas.height * canvas.multiplier +
        measureText.actualBoundingBoxAscent) /
        2
    );
  }
}
