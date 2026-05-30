/*
========================================================================
DDL Script: Create Fraud Detection Database and Tables
========================================================================
Script Purpose:
    This script creates the Fraud_ml database and the
    transactions table used for fraud analytics,
    machine learning, and Tableau reporting.

Tables Created:
    dbo.transactions

Usage:
    Run this script once during project setup.

Project:
    FraudWatch-ML
========================================================================
*/

USE master;
GO

-- Create Database

IF DB_ID('Fraud_ml') IS NULL
BEGIN
    CREATE DATABASE Fraud_ml;
END;
GO

USE Fraud_ml;
GO

/*
========================================================================
Table: dbo.transactions
========================================================================
Description:
    Stores transaction-level data used for fraud analysis,
    SQL reporting, machine learning model training,
    and dashboard visualization.

Primary Key:
    transaction_id

Columns:
    transaction_id        - Unique transaction identifier
    amount                - Transaction amount
    transaction_hour      - Hour transaction occurred (0-23)
    merchant_category     - Merchant business category
    foreign_transaction   - Foreign transaction flag
    location_mismatch     - Billing vs transaction location mismatch
    device_trust_score    - Device trust score
    velocity_last_24h     - Number of transactions in last 24 hours
    cardholder_age        - Customer age
    is_fraud              - Fraud label
    high_amount_flag      - High-value transaction flag
========================================================================
*/

IF OBJECT_ID('dbo.transactions', 'U') IS NOT NULL
    DROP TABLE dbo.transactions;
GO

CREATE TABLE dbo.transactions
(
    transaction_id INT PRIMARY KEY,

    amount DECIMAL(10,2) NOT NULL,

    transaction_hour INT NOT NULL,

    merchant_category NVARCHAR(50) NOT NULL,

    foreign_transaction BIT NOT NULL,

    location_mismatch BIT NOT NULL,

    device_trust_score INT NOT NULL,

    velocity_last_24h INT NOT NULL,

    cardholder_age INT NOT NULL,

    is_fraud BIT NOT NULL,

    high_amount_flag BIT NOT NULL
);
GO

PRINT 'Table dbo.transactions created successfully.';
GO
