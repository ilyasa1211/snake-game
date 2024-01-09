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



