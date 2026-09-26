DELIMITER //

CREATE PROCEDURE SeedVisitors()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 500 DO
        INSERT INTO Visitors (first_name, last_name, email, membership_level) 
        VALUES (
            CONCAT('Guest_', i), 
            CONCAT('Surname_', FLOOR(RAND() * 100)), 
            CONCAT('visitor', i, '@themepark.com'),
            ELT(FLOOR(1 + RAND() * 4), 'Standard', 'Silver', 'Gold', 'Platinum')
        );
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- Run the procedure
CALL SeedVisitors();
