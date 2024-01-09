-- INDEX

DELIMITER //


CREATE PROCEDURE play(IN board_table_name VARCHAR(64), IN snake_table_name VARCHAR(64), IN food_table_name VARCHAR(64), IN control_table_name VARCHAR(64), IN board_size TINYINT)
BEGIN
    DECLARE is_game_over INT DEFAULT 0;
    DECLARE food_body_display CHAR(1) DEFAULT 'x';
    DECLARE snake_body_display CHAR(1) DEFAULT '@';

    CALL initialize_board(board_table_name, board_size);
    CALL initialize_snake(snake_table_name, board_size);
    CALL initialize_food(food_table_name, board_size);    
    CALL initialize_control(control_table_name);

    WHILE is_game_over = 0 DO
        CALL board_clear(board_table_name);

        CALL is_snake_eat_the_food(snake_table_name, food_table_name, @is_snake_eat);

        IF @is_snake_eat = 1 THEN 

            CALL move_food(food_table_name);
            CALL snake_grow();
        END IF;

        CALL snake_move(snake_table_name, control_table_name, board_size);

        CALL board_simulate_object(board_table_name, food_table_name, food_body_display);
        CALL board_simulate_object(board_table_name, snake_table_name, snake_body_display);

        CALL display(board_table_name); 
    END WHILE;
END //


CREATE PROCEDURE play_default()
BEGIN
    DECLARE board_table_name VARCHAR(64) DEFAULT 'board';
    DECLARE snake_table_name VARCHAR(64) DEFAULT 'snake';
    DECLARE food_table_name VARCHAR(64) DEFAULT 'food';
    DECLARE control_table_name VARCHAR(64) DEFAULT 'control';

    DECLARE board_size TINYINT DEFAULT 9;

    CALL play(board_table_name, snake_table_name, food_table_name, control_table_name, board_size);
END //

DELIMITER ;



