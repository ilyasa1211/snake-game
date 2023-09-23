"use strict";
class Direction {
    static isSameDirection(direction, directionTarget) {
        return direction.every((coordinate, index) => coordinate === directionTarget[index]);
    }
}
Direction.LEFT = [-1, 0];
Direction.RIGHT = [1, 0];
Direction.DOWN = [0, 1];
Direction.UP = [0, -1];
;
