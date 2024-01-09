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



