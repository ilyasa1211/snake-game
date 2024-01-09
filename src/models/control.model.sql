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



