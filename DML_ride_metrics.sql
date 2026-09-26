INSERT INTO Ride_Metrics (attraction_id, current_wait_minutes, throughput_per_hour, queue_status)
SELECT 
    attraction_id, 
    CASE 
        WHEN type = 'Rollercoaster' THEN FLOOR(30 + RAND() * 90) -- Busy coasters
        WHEN type = 'Game' THEN FLOOR(5 + RAND() * 15)          -- Quick games
        ELSE FLOOR(10 + RAND() * 40)                            -- Others
    END as wait,
    FLOOR(100 + RAND() * 1000) as throughput,
    'Normal'
FROM Attractions;
