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



