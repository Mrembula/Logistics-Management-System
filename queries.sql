-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- ==========================================
-- 1. TRACKING & USER EXPERIENCE
-- ==========================================

-- Find the full tracking history for a specific package ordered by most recent scan
-- Uses a subquery to find the package ID from a tracking number
SELECT status, name AS "location", "timestamp" FROM Shipment_updates
    JOIN "Locations" ON Shipment_updates.location_id = Locations.id
        WHERE package_id = (SELECT id FROM Packages WHERE tracking_number = 'TRACK-001')
            ORDER BY timestamp DESC;

-- Get the latest known status of a package using the current_package_status view
-- (Note: Ensure the view is created in your schema.sql first)
SELECT * FROM "current_package_status"
WHERE tracking_number = 'TRACK-001';

-- ==========================================
-- 2. OPERATIONAL MANAGEMENT
-- ==========================================

-- Count how many packages are currently sitting at a specific facility (e.g., 'Boston Hub')
SELECT COUNT(*) AS packages_at_location FROM Shipment_updates
    WHERE location_id = (SELECT id FROM "Locations" WHERE name = 'Boston Hub')
        AND "status" = 'Picked Up';


-- Generate a manifest checklist for a specific trip driver
-- Displays tracking number, weight, and the recipient's last name
SELECT Packages.tracking_number, Packages.weight_kg, Customers.last_name AS "recipient" FROM Packages
    JOIN Manifests ON Packages.id = Manifests.package_id
        JOIN Customers ON Packages.recipient_id = Customers.id
            WHERE Manifests.trip_id = 1;


-- ==========================================
-- 3. BUSINESS INTELLIGENCE
-- ==========================================

-- Calculate the average delivery time (in days) for all packages that reached 'Delivered' status
SELECT AVG(julianday(delivered_time) - julianday(pickup_time)) AS "avg_days_to_deliver"
FROM (SELECT MIN("timestamp") AS pickup_time, MAX("timestamp") AS delivered_time
    FROM Shipment_updates GROUP BY package_id
        HAVING COUNT(CASE WHEN "status" = 'Picked Up' THEN 1 END) > 0
);

-- Find vehicles currently carrying over 90% of their maximum weight capacity
-- This helps prevent vehicle strain and ensures safety compliance
SELECT vehicle.vin, vehicle.capacity_kg, SUM(pack.weight_kg) AS "total_loaded_weight"
FROM Vehicles AS vehicle
    JOIN Trips AS trip ON vehicle.id = trip.vehicle_id
        JOIN Manifests AS manfest ON trip.id = manfest.trip_id
            JOIN Packages AS pack ON manfest.package_id = pack.id
            GROUP BY vehicle.id;
                -- HAVING "total_loaded_weight" > (vehicle.capacity_kg * 0.9);

SELECT id, vin, capacity_kg FROM Vehicles
    ORDER BY id;
SELECT SUM(weight_kg) FROM Packages;

-- ==========================================
-- 4. MAINTENANCE & SECURITY
-- ==========================================

-- Update a vehicle's status to 'Maintenance' using its VIN
-- Prevents the vehicle from being assigned to new active trips
UPDATE "Vehicles" SET "status" = 'Maintenance' WHERE "vin" = 'TRK-001';

-- Handle a 'Right to be Forgotten' request (GDPR)
-- Anonymizes package data by removing the link to the customer before deleting the customer record
UPDATE "Packages" SET "sender_id" = NULL WHERE "sender_id" = 5;
UPDATE "Packages" SET "recipient_id" = NULL WHERE "recipient_id" = 5;
DELETE FROM "Customers" WHERE "id" = 5;