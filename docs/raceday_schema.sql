/* =========================================================
   RaceDay System - Database Creation Script
   Author: [Your Name]
   Description: Creates the full schema for the RaceDay
   system and seeds it with sample data, matching the ERD
   in /docs/raceday_erd.png exactly.
   Run this on a clean SQL Server instance using SSMS.
   ========================================================= */

-- =========================================================
-- 0. DATABASE SETUP
-- =========================================================
IF DB_ID('RaceDay') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDay SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDay;
END
GO

CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

-- =========================================================
-- 1. TABLE CREATION (in FK dependency order)
-- =========================================================

-- ROLES
CREATE TABLE Roles (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);
GO

-- USERS
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Roles FOREIGN KEY (role_id) REFERENCES Roles(id)
);
GO

-- EVENTS
CREATE TABLE Events (
    id INT IDENTITY(1,1) PRIMARY KEY,
    organiser_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description VARCHAR(1000) NULL,
    event_date DATE NOT NULL,
    location VARCHAR(150) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT FK_Events_Users FOREIGN KEY (organiser_id) REFERENCES Users(id)
);
GO

-- CATEGORIES
CREATE TABLE Categories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
GO

-- EVENT_CATEGORIES (junction table: Events M:M Categories)
CREATE TABLE EventCategories (
    id INT IDENTITY(1,1) PRIMARY KEY,
    event_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT FK_EventCategories_Events FOREIGN KEY (event_id) REFERENCES Events(id),
    CONSTRAINT FK_EventCategories_Categories FOREIGN KEY (category_id) REFERENCES Categories(id),
    CONSTRAINT UQ_EventCategories UNIQUE (event_id, category_id)
);
GO

-- ENROLMENTS
CREATE TABLE Enrolments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    participant_id INT NOT NULL,
    event_category_id INT NOT NULL,
    enrolment_date DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    CONSTRAINT FK_Enrolments_Users FOREIGN KEY (participant_id) REFERENCES Users(id),
    CONSTRAINT FK_Enrolments_EventCategories FOREIGN KEY (event_category_id) REFERENCES EventCategories(id),
    CONSTRAINT UQ_Enrolments UNIQUE (participant_id, event_category_id)
);
GO

-- RESULTS
CREATE TABLE Results (
    id INT IDENTITY(1,1) PRIMARY KEY,
    enrolment_id INT NOT NULL UNIQUE,
    finish_time VARCHAR(20) NOT NULL,
    position INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Results_Enrolments FOREIGN KEY (enrolment_id) REFERENCES Enrolments(id)
);
GO

-- =========================================================
-- 2. SEED DATA
-- =========================================================

-- Roles
INSERT INTO Roles (name) VALUES ('Organiser'), ('Participant');
GO

-- Users: 2 Organisers, 2 Participants
INSERT INTO Users (name, email, password_hash, role_id) VALUES
('Thabo Nkosi', 'thabo.nkosi@raceday.com', 'hashed_password_1', 1),   -- Organiser
('Lindiwe Dube', 'lindiwe.dube@raceday.com', 'hashed_password_2', 1), -- Organiser
('Sipho Mkhize', 'sipho.mkhize@raceday.com', 'hashed_password_3', 2), -- Participant
('Ayanda Zulu', 'ayanda.zulu@raceday.com', 'hashed_password_4', 2);   -- Participant
GO

-- Events: 3 events, owned by the two Organisers
INSERT INTO Events (organiser_id, title, description, event_date, location, status) VALUES
(1, 'City Marathon 2026', 'Annual road race through the city centre.', '2026-11-14', 'Johannesburg CBD', 'Scheduled'),
(1, 'Riverside Fun Run', 'Family-friendly run along the riverside trail.', '2026-10-05', 'Riverside Park', 'Scheduled'),
(2, 'Hillcrest Trail Challenge', 'Off-road trail race with mixed terrain.', '2026-12-01', 'Hillcrest Reserve', 'Scheduled');
GO

-- Categories: reusable across events
INSERT INTO Categories (name) VALUES
('5km'), ('10km'), ('Half Marathon'), ('21km Trail');
GO

-- EventCategories: categories offered per event
INSERT INTO EventCategories (event_id, category_id) VALUES
(1, 2),  -- City Marathon: 10km
(1, 3),  -- City Marathon: Half Marathon
(2, 1),  -- Riverside Fun Run: 5km
(2, 2),  -- Riverside Fun Run: 10km
(3, 4);  -- Hillcrest Trail Challenge: 21km Trail
GO

-- Enrolments: participants enrolling in event categories
INSERT INTO Enrolments (participant_id, event_category_id, status) VALUES
(3, 1, 'Confirmed'), -- Sipho -> City Marathon 10km
(4, 2, 'Confirmed'), -- Ayanda -> City Marathon Half Marathon
(3, 3, 'Confirmed'); -- Sipho -> Riverside Fun Run 5km
GO

-- Results: sample results for completed enrolments
INSERT INTO Results (enrolment_id, finish_time, position) VALUES
(1, '00:52:14', 1),
(3, '00:24:47', 2);
GO

-- =========================================================
-- 3. VERIFICATION QUERIES (optional - for your own testing)
-- =========================================================
-- SELECT * FROM Roles;
-- SELECT * FROM Users;
-- SELECT * FROM Events;
-- SELECT * FROM Categories;
-- SELECT * FROM EventCategories;
-- SELECT * FROM Enrolments;
-- SELECT * FROM Results;
