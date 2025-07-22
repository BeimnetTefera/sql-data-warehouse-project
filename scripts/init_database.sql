/*
=============================================
CREATE Database and Schemas
=============================================
Script purpose:
	This Script creates a new database named 'DataWarehouse'. 
	If it already exists, it is dropped and recreated. 
	It also creates three schemas: bronze, silver, gold.
WARNING:
	This will DROP the 'DataWarehouse' database and delete all its contents.
	Make sure to back up your data!
*/

-- DROP AND RECRREATE THE 'DataWarehouse' DATABASE --
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END
GO

-- CREATE DATABASE WAREHOUSE --
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- DROP SCHEMAS IF THEY ALREADY EXISTS --
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'bronze') EXEC('DROP SCHEMA bronze');
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver') EXEC('DROP SCHEMA silver');
IF EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')   EXEC('DROP SCHEMA gold');
GO

-- CREATE SCHEMAS --
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
