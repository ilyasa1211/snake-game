-- DROP ALL TABLES

DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS snake;
DROP TABLE IF EXISTS control;
DROP TABLE IF EXISTS food;
-- DROP ALL FUNCTIONS


DROP FUNCTION IF EXISTS get_board_middle_position;
DROP FUNCTION IF EXISTS get_random_number_between;
-- DROP ALL PROCEDURES

DROP PROCEDURE IF EXISTS is_snake_eat_the_food;
DROP PROCEDURE IF EXISTS get_snake_direction;
DROP PROCEDURE IF EXISTS initialize_board;
DROP PROCEDURE IF EXISTS initialize_snake;
DROP PROCEDURE IF EXISTS initialize_food;
DROP PROCEDURE IF EXISTS initialize_control;
DROP PROCEDURE IF EXISTS play;
DROP PROCEDURE IF EXISTS play_default;
DROP PROCEDURE IF EXISTS spawn_snake;
DROP PROCEDURE IF EXISTS snake_grow;
DROP PROCEDURE IF EXISTS snake_move;
DROP PROCEDURE IF EXISTS spawn_food;
DROP PROCEDURE IF EXISTS move_food;
DROP PROCEDURE IF EXISTS get_food_position_by_id;
DROP PROCEDURE IF EXISTS get_snake_last_body_position;
DROP PROCEDURE IF EXISTS get_snake_first_body_position;
DROP PROCEDURE IF EXISTS get_snake_body_position_by_id;
DROP PROCEDURE IF EXISTS get_snake_next_position;
DROP PROCEDURE IF EXISTS move_left;
DROP PROCEDURE IF EXISTS move_right;
DROP PROCEDURE IF EXISTS move_up;
DROP PROCEDURE IF EXISTS move_down;
DROP PROCEDURE IF EXISTS board_clear;
DROP PROCEDURE IF EXISTS board_simulate_object;
DROP PROCEDURE IF EXISTS display;
DROP PROCEDURE IF EXISTS get_board_size;-- UTILITIES

DELIMITER //


CREATE FUNCTION get_random_number_between(min INT, max INT)
RETURNS INTEGER
NO SQL
NOT DETERMINISTIC 
BEGIN
    SELECT FLOOR(min + RAND() * max) INTO @random;

    RETURN @random;
END //


CREATE PROCEDURE get_snake_direction(control_table_name VARCHAR(64), OUT direction CHAR(1))
BEGIN
    SET @query = CONCAT('SELECT direction INTO @direction FROM ', control_table_name, ' ORDER BY ID ASC LIMIT 1');
    PREPARE stmt from @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET direction = @direction;
END //


CREATE PROCEDURE display(IN table_name VARCHAR(64))
BEGIN
    SET @query = CONCAT('SELECT * FROM ', table_name);

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //


DELIMITER ;



-- BOARD

DELIMITER //


-- CREATE BOARD TABLE
CREATE PROCEDURE initialize_board (IN table_name VARCHAR(64), IN board_size TINYINT)
BEGIN
    -- create board table
    SET @create_board_query = CONCAT('CREATE TABLE ', table_name, ' (id INT AUTO_INCREMENT PRIMARY KEY)');
    PREPARE stmt FROM @create_board_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- create row
    SET @i = 1;
    WHILE @i <= board_size DO
        SET @create_row_query = CONCAT('INSERT INTO ', table_name, ' VALUES (NULL)');
        
        PREPARE stmt FROM @create_row_query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET @i = @i + 1;
    END WHILE;

    -- create column
    SET @i = 1;
    WHILE @i <= board_size DO
        SET @create_column_query = CONCAT('ALTER TABLE ', table_name, ' ADD COLUMN c', @i ,' CHAR(1) DEFAULT ""');
        
        PREPARE stmt FROM @create_column_query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    
        SET @i = @i + 1;
    END WHILE;

END //


DELIMITER ;



-- SNAKE

DELIMITER //


-- CREATE SNAKE TABLE
CREATE PROCEDURE initialize_snake (IN table_name VARCHAR(64), IN board_size TINYINT)
BEGIN
    DECLARE start_position_x TINYINT; 
    DECLARE start_position_y TINYINT;

    SELECT get_board_middle_position(board_size) INTO start_position_x;
    SELECT get_board_middle_position(board_size) INTO start_position_Y;

    -- create snake table
    SET @create_query = CONCAT('CREATE TABLE ', table_name, ' (id INT AUTO_INCREMENT PRIMARY KEY, position_x TINYINT, position_y TINYINT)');
    
    PREPARE stmt FROM @create_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    -- spawn snake
    CALL spawn_snake(table_name, start_position_x, start_position_y);
