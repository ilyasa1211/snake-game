-- UTILITIES

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



