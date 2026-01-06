# Design Document

By Tebogo Sekhula

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* **Purpose:** The database is designed to manage a logistics and package delivery system, 
tracking the movement of goods from a sender to a recipient through various transit points.
* ***Which people, places, things, etc. are you including in the scope of your database?*** 
  * **Customers:**  Senders and recipients
    * Logistics Infrastructure: Physical locations (Hubs/Stations) and vehicles (Trucks/Planes/Vans).
    * Operations: Package details, scheduled trips, and real-time shipment updates (tracking).
* ***Which people, places, things, etc. are *outside* the scope of your database?***
  * Financial transactions and payment processing.
    * Employee payroll or shift scheduling.
    * Vehicle fuel logs or maintenance history details beyond basic status.

## Functional Requirements

In this section you should answer the following questions:

* **What should a user be able to do with your database?**
  * Track a package’s full history using a unique tracking number.
  * Assign packages to specific vehicle trips via manifests.
  * Automatically update package statuses when a vehicle arrives at a destination.
  * Monitor vehicle capacity to prevent overloading.
* **What's beyond the scope of what a user should be able to do with your database?**
  * Predicting delivery times based on traffic (AI/External APIs).
  * Automated routing/GPS pathfinding.

## Representation

### Entities

In this section you should answer the following questions:

* **Which entities will you choose to represent in your database?**
  * **Customers:** Stores basic contact info. I chose TEXT for names and UNIQUE for emails to prevent duplicate accounts.
* **What attributes will those entities have?**
  * **Packages:** The core entity. DECIMAL(10,2) is used for weight to ensure precision, and tracking_number is indexed for fast lookups.
* **Why did you choose the types you did?**
  * **Locations:** Represents fixed points. I used a CHECK constraint on type to ensure data integrity (only 'Hub' or 'Local Station' allowed).
* **Why did you choose the constraints you did?**
  * **Trips & Manifests:** Trips represent the "schedule," while Manifests act as a junction table between Packages and Trips, allowing a many-to-many relationship (one trip has many packages; one package can be on multiple trips over time).

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

**One-to-Many (Customers to Packages):** One customer can send or receive many packages.

**Many-to-Many (Packages to Trips):** Linked via the Manifests table.

**One-to-Many (Packages to Shipment_updates):** One package has many status updates throughout its journey.

**One-to-Many (Locations to Trips):** One location can be the origin or destination for many different trips.
## Optimizations

In this section you should answer the following questions:

* **Which optimizations (e.g., indexes, views) did you create? Why?**
  * **Indexes:**
    * **package_search_index:** Created on tracking_number because this is the most frequent query performed by users.
    * **status_history_index:** Created on package_id to speed up the retrieval of a package's full movement history.
  * **Views:**
    * **current_package_status:** This simplifies complex logic for the front-end, showing only the latest location of a package without requiring the user to write subqueries.

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
  * **Concurrency:** The database does not handle "real-time" GPS coordinates; it only tracks discrete "scans" at specific locations.
* What might your database not be able to represent very well?
  * **Single-Recipient:** Each package is limited to one recipient and one sender; it cannot represent group shipments or split-billing.
