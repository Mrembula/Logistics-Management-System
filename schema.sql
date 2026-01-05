-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Customers sending and receiving packages
CREATE TABLE "Customers" (
    id INTEGER PRIMARY KEY AUTOINCREMENT ,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL ,
    email TEXT UNIQUE  NOT NULL
);

-- Individual packages sent by customers
CREATE TABLE "Packages" (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tracking_number TEXT UNIQUE NOT NULL,
    sender_id INTEGER,
    recipient_id INTEGER,
    weight_kg DECIMAL(10, 2) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(sender_id) REFERENCES Customers(id),
    FOREIGN KEY(recipient_id) REFERENCES Customers(id)
);

-- Sorting facilities
CREATE TABLE "Locations" (
    id INTEGER,
    name TEXT NOT NULL,
    type TEXT CHECK (type IN ('Hub', 'Local Station')),
    address TEXT NOT NULL,
    PRIMARY KEY(id)
);

-- Represents the fleet of transport vehicles
CREATE TABLE "Vehicles" (
    id INTEGER,
    vin TEXT UNIQUE NOT NULL,
    type TEXT CHECK (type IN ('Truck', 'Plane', 'Van')),
    capacity_kg DECIMAL(10, 2),
    status TEXT DEFAULT 'Active',
    PRIMARY KEY(id)
);

-- Planned movements between two locations
CREATE TABLE "Trips" (
    id INTEGER,
    vehicle_id INTEGER,
    origin_id INTEGER,
    destination_id INTEGER,
    departure_time DATETIME,
    arrival_time DATETIME,
    PRIMARY KEY(id),
    FOREIGN KEY(vehicle_id) REFERENCES  Vehicles(id),
    FOREIGN KEY(origin_id) REFERENCES Locations(id),
    FOREIGN KEY(destination_id) REFERENCES Locations(id)
);

-- Junction table linking packages to specific trips
CREATE TABLE Manifests (
    trip_id INTEGER,
    package_id INTEGER,
    FOREIGN KEY(trip_id) REFERENCES trips(id),
    FOREIGN KEY(package_id) REFERENCES Packages(id)
);

-- The audit log of every movement for a package
CREATE TABLE "Shipment_updates" (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    package_id INTEGER,
    location_id INTEGER,
    status TEXT CHECK(status in ('Picked Up', 'In Transit', 'Arrived', 'Out for delivery', 'Delivered')),
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (package_id) REFERENCES Packages(id),
    FOREIGN KEY (location_id) REFERENCES Locations(id)
);

-- DROP TABLE "Shipment_updates";

CREATE VIEW "current_package_status" AS
SELECT pack.tracking_number, updates.status, loc."name" AS "current_location", updates.timestamp
    FROM "Packages" AS pack
        JOIN "Shipment_updates" updates ON pack.id = updates.package_id
            JOIN "Locations" AS loc ON updates.location_id = loc."id"
                WHERE updates."timestamp" = (SELECT MAX("timestamp") FROM "Shipment_updates"
                    WHERE "package_id" = pack."id"
);

-- When a trip arrival time is updated, update all packages on that trip
CREATE TRIGGER after_trip_arrival
AFTER UPDATE OF arrival_time ON Trips
FOR EACH ROW
BEGIN
    INSERT INTO "Shipment_updates" (package_id, location_id, status)
        SELECT package_id, NEW.destination_id, 'Arrived'
            FROM Manifests
                WHERE "trip_id" = NEW.id;
END;

-- Indexes fir performance optimization
CREATE INDEX package_search_index ON Packages(tracking_number);
CREATE
INDEX status_history_index ON Shipment_updates(package_id)

-- DROP TABLE Vehicles;