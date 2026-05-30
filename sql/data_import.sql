/*
=========================================================
Load Fraud Dataset
=========================================================
Purpose:
    Load cleaned fraud transaction data from CSV into
    dbo.transactions table.

Source:
    cleaned_fraud_data.csv

Target:
    dbo.transactions
=========================================================
*/

USE Fraud_ml;
GO

BEGIN TRY

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME;

    SET @start_time = GETDATE();

    PRINT '=========================================';
    PRINT 'Loading Fraud Transaction Dataset';
    PRINT '=========================================';

    PRINT 'Truncating Existing Data...';

    TRUNCATE TABLE dbo.transactions;

    PRINT 'Importing CSV Data...';

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

    PRINT '-----------------------------------------';
    PRINT 'Data Load Completed Successfully';
    PRINT 'Load Duration: '
          + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
          + ' seconds';
    PRINT '-----------------------------------------';

    PRINT 'Data Validation';

    SELECT
        COUNT(*) AS Total_Transactions
    FROM dbo.transactions;

    SELECT
        SUM(CAST(is_fraud AS INT)) AS Total_Fraud_Transactions
    FROM dbo.transactions;

    SELECT TOP 10 *
    FROM dbo.transactions;

END TRY

BEGIN CATCH

    PRINT '=========================================';
    PRINT 'ERROR OCCURRED DURING DATA LOAD';
    PRINT '=========================================';

    PRINT 'Error Message: ' + ERROR_MESSAGE();

    PRINT 'Error Number: '
          + CAST(ERROR_NUMBER() AS NVARCHAR);

    PRINT 'Error State: '
          + CAST(ERROR_STATE() AS NVARCHAR);

    PRINT 'Error Line: '
          + CAST(ERROR_LINE() AS NVARCHAR);

END CATCH;
GO
