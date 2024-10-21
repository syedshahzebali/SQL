create Database LuxStay;
use LuxStay;

CREATE TABLE Guests(
    GuestID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(15) NOT NULL,
    Address VARCHAR(150) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL
);

CREATE TABLE Rooms(
    RoomID INT PRIMARY KEY,
    RoomNumber INT NOT NULL UNIQUE,
    RoomType VARCHAR(20) NOT NULL,
    PricePerNight DECIMAL(10, 2) NOT NULL,
    IsAvailable BOOLEAN NOT NULL
);

CREATE TABLE Reservations (
    ReservationID INT PRIMARY KEY,
    GuestID INT,
    RoomID INT,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumberOfGuests INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL);
	Alter table Reservations add FOREIGN KEY(GuestID) REFERENCES Guests(GuestID);
    Alter table Reservations add FOREIGN KEY(RoomID) REFERENCES Rooms(RoomID);


CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    ReservationID INT,
    AmountPaid DECIMAL(10, 2) NOT NULL,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL);
    alter table Payments add Foreign KEY (ReservationID) REFERENCES Reservations(ReservationID);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(30) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(50) NOT NULL,
    ServicePrice DECIMAL(10, 2) NOT NULL,
    Description varchar(50) default 'unknown'
);

-- FOR ROOM AVAILABLITY
SELECT RoomID, RoomNumber, RoomType, PricePerNight
FROM Rooms
WHERE IsAvailable = TRUE AND RoomID NOT IN (
    SELECT RoomID FROM Reservations
    WHERE CheckInDate <= '2024-11-01' AND CheckOutDate >= '2024-11-05'
);

-- FOR NEW RESERVATION ENTRY
INSERT INTO Reservations (GuestID, RoomID, CheckInDate, CheckOutDate, NumberOfGuests, Status, TotalPrice)
VALUES (101, 4, '2024-11-01', '2024-11-05', 2, 'Confirmed', 5000);

-- TOTAL REVENUE FOR SPECIFIC MONTH
SELECT SUM(AmountPaid) AS TotalRevenue
FROM Payments
WHERE PaymentDate BETWEEN '2024-10-01' AND '2024-10-31';

-- GUEST STAY HISTORY LIST ALL STAYS(RESERVATIONS)  FOR A SPECIFIC GUEST
SELECT r.ReservationID, r.CheckInDate, r.CheckOutDate, ro.RoomNumber, ro.RoomType, r.TotalPrice
FROM Reservations r
JOIN Guests g ON r.GuestID = g.GuestID
JOIN Rooms ro ON r.RoomID = ro.RoomID
WHERE g.LastName = 'Smith';

-- Room Occupancy Report:
-- Calculate how many rooms were occupied in a specific time frame
SELECT COUNT(DISTINCT RoomID) AS OccupiedRooms
FROM Reservations
WHERE CheckInDate <= '2024-10-15' AND CheckOutDate >= '2024-10-10' AND Status = 'Confirmed';

-- List of Guests by Reservation Date:
-- Get a list of guests with their reservation details within a specific time period.
SELECT g.FirstName, g.LastName, r.CheckInDate, r.CheckOutDate, ro.RoomNumber
FROM Reservations r
JOIN Guests g ON r.GuestID = g.GuestID
JOIN Rooms ro ON r.RoomID = ro.RoomID
WHERE r.CheckInDate BETWEEN '2024-10-01' AND '2024-10-31';

-- Staff Roster by Role:
-- Retrieve a list of staff based on their roles.
SELECT FirstName, LastName, Role
FROM Staff
WHERE Role = 'Receptionist';

-- High-Value Guests:
-- Find guests who have spent more than a certain amount across all their reservations.
SELECT g.FirstName, g.LastName, SUM(r.TotalPrice) AS TotalSpent
FROM Reservations r
JOIN Guests g ON r.GuestID = g.GuestID
GROUP BY g.GuestID
HAVING TotalSpent > 1000;

-- Write a query to find the guest who has spent the most on reservations
SELECT GUESTID, SUM(PRICEPERNIGHT * DATEDIFF(CheckOutDate,CheckInDate)) AS TOTALAMOUNT
FROM RESERVATIONS 
JOIN ROOMS ON RESERVATIONS.ROOMID=ROOMS.ROOMID
GROUP BY GUESTID
ORDER BY TOTALAMOUNT DESC
LIMIT 1;

-- Write a query to increase the price of all "Suite" rooms by 10%.
SET SQL_SAFE_UPDATES =0;
UPDATE ROOMS
SET PRICEPERNIGHT = PRICEPERNIGHT * 1.10
WHERE RoomType = 'Suite';

-- Find Guests Whose Name Starts With 'A'
SELECT GUESTID ,FIRSTNAME,LASTNAME
FROM GUESTS
WHERE FIRSTNAME LIKE  "A%";

-- Write a query to find the room that had the longest single reservation (i.e., the longest stay duration).
SELECT ROOMID, MAX(DATEDIFF(CheckOutDate,CheckInDate)) AS STAYDURATION
FROM RESERVATIONS
GROUP BY ROOMID 
ORDER BY STAYDURATION DESC
LIMIT 1;

--  List Guests Who Never Made a Reservation
SELECT GUESTID,FIRSTNAME,LASTNAME,CITY
FROM GUESTS
WHERE GUESTID NOT IN (SELECT GUESTID FROM RESERVATIONS);

-- Find Rooms That Have Never Been Reserved
select ROOMID,ROOMNUMBER
FROM ROOMS
WHERE ROOMID NOT IN(SELECT ROOMID FROM RESERVATIONS);

--  Find Guests Who Made Multiple Reservations on the Same Day
SELECT GUESTID,CheckInDate, COUNT(*) AS RESERVATIONCOUNTS
FROM RESERVATIONS
GROUP BY GUESTID,CheckInDate
HAVING COUNT(*)>1;

-- Update Guest Email Addresses by Adding a Domain
UPDATE guests
SET Email = CONCAT(Email, '@example.com')
WHERE Email NOT LIKE '%@%';

-- Write a query to find reservations that overlap with a specific date range,
-- e.g., from '2024-10-01' to '2024-10-10'
SELECT * FROM reservations
WHERE CheckInDate <= '2024-10-10' AND CheckOutDate >= '2024-10-01';

-- Write a query to find guests who spent more than the average spending on their reservations.
SELECT GuestID, SUM(PricePerNight * DATEDIFF(CheckOutDate, CheckInDate)) AS TotalSpent
FROM reservations
JOIN rooms ON reservations.RoomID = rooms.RoomID
GROUP BY GuestID
HAVING TotalSpent > (SELECT AVG(PricePerNight * DATEDIFF(CheckOutDate, CheckInDate)) 
                     FROM reservations
                     JOIN rooms ON reservations.RoomID = rooms.RoomID);