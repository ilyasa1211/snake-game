# Snake game CLI using MySQL

### How To Play

> Note: First you need to create database e.g snake

1. Open terminal in this directory and run the exec.sh file.
```console
yasa@desktop> ./exec.sh
```

2. This command will create a procedures, functions that needed to play the game.
```console
yasa@desktop> mysql <database_name> < ./dist/out.sql -u <username> -p
```
3. Login to your MySQL
```console
yasa@desktop> mysql -u <username> -p
```

4. Start the game, this terminal will be the display. You need another terminal for controlling the snake's movement
```console
mysql> call <database_name>.play_default();
```

5. Open another terminal, and login into your sql
```console
mysql> use <database_name>;
```
To move left:
```console
mysql> call move_left('snake');
```
Other available control:
- move_left
- move_right
- move_up
- move_down


## Cheat

1. Add snake's length by 1
```console
mysql> call snake_grow('snake'); 
```

2. Change food's positions. (e.g change to column 5 and row 7)
```console
mysql> call move_food('food', 5, 7);
```