END //


DELIMITER ;



-- FOOD

DELIMITER //


-- CREATE FOOD TABLE
CREATE PROCEDURE initialize_food (IN table_name VARCHAR(64), IN board_size TINYINT)
BEGIN
    DECLARE start_position_x TINYINT;
    DECLARE start_position_y TINYINT;

    SELECT get_random_number_between(1, board_size) INTO start_position_x;
    SELECT get_random_number_between(1, board_size) INTO start_position_y;

    SET @create_query = CONCAT('CREATE TABLE ', table_name, ' (id INT AUTO_INCREMENT PRIMARY KEY, position_x TINYINT NOT NULL, position_y TINYINT NOT NULL)');

    PREPARE stmt FROM @create_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    CALL spawn_food(table_name, start_position_x, start_position_y);
END //


DELIMITER ;



-- CONTROL

DELIMITER //


-- CREATE CONTROL TABLE
CREATE PROCEDURE initialize_control(IN control_table_name VARCHAR(64))
BEGIN
    SET @default_direction = 'U'; -- Up direction as default

    SET @create_query = CONCAT('CREATE TABLE ', control_table_name, ' (id INT AUTO_INCREMENT PRIMARY KEY, direction CHAR(1) NOT NULL)');
    SET @insert_query = CONCAT('INSERT INTO ', control_table_name, ' (direction) VALUES ', '(?)');

    PREPARE stmt FROM @create_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    PREPARE stmt FROM @insert_query;
    EXECUTE stmt USING @default_direction;
    DEALLOCATE PREPARE stmt;
END //


DELIMITER ;



-- SNAKE

DELIMITER //

CREATE PROCEDURE snake_grow(IN snake_table_name VARCHAR(64))
BEGIN
    CALL get_snake_last_body_position(snake_table_name, @last_position_X, @last_position_y);

    SET @insert_query = CONCAT('INSERT INTO ', snake_table_name, ' (position_x, position_y) VALUES (', @last_position_x, ', ', @last_position_y, ')');
    
    PREPARE stmt FROM @insert_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE snake_move(IN snake_table_name VARCHAR(64), IN control_table_name VARCHAR(64), IN board_size TINYINT)
BEGIN
    
    SET @direction_snake_query = CONCAT('SELECT direction INTO @direction FROM ', control_table_name, ' LIMIT 1');
    SET @snake_length_query = CONCAT('SELECT COUNT(*) INTO @snake_length FROM ', snake_table_name);
    SET @update_query = CONCAT('UPDATE ', snake_table_name, ' SET position_x = ?, position_y = ? WHERE id = ?'); 
    SET @update_head_query = CONCAT('UPDATE ', snake_table_name, ' SET position_x = ?, position_y = ? WHERE id = 1');
    
    PREPARE direction_snake_stmt FROM @direction_snake_query;
    EXECUTE direction_snake_stmt;
    DEALLOCATE PREPARE direction_snake_stmt;
    
    PREPARE snake_length_stmt FROM @snake_length_query;
    EXECUTE snake_length_stmt;
    DEALLOCATE PREPARE snake_length_stmt;

    IF @direction IS NOT NULL AND @snake_length > 0 THEN 
        SET @i = @snake_length;
    
        -- move the tails of the snake
        WHILE @i > 1 DO
            CALL get_snake_body_position_by_id(snake_table_name, @i - 1, @prev_position_x, @prev_position_y);
            
            PREPARE stmt FROM @update_query;
            EXECUTE stmt USING @prev_position_x, @prev_position_y, @i;
            DEALLOCATE PREPARE stmt;
            
            SET @i = @i - 1;    

        END WHILE;

        -- move the head of the snake
        CALL get_snake_next_position(snake_table_name, control_table_name, board_size, @next_position_x, @next_position_y);

        PREPARE stmt FROM @update_head_query;
        EXECUTE stmt USING @next_position_x, @next_position_y;
        DEALLOCATE PREPARE stmt;
        
    END IF;
END //


DELIMITER ;



-- CONTROL

DELIMITER //


CREATE PROCEDURE move_left(IN control_table_name VARCHAR(64))
BEGIN
    SET @direction = 'L';
    
    IF control_table_name IS NULL THEN
        SET control_table_name = 'control';
    END IF;
    
    SET @query = CONCAT('UPDATE ', control_table_name, ' SET direction = ? WHERE id = 1');
    PREPARE stmt FROM @query;
    EXECUTE stmt USING @direction;
    DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE move_right(IN control_table_name VARCHAR(64))
