DELIMITER //

CREATE PROCEDURE SeedTickets()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO Tickets (visitor_id, ticket_type, valid_until, is_scanned) 
        VALUES (
            FLOOR(1 + RAND() * 500), -- Links to a random visitor (1-500)
            ELT(FLOOR(1 + RAND() * 3), 'Single Day', 'Season Pass', 'VIP'),
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 180) DAY), -- Valid between today and 6 months from now
            IF(RAND() > 0.5, TRUE, FALSE) -- Randomly sets some as already scanned
        );
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

-- Run the procedure
CALL SeedTickets();
