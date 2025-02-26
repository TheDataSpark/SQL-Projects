CREATE DATABASE Tenant;
USE Tenant;
CREATE TABLE Tenancy_histories (
    id INT PRIMARY KEY IDENTITY(1,1),
    profile_id INT NOT NULL,
    house_id INT NOT NULL,
    move_in_date DATE NOT NULL,
    move_out_date DATE,
    rent INT NOT NULL,
    Bed_type VARCHAR(255),
    move_out_reason VARCHAR(255)
);
CREATE TABLE Profiles (
    profile_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255) NOT NULL,
	phone VARCHAR(255) NOT NULL,
	city VARCHAR(255), --hometown
	pan_card VARCHAR(255), --not available in the given data
	created_at DATE NOT NULL,
	gender VARCHAR(255) NOT NULL,
	referral_code VARCHAR(255),
	marital_status VARCHAR(255)
);
CREATE TABLE Houses (
	house_id INT PRIMARY KEY IDENTITY(1,1),
	house_type VARCHAR(255),
	bhk_details VARCHAR(255),
	bed_count INT NOT NULL,
	furnishing_type VARCHAR(255),
	Beds_vacant INT NOT NULL
);
CREATE TABLE Addresses (
	ad_id INT PRIMARY KEY IDENTITY (1,1),
	[name] VARCHAR(255),
	[description] TEXT,
	pincode INT,
	city VARCHAR(255),
	house_id INT NOT NULL,
);
CREATE TABLE Referrals (
	ref_id INT PRIMARY KEY IDENTITY (1,1),
	profile_id INT NOT NULL,
	referrer_bonus_amount FLOAT,
	referral_valid TINYINT DEFAULT 0,
    valid_from DATE,
    valid_till DATE
);
CREATE TABLE Employment_details (
	id INT PRIMARY KEY IDENTITY (1,1),
	profile_id INT NOT NULL,
	latest_employer VARCHAR(255),
	official_mail_id VARCHAR(255),
	yrs_experience INT,
	Occupational_category VARCHAR(255)
);

-- Project Solutions

-- Q1) Write a query to get Profile ID, Full Name and Contact Number of the tenant who has stayed 
-- with us for the longest time period in the past

USE Tenant
SELECT TOP 1 
    th.profile_id AS Profile_ID,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    p.phone AS Contact_Number,
    DATEDIFF(DAY, th.move_in_date, th.move_out_date) AS Stay_Duration
FROM Tenancy_histories th
JOIN Profiles p ON th.profile_id = p.profile_id
WHERE th.move_out_date IS NOT NULL
ORDER BY Stay_Duration DESC;

--Q2) Write a query to get the Full name, email id, phone of tenants who are married and paying.
--rent > 9000 using subqueries

SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    p.email_id AS Email_ID,
    p.phone AS Phone_Number
FROM Profiles p
WHERE p.marital_status = 'Y'
  AND p.profile_id IN (
      SELECT profile_id
      FROM Tenancy_histories
      WHERE rent > 9000
  );

  --Q3) Write a query to display profile id, full name, phone, email id, city, house id, move_in_date ,
--move_out date, rent, total number of referrals made, latest employer and the occupational
--category of all the tenants living in Bangalore or Pune in the time period of jan 2015 to jan
--2016 sorted by their rent in descending order

SELECT 
    th.profile_id AS Profile_ID,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    p.phone AS Phone_Number,
    p.email_id AS Email_ID,
    p.city AS City,
    th.house_id AS House_ID,
    th.move_in_date AS Move_In_Date,
    th.move_out_date AS Move_Out_Date,
    th.rent AS Rent,
    (SELECT COUNT(*) FROM Referrals r WHERE r.profile_id = p.profile_id) AS Total_Referrals,
    e.latest_employer AS Latest_Employer,
    e.Occupational_category AS Occupational_Category
FROM Tenancy_histories th
JOIN Profiles p ON th.profile_id = p.profile_id
LEFT JOIN Employment_details e ON p.profile_id = e.profile_id
WHERE p.city IN ('Bangalore', 'Pune')
  AND th.move_in_date >= '2015-01-01'
  AND th.move_out_date <= '2016-01-31'
ORDER BY th.rent DESC;

-- Q4) Write a sql snippet to find the full_name, email_id, phone number and referral code of all
--the tenants who have referred more than once. Also find the total bonus amount they should receive 
--given that the bonus gets calculated only for valid referrals.


SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    p.email_id AS Email_ID,
    p.phone AS Phone_Number,
    p.referral_code AS Referral_Code,
    SUM(r.referrer_bonus_amount) AS Total_Valid_Bonus
FROM Profiles p
JOIN Referrals r ON p.profile_id = r.profile_id
WHERE r.referral_valid = 1
GROUP BY p.profile_id, p.first_name, p.last_name, p.email_id, p.phone, p.referral_code
HAVING COUNT(r.ref_id) > 1;

--Q5) Write a query to find the rent generated from each city and also the total of all cities

-- Rent generated from each city
SELECT 
    p.city AS City,
    SUM(th.rent) AS Total_Rent
FROM Tenancy_histories th
JOIN Profiles p ON th.profile_id = p.profile_id
GROUP BY p.city;

-- Total rent generated across all cities
SELECT 
    SUM(th.rent) AS Total_Rent_all_cities
FROM Tenancy_histories th;

--Q6) Create a view 'vw_tenant' find profile_id, rent, move_in_date, house_type, beds_vacant, description and city of tenants 
--who shifted on/after 30th april 2015 and are living in houses having vacant beds and its address.

CREATE VIEW vw_tenant AS
SELECT 
    th.profile_id AS Profile_ID,
    th.rent AS Rent,
    th.move_in_date AS Move_In_Date,
    h.house_type AS House_Type,
    h.beds_vacant AS Beds_Vacant,
    a.description AS Address_Description,
    a.city AS City
FROM Tenancy_histories th
JOIN Houses h ON th.house_id = h.house_id
JOIN Addresses a ON h.house_id = a.house_id
WHERE th.move_in_date >= '2015-04-30'
  AND h.beds_vacant > 0;

SELECT * 
FROM [Tenant].[dbo].[vw_tenant];

-- Q7) Write a code to extend the valid_till date for a month of tenants who have referred more than one time.

WITH referral_counts AS (
    SELECT profile_id, COUNT(*) AS referral_count
    FROM Referrals
    GROUP BY profile_id
    HAVING COUNT(*) > 1
)
UPDATE Referrals
SET valid_till = DATEADD(MONTH, -1, valid_till)
FROM Referrals rf
JOIN referral_counts r ON rf.profile_id = r.profile_id;

SELECT * FROM Referrals;

--Making inclusions for only valid referrals
WITH referral_counts AS (
    SELECT profile_id, COUNT(*) AS referral_count
    FROM Referrals
    WHERE referral_valid = 1 -- only considering valid referrals
    GROUP BY profile_id
    HAVING COUNT(*) > 1
)
UPDATE Referrals
SET valid_till = DATEADD(MONTH, 1, valid_till)
FROM Referrals rf
JOIN referral_counts r ON rf.profile_id = r.profile_id
WHERE rf.referral_valid = 1; -- ensuring only valid referrals are updated


-- Q8) Write a query to get Profile ID, Full Name, Contact Number of the tenants along with a new
-- column 'Customer Segment' wherein if the tenant pays rent greater than 10000, tenant falls
-- in Grade A segment, if rent is between 7500 to 10000, tenant falls in Grade B else in Grade C.

SELECT 
    th.profile_id AS Profile_ID,
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    p.phone AS Contact_Number,
    CASE 
        WHEN th.rent > 10000 THEN 'Grade A'
        WHEN th.rent BETWEEN 7500 AND 10000 THEN 'Grade B'
        ELSE 'Grade C'
    END AS Customer_Segment
FROM Tenancy_histories th
JOIN Profiles p ON th.profile_id = p.profile_id;

-- Q9) Write a query to get Fullname, Contact, City and House Details of the tenants who have not
-- referred even once.

SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS Full_Name,
    p.phone AS Contact,
    p.city AS City,
    h.house_type AS House_Type,
    h.bhk_details AS BHK_Details
FROM Profiles p
JOIN Tenancy_histories th ON p.profile_id = th.profile_id
JOIN Houses h ON th.house_id = h.house_id
WHERE p.profile_id NOT IN (
    SELECT DISTINCT ref_id
    FROM Referrals
);

-- 10) Write a query to get the house details of the house having highest occupancy.

SELECT TOP 1 
    h.house_id AS House_ID,
    h.house_type AS House_Type,
    h.bhk_details AS BHK_Details,
    h.bed_count AS Total_Beds,
    h.beds_vacant AS Vacant_Beds,
    (h.bed_count - h.beds_vacant) AS Occupied_Beds
FROM Houses h
ORDER BY Occupied_Beds DESC;