BEGIN
    SET @direction = 'R';

    IF control_table_name IS NULL THEN
        SET control_table_name = 'control';
    END IF;

    SET @query = CONCAT('UPDATE ', control_table_name, ' SET direction = ? WHERE id = 1');
    PREPARE stmt FROM @query;
    EXECUTE stmt USING @direction;
    DEALLOCATE PREPARE stmt;    
END //


CREATE PROCEDURE move_up(IN control_table_name VARCHAR(64))
BEGIN
    SET @direction = 'U';
    
    IF control_table_name IS NULL THEN
        SET control_table_name = 'control';
    END IF;
    
    SET @query = CONCAT('UPDATE ', control_table_name, ' SET direction = ? WHERE id = 1');
    PREPARE stmt FROM @query;
    EXECUTE stmt using @direction;
    DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE move_down(IN control_table_name VARCHAR(64))
BEGIN
    SET @direction = 'D';

    IF control_table_name IS NULL THEN
        SET control_table_name = 'control';
    END IF;
    
    SET @query = CONCAT('UPDATE ', control_table_name, ' SET direction = ? WHERE id = 1');
    PREPARE stmt FROM @query;
    EXECUTE stmt using @direction;
    DEALLOCATE PREPARE stmt;
END //


DELIMITER ;



-- FOOD HELPER

DELIMITER //


CREATE PROCEDURE spawn_food(IN food_table_name VARCHAR(64), IN start_position_x TINYINT, IN start_position_y TINYINT)
BEGIN
    SET @initialize_query = CONCAT('INSERT INTO ', food_table_name, ' VALUES (NULL, ', start_position_x, ',', start_position_y, ')');
    
    PREPARE stmt FROM @initialize_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE move_food(IN food_table_name VARCHAR(64), IN start_position_x TINYINT, IN start_position_y TINYINT)
BEGIN
    SET @query = CONCAT('UPDATE ', food_table_name, ' SET position_x = ', start_position_x, ', position_y = ', start_position_y, ' WHERE id = 1');
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE get_food_position_by_id(IN food_table_name VARCHAR(64), IN id INT, OUT position_x TINYINT, OUT position_y TINYINT)
BEGIN
    SET @position_x = 0;
    SET @position_y = 0;    
    
    SET @query = CONCAT('SELECT position_x, position_y INTO @position_x, @position_y FROM ', food_table_name, ' WHERE id = ', id);
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET position_x = @position_x;
    SET position_y = @position_y;

END //


DELIMITER ;



-- SNAKE HELPER

DELIMITER //


CREATE PROCEDURE spawn_snake(IN snake_table_name VARCHAR(64), IN start_position_x TINYINT, IN start_position_y TINYINT)
BEGIN
    SET @initialize_query = CONCAT('INSERT INTO ', snake_table_name, ' (position_x, position_y) VALUES (', start_position_x, ', ', start_position_y, ')');
    
    PREPARE stmt FROM @initialize_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //


CREATE PROCEDURE get_snake_last_body_position(IN snake_table_name VARCHAR(64), OUT position_x TINYINT, OUT position_y TINYINT)
BEGIN
    SET @position_x = 0;
    SET @position_y = 0;    

    SET @select_query = CONCAT('SELECT position_x, position_y INTO @position_x, @position_y FROM ', snake_table_name, ' ORDER BY id DESC LIMIT 1'); 
    
    PREPARE stmt FROM @select_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET position_x = @position_x;
    SET position_y = @position_y;
END //


CREATE PROCEDURE get_snake_first_body_position(IN snake_table_name VARCHAR(64), OUT position_x TINYINT, OUT position_y TINYINT)
BEGIN
    SET @position_x = 0;
    SET @position_y = 0;

    SET @select_query = CONCAT('SELECT position_x, position_y INTO @position_x, @position_y FROM ', snake_table_name, ' ORDER BY id ASC LIMIT 1'); 
    
    PREPARE stmt FROM @select_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET position_x = @position_x;
    SET position_y = @position_y;
END //


CREATE PROCEDURE get_snake_body_position_by_id(IN snake_table_name VARCHAR(64), IN id INT, OUT position_x TINYINT, OUT position_y TINYINT)
BEGIN
    SET @position_x = 0;
    SET @position_y = 0;

    SET @select_query = CONCAT('SELECT position_x, position_y INTO @position_x, @position_y FROM ', snake_table_name, ' WHERE id = ', id);
    
    PREPARE stmt FROM @select_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET position_x = @position_x;
    SET position_y = @position_y;
