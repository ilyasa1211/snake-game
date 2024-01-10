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

    -- Solid Border
    -- snake will stop moving when reach border 

    -- IF @direction IS NOT NULL THEN 
    --     IF  @direction = 'U' AND @next_position_y - 1 > 0 THEN 
    --         SET @next_position_y = @next_position_y - 1;
    --     ELSEIF @direction = 'D' AND @next_position_y + 1 <= board_size THEN 
    --         SET @next_position_y = @next_position_y + 1;
    --     ELSEIF @direction = 'R' AND @next_position_x + 1 <= board_size THEN 
    --         SET @next_position_x = @next_position_x + 1;
    --     ELSEIF @direction = 'L' AND @next_position_x - 1 > 0 THEN 
    --         SET @next_position_x = @next_position_x - 1;
    --     END IF; 
    -- END IF;


    -- Portal Border
    -- snake will go through border and appear at opposite border

    IF @direction IS NOT NULL THEN 
        IF  @direction = 'U' THEN
            IF @next_position_y - 1 > 0 THEN 
                SET @next_position_y = @next_position_y - 1;
            ELSE
                SET @next_position_y = board_size;
            END IF;
        ELSEIF @direction = 'D' THEN
            IF @next_position_y + 1 <= board_size THEN
                SET @next_position_y = @next_position_y + 1;
            ELSE 
                SET @next_position_y = 1;
            END IF;
        ELSEIF @direction = 'R' THEN
            IF @next_position_x + 1 <= board_size THEN
                SET @next_position_x = @next_position_x + 1;
            ELSE 
                SET @next_position_x = 1;
            END IF;
        ELSEIF @direction = 'L' THEN
            IF @next_position_x - 1 > 0 THEN 
                SET @next_position_x = @next_position_x - 1;
            ELSE
                SET @next_position_x = board_size;
            END IF;
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



