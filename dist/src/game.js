"use strict";
class Game {
  constructor(snake, food, canvas, control) {
    this.snake = snake;
    this.food = food;
    this.canvas = canvas;
    this.control = control;
    this._isGameOver = false;
    this._score = 0;
    const randomFoodPositionX =
      Utils.getIntegerRandomNumberBetween(0, this.canvas.width) *
      this.canvas.multiplier;
    const randomFoodPositionY =
      Utils.getIntegerRandomNumberBetween(0, this.canvas.height) *
      this.canvas.multiplier;
    this.food.setPosition(randomFoodPositionX, randomFoodPositionY);
    this.canvas.create();
    this.control.init();
  }
  isGameOver(set) {
    if (typeof set === "undefined") {
      return this._isGameOver;
    }
    this._isGameOver = set;
  }
  addScore(add) {
    this._score += add;
  }
  setMessage(message) {
    message.show(this.canvas.context);
  }
  play() {
    if (this.snake.isCollideWithWall(this.canvas)) {
      this.isGameOver(true);
    }
    // if (this.snake.isEatSelf()) {
    //   this.isGameOver(true);
    // }
    this.snake.move();
    if (this.snake.isEatThePrey(this.food)) {
      const randomFoodPositionX =
        Utils.getIntegerRandomNumberBetween(0, this.canvas.width) *
        this.canvas.multiplier;
      const randomFoodPositionY =
        Utils.getIntegerRandomNumberBetween(0, this.canvas.height) *
        this.canvas.multiplier;
      this.food.setPosition(randomFoodPositionX, randomFoodPositionY);
      this.snake.grow();
    }
    this.snake.draw(context);
    this.food.draw(context);
  }
}
