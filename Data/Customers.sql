-- 1. CUSTOMERS (10)
INSERT INTO "Customers" (first_name, last_name, email) VALUES
('David', 'Malan', 'malan@harvard.edu'),
('Doug', 'Lloyd', 'doug@cs50.net'),
('Brian', 'Yu', 'brian@cs50.net'),
('Carter', 'Zenk', 'carter@cs50.net'),
('Alice', 'Johnson', 'alice@example.com'),
('Bob', 'Smith', 'bob@test.com'),
('Charlie', 'Brown', 'charlie@peanuts.com'),
('Diana', 'Prince', 'diana@themyscira.com'),
('Edward', 'Norton', 'edward@fightclub.com'),
('Fiona', 'Apple', 'fiona@music.com');

-- 2. LOCATIONS (10)
INSERT INTO "Locations" (name, type, address) VALUES
('Boston Hub', 'Hub', '100 Main St, Boston, MA'),
('Cambridge Station', 'Local Station', '50 Broadway, Cambridge, MA'),
('Logan International', 'Hub', '1 Harborside Dr, Boston, MA'),
('New York Central', 'Hub', 'Grand Central, NY'),
('London Gateway', 'Hub', '1 Stanford Rd, London'),
('Paris Local', 'Local Station', '12 Rue de Rivoli, Paris'),
('Tokyo Hub', 'Hub', '1-1 Chiyoda, Tokyo'),
('Sydney Sorting', 'Local Station', '10 George St, Sydney'),
('Berlin Station', 'Local Station', '10117 Berlin, Germany'),
('Toronto Hub', 'Hub', '1 Front St W, Toronto');

-- 3. VEHICLES (10)
INSERT INTO "Vehicles" (vin, type, capacity_kg, status) VALUES
('TRK-001', 'Truck', 5000.00, 'Active'),
('TRK-002', 'Truck', 5000.00, 'Active'),
('PLN-001', 'Plane', 50000.00, 'Active'),
('PLN-002', 'Plane', 45000.00, 'Maintenance'),
('VAN-001', 'Van', 800.00, 'Active'),
('VAN-002', 'Van', 800.00, 'Active'),
('TRK-003', 'Truck', 5500.00, 'Active'),
('VAN-003', 'Van', 750.00, 'Active'),
('PLN-003', 'Plane', 60000.00, 'Active'),
('TRK-004', 'Truck', 4800.00, 'Active');

-- 4. PACKAGES (10)
-- sender_id and recipient_id use IDs 1-10 from Customers
INSERT INTO "Packages" (tracking_number, sender_id, recipient_id, weight_kg) VALUES
('TRACK-001', 1, 2, 2.50),
('TRACK-002', 2, 3, 10.75),
('TRACK-003', 3, 4, 0.50),
('TRACK-004', 4, 5, 15.00),
('TRACK-005', 5, 6, 1.20),
('TRACK-006', 6, 7, 8.40),
('TRACK-007', 7, 8, 3.10),
('TRACK-008', 8, 9, 22.00),
('TRACK-009', 9, 10, 5.00),
('TRACK-010', 10, 1, 14.20);

-- 5. TRIPS (10)
-- vehicle_id 1-10, origin/destination 1-10
INSERT INTO "Trips" (vehicle_id, origin_id, destination_id, departure_time, arrival_time) VALUES
(1, 1, 2, '2024-06-01 08:00:00', '2024-06-01 10:00:00'),
(2, 2, 3, '2024-06-01 12:00:00', NULL),
(3, 3, 4, '2024-06-02 09:00:00', '2024-06-02 14:00:00'),
(5, 4, 1, '2024-06-02 15:00:00', NULL),
(7, 5, 6, '2024-06-03 07:00:00', '2024-06-03 19:00:00'),
(9, 7, 5, '2024-06-03 22:00:00', NULL),
(10, 8, 9, '2024-06-04 06:00:00', '2024-06-04 09:00:00'),
(6, 9, 10, '2024-06-04 10:00:00', NULL),
(1, 10, 1, '2024-06-05 11:00:00', NULL),
(3, 1, 7, '2024-06-05 13:00:00', '2024-06-05 23:00:00');

-- 6. MANIFESTS (10)
-- Linking packages to trips
INSERT INTO "Manifests" (trip_id, package_id) VALUES
(1, 1), (1, 2), (2, 3), (3, 4), (5, 5),
(7, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- 7. SHIPMENT UPDATES (10)
-- Initial "Picked Up" scans for all 10 packages
INSERT INTO "Shipment_updates" (package_id, location_id, status, timestamp) VALUES
(1, 1, 'Picked Up', '2024-06-01 07:00:00'),
(2, 1, 'Picked Up', '2024-06-01 07:15:00'),
(3, 2, 'Picked Up', '2024-06-01 11:00:00'),
(4, 3, 'Picked Up', '2024-06-02 08:00:00'),
(5, 4, 'Picked Up', '2024-06-02 14:00:00'),
(6, 5, 'Picked Up', '2024-06-03 06:00:00'),
(7, 5, 'Picked Up', '2024-06-03 06:30:00'),
(8, 8, 'Picked Up', '2024-06-04 05:00:00'),
(9, 9, 'Picked Up', '2024-06-04 09:00:00'),
(10, 10, 'Picked Up', '2024-06-05 10:00:00');


SELECT 'Customers' as table_name, COUNT(*) as count FROM Customers
UNION ALL
SELECT 'Locations', COUNT(*) FROM Locations
UNION ALL
SELECT 'Vehicles', COUNT(*) FROM Vehicles
UNION ALL
SELECT 'Packages', COUNT(*) FROM Packages
UNION ALL
SELECT 'Trips', COUNT(*) FROM Trips;