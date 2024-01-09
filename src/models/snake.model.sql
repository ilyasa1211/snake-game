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



