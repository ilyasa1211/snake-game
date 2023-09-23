class Direction {
  public static readonly LEFT: [Coordinate, Coordinate] = [-1, 0];
  public static readonly RIGHT: [Coordinate, Coordinate] = [1, 0];
  public static readonly DOWN: [Coordinate, Coordinate] = [0, 1];
  public static readonly UP: [Coordinate, Coordinate] = [0, -1];

  public static isSameDirection(
    direction: [Coordinate, Coordinate],
    directionTarget: [Coordinate, Coordinate]
  ): boolean {
    return direction.every(
      (coordinate, index) => coordinate === directionTarget[index]
    );
  }
};