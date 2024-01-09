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