END //


CREATE PROCEDURE get_snake_next_position(IN snake_table_name VARCHAR(64), IN control_table_name VARCHAR(64), IN board_size TINYINT, OUT position_x TINYINT, OUT position_y TINYINT)
BEGIN

    CALL get_snake_first_body_position(snake_table_name, @prev_position_x, @prev_position_y);
    
    CALL get_snake_direction(control_table_name, @direction);

    SET @next_position_x = @prev_position_x;
    SET @next_position_y = @prev_position_y;

    IF @direction IS NOT NULL THEN 
        IF  @direction = 'U' AND @next_position_y - 1 > 0 THEN 
            SET @next_position_y = @next_position_y - 1;
        ELSEIF @direction = 'D' AND @next_position_y + 1 <= board_size THEN 
            SET @next_position_y = @next_position_y + 1;
        ELSEIF @direction = 'R' AND @next_position_x + 1 <= board_size THEN 
            SET @next_position_x = @next_position_x + 1;
        ELSEIF @direction = 'L' AND @next_position_x - 1 > 0 THEN 
            SET @next_position_x = @next_position_x - 1;
        END IF; 
    END IF;

    SET position_x = @next_position_x;
    SET position_y = @next_position_y;
END //


CREATE PROCEDURE is_snake_eat_the_food(snake_table_name VARCHAR(64), food_table_name VARCHAR(64), OUT is_eat TINYINT(1))
BEGIN
    SET @is_eat = 0;

    CALL get_snake_first_body_position(snake_table_name, @snake_position_x, @snake_position_y);
    CALL get_food_position_by_id(food_table_name, 1, @food_position_x, @food_position_y );
    
    IF @snake_position_x = @food_position_x AND @snake_position_y = @food_position_y THEN 
        SET @is_eat = 1;
    END IF;

    SET is_eat = @is_eat;
END //


DELIMITER ;



-- BOARD HELPER

DELIMITER //


CREATE FUNCTION get_board_middle_position(board_size TINYINT)
RETURNS INTEGER
NO SQL
DETERMINISTIC
BEGIN
    DECLARE half INT;

    SELECT board_size DIV 2 INTO half;

    RETURN half;
END //


CREATE PROCEDURE board_clear(IN board_table_name VARCHAR(64))
BEGIN
    SET @empty_value = ' ';

    SET @board_size_query = CONCAT('SELECT COUNT(*) INTO @board_size FROM ', board_table_name);
    
    PREPARE stmt FROM @board_size_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @i = 1;

    WHILE @i <= @board_size DO
        SET @dynamic_column = CONCAT('c', @i);
        SET @clear_board_query = CONCAT('UPDATE ', board_table_name, ' SET ', @dynamic_column, ' = ?');

        PREPARE stmt FROM @clear_board_query;
        EXECUTE stmt USING @empty_value;
        DEALLOCATE PREPARE stmt;

        SET @i = @i + 1;
    END WHILE;
END //


CREATE PROCEDURE board_simulate_object(IN board_table_name VARCHAR(64), IN object_table_name VARCHAR(64), IN object_body_display CHAR(1))
BEGIN
    SET @object_length = 0;
    SET @object_position_x = 0;
    SET @object_position_y = 0;

    SET @object_length_query = CONCAT('SELECT COUNT(*) INTO @object_length FROM ', object_table_name);
    SET @object_position_query = CONCAT('SELECT position_x, position_y INTO @object_position_x, @object_position_y FROM ', object_table_name, ' WHERE id = ?');

    PREPARE stmt FROM @object_length_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET @i = 1;

    WHILE @i <= @object_length DO
        PREPARE stmt FROM @object_position_query;
        EXECUTE stmt USING @i;
        DEALLOCATE PREPARE stmt;

        SET @dynamic_column = CONCAT('c', @object_position_x);
        SET @update_board_object_query = CONCAT('UPDATE ', board_table_name, ' SET ', @dynamic_column,' = "', object_body_display, '" WHERE id = ', @object_position_y);

        PREPARE stmt FROM @update_board_object_query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

        SET @i = @i + 1;
    END WHILE;
    
END //


CREATE PROCEDURE get_board_size(IN board_table_name VARCHAR(64), OUT board_size INT)
BEGIN
    SET @query = CONCAT('SELECT COUNT(*) INTO @board_size FROM ', board_table_name);
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SET board_size = @board_size;
END //

DELIMITER ;



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



