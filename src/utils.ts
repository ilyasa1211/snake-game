class Utils {
    public static getIntegerRandomNumberBetween(min: number, max: number): number {
        return Math.floor(Math.random() * (max - min) + min);
    }
    public static getCanvasMiddlePosition(canvas: Canvas): Position {
        return {
            positionX: Math.floor(canvas.width / 2),
            positionY: Math.floor(canvas.height / 2),
        }
    }
}