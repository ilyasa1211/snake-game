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



