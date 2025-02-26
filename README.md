# Tenancy Management System - SQL Project
## Overview
This project involves designing and querying a relational database to manage tenant information, rental histories, and referral systems for a property management company. The goal is to extract meaningful insights from the data to support decision-making, such as identifying tenant behavior, optimizing rental income, and improving referral systems.

## Database Schema
The database, named Tenant, consists of the following tables:
- Tenancy_histories: Stores tenant move-in and move-out dates, rent, and other details.
- Profiles: Contains tenant personal information such as name, email, phone, and city.
- Houses: Holds details about the properties, including house type, BHK details, and bed count.
- Addresses: Stores address details for each house.
- Referrals: Tracks referral information, including referral bonuses and validity.
- Employment_details: Contains employment information for tenants.

## Project Questions and Solutions
The project addresses the following key questions:
- Longest Staying Tenant: Identify the tenant who stayed the longest.
- Married Tenants Paying High Rent: Extract details of married tenants paying rent above 9000.
- City-wise Rent Analysis: Calculate the total rent generated from each city and the overall rent across all cities.
- Referral Bonus Calculation: Find tenants who referred more than once and calculate their total valid referral bonuses.
- Customer Segmentation: Segment tenants into Grade A, B, or C based on their rent payments.
- Occupancy Analysis: Identify the house with the highest occupancy rate.
- Tenant Details with Referrals: Display tenant details along with the number of referrals made, latest employer, and occupational category.
- Tenants Without Referrals: Find tenants who have not made any referrals.
- View Creation: Create a view to simplify access to tenant data who moved in after a specific date and live in houses with vacant beds.
- Referral Validity Extension: Extend the referral validity date for tenants who referred more than once.

## SQL Techniques Used
- Joins: Combine data from multiple tables.
- Subqueries: Filter data based on conditions.
- Aggregate Functions: Perform calculations like sum and count.
- CASE Statements: Implement conditional logic for tenant segmentation.
- Date Manipulation: Handle date-related queries and updates.
- Views: Simplify access to frequently queried data.

## Files
Project Code.sql: Contains the SQL script for database creation and queries.

## Outcome
- Improved Decision-Making: Insights derived can help optimize rental strategies and improve tenant satisfaction.
- Efficient Data Management: Ensures efficient data retrieval and analysis.
- Actionable Recommendations: Guides property acquisition and referral incentive decisions.

## Skills Showcased
- Database Design
- SQL Querying
- Data Analysis
- Problem-Solving

Feel free to explore the project and reach out if you have any questions or suggestions!

#SQL #DataAnalysis #DatabaseDesign #TenantManagement #BusinessInsights
