/*
========================================================================
Stored Procedure: Load Fraud Transactions Data
========================================================================
Script Purpose:
    This script loads fraud transaction data from a CSV file
    into the dbo.transactions table.

Operations:
    1. Truncates existing records.
    2. Loads fresh data using BULK INSERT.
    3. Validates row counts.
    4. Measures execution time.
    5. Handles runtime errors.

Target Table:
    dbo.transactions

Project:
    FraudWatch-ML

Usage:
    Run after schema.sql has been executed.

IMPORTANT:
    Update the CSV file path below before execution.
========================================================================
*/

USE Fraud_ml;
GO

BEGIN TRY

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME;

    PRINT '==============================================';
    PRINT 'Loading Fraud Transaction Dataset';
    PRINT '==============================================';

    SET @start_time = GETDATE();

    PRINT '----------------------------------------------';
    PRINT 'Step 1: Truncating Existing Data';
    PRINT '----------------------------------------------';

    TRUNCATE TABLE dbo.transactions;

    PRINT '----------------------------------------------';
    PRINT 'Step 2: Loading CSV Data';
    PRINT '----------------------------------------------';

    BULK INSERT dbo.transactions
    FROM 'F:\prog\python\fraud_ml\cleaned_fraud_data.csv'
    WITH
    (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );

    SET @end_time = GETDATE();

    PRINT '----------------------------------------------';
    PRINT 'Data Load Completed Successfully';
    PRINT '----------------------------------------------';

    PRINT 'Load Duration: '
        + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
        + ' seconds';

    PRINT '----------------------------------------------';
    PRINT 'Step 3: Data Validation';
    PRINT '----------------------------------------------';

    SELECT
        COUNT(*) AS Total_Transactions
    FROM dbo.transactions;

    SELECT
        SUM(CAST(is_fraud AS INT)) AS Fraud_Transactions
    FROM dbo.transactions;

    SELECT
        SUM(CASE WHEN is_fraud = 0 THEN 1 ELSE 0 END)
            AS Legitimate_Transactions
    FROM dbo.transactions;

    PRINT '----------------------------------------------';
    PRINT 'Sample Records';
    PRINT '----------------------------------------------';

    SELECT TOP 10 *
    FROM dbo.transactions;

    PRINT '==============================================';
    PRINT 'Fraud Dataset Loaded Successfully';
    PRINT '==============================================';

END TRY

BEGIN CATCH

    PRINT '==============================================';
    PRINT 'ERROR OCCURRED DURING DATA LOAD';
    PRINT '==============================================';

    PRINT 'Error Message: '
        + ERROR_MESSAGE();

    PRINT 'Error Number: '
        + CAST(ERROR_NUMBER() AS NVARCHAR);

    PRINT 'Error Severity: '
        + CAST(ERROR_SEVERITY() AS NVARCHAR);

    PRINT 'Error State: '
        + CAST(ERROR_STATE() AS NVARCHAR);

    PRINT 'Error Line: '
        + CAST(ERROR_LINE() AS NVARCHAR);

    PRINT '==============================================';

END CATCH;
GO
