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



