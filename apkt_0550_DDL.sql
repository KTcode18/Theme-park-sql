CREATE TABLE Attractions (
    attraction_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('Rollercoaster', 'Water Ride', 'Dark Ride', 'Flat Ride', 'Show') NOT NULL,
    capacity_per_cycle INT,
    min_height_inches INT,
    current_status ENUM('Open', 'Closed', 'Maintenance', 'Weather Delay') DEFAULT 'Open',
    last_inspected_at DATETIME
);

CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role ENUM('Operator', 'Technician', 'Security', 'Guest Services', 'Manager'),
    hire_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE Visitors (
    visitor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    membership_level ENUM('Standard', 'Silver', 'Gold', 'Platinum') DEFAULT 'Standard'
);

CREATE TABLE Tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    visitor_id INT NOT NULL,
    ticket_type ENUM('Single Day', 'Season Pass', 'VIP'),
    purchase_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until DATE,
    is_scanned BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (visitor_id) REFERENCES Visitors(visitor_id) ON DELETE CASCADE
);

-- Tracks available assignments
CREATE TABLE Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    attraction_id INT,
    creation_date DATETIME,
    description TEXT,
    station_position VARCHAR(50), -- e.g., 'Control Room', 'Loading Dock'
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (attraction_id) REFERENCES Attractions(attraction_id)
);

-- Track which employees are actually trained for specific rides
CREATE TABLE Staff_Certifications (
    cert_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    attraction_id INT NOT NULL,
    certification_date DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (attraction_id) REFERENCES Attractions(attraction_id)
);

-- Real-time maintenance tracking
CREATE TABLE Maintenance_Work_Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    attraction_id INT NOT NULL,
    technician_id INT NOT NULL,
    priority ENUM('Low', 'Medium', 'High', 'Emergency'),
    status ENUM('Pending', 'In Progress', 'Completed'),
    reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    FOREIGN KEY (attraction_id) REFERENCES Attractions(attraction_id),
    FOREIGN KEY (technician_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Ride_Metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    attraction_id INT NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    current_wait_minutes INT DEFAULT 0,
    throughput_per_hour INT DEFAULT 0, -- Efficiency: how many people are actually riding
    queue_status ENUM('Normal', 'FastPass Only', 'Single Rider Only', 'Closed', 'Virtual Queue') DEFAULT 'Normal',
    FOREIGN KEY (attraction_id) REFERENCES Attractions(attraction_id) ON DELETE CASCADE,
    CONSTRAINT chk_wait_time CHECK (current_wait_minutes >= 0),
    CONSTRAINT chk_throughput CHECK (throughput_per_hour >= 0)
);

ALTER TABLE Attractions 
MODIFY COLUMN type ENUM('Rollercoaster', 'Water Ride', 'Dark Ride', 'Flat Ride', 'Show', 'Game') NOT NULL;