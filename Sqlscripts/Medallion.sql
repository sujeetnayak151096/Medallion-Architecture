CREATE DATABASE sujeetproject

USE sujeetproject

GO
CREATE EXTERNAL DATA SOURCE medallionproject
WITH ( location = 'abfss://bronze@applestoredata.dfs.core.windows.net/' );



CREATE EXTERNAL FILE FORMAT csv_file_format
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,
    FORMAT_OPTIONS ( FIELD_TERMINATOR = ',', STRING_DELIMITER = '"', FIRST_ROW = 2   )
);


SELECT *
FROM OPENROWSET(
    BULK 'Athletes.csv',
    DATA_SOURCE = 'medallionproject',
    FORMAT = 'CSV', PARSER_VERSION = '2.0',
    FIELDTERMINATOR =',',
    HEADER_ROW = TRUE
    ) AS [r]



-- CREATING EXTERNAL TABLE 


--Creating Silver Schema
CREATE SCHEMA Silver
GO

--External Tables Creation for Each files
-- ****** Athletes *******


CREATE EXTERNAL TABLE silver_athlets
( 
    PersonName VARCHAR(50),
    Country VARCHAR(50),
    Discipline VARCHAR(50)
) 
WITH (
    LOCATION = 'Athletes.csv',
    DATA_SOURCE = medallionproject, 
    FILE_FORMAT = csv_file_format
 );


SELECT TOP (100) [PersonName]
,[Country]
,[Discipline]
 FROM [dbo].[silver_athlets]




--****  Coaches ********

SELECT *
FROM OPENROWSET(
    BULK 'Coaches.csv',
    DATA_SOURCE = 'medallionproject',
    FORMAT = 'CSV', PARSER_VERSION = '2.0',
    FIELDTERMINATOR =',',
    HEADER_ROW = TRUE
    ) AS [r]

-- Removed Event Column and saved in Silver layer as an External Table 

CREATE EXTERNAL TABLE silver_coaches
( 
    [Name] VARCHAR(50),
    Country VARCHAR(50),
    Discipline VARCHAR(50)
) 
WITH (
    LOCATION = 'Coaches.csv',
    DATA_SOURCE = medallionproject, 
    FILE_FORMAT = csv_file_format
 );


SELECT TOP (100) [Name]
,[Country]
,[Discipline]
 FROM [dbo].[silver_coaches]




--- *** EntriesGender *****
SELECT *
FROM OPENROWSET(
    BULK 'EntriesGender.csv',
    DATA_SOURCE = 'medallionproject',
    FORMAT = 'CSV', PARSER_VERSION = '2.0',
    FIELDTERMINATOR =',',
    HEADER_ROW = TRUE
    ) AS [r]



CREATE EXTERNAL TABLE silver_EntriesGender
( 
    [Discipline] VARCHAR(50),
    Female INT,
    Male INT,
    Total INT
) 
WITH (
    LOCATION = 'EntriesGender.csv',
    DATA_SOURCE = medallionproject, 
    FILE_FORMAT = csv_file_format
 );




SELECT TOP (100) [Discipline]
,[Female]
,[Male]
,[Total]
 FROM [dbo].[silver_EntriesGender]



 ---- ******** Medals **** ------

SELECT *
FROM OPENROWSET(
    BULK 'Medals.csv',
    DATA_SOURCE = 'medallionproject',
    FORMAT = 'CSV', PARSER_VERSION = '2.0',
    FIELDTERMINATOR =',',
    HEADER_ROW = TRUE
    ) AS [r]


-- External Table --


CREATE EXTERNAL TABLE silver_Medals
( 
    [Rank] INT,
    TeamCountry VARCHAR(50),
    Gold INT,
    Silver INT,
    Bronze INT,
    Total INT  -- Removed Rank by Total colum  --- 
) 
WITH (
    LOCATION = 'Medals.csv',
    DATA_SOURCE = medallionproject, 
    FILE_FORMAT = csv_file_format
 );




SELECT TOP (100) [Rank]
,[TeamCountry]
,[Gold]
,[Silver]
,[Bronze]
,[Total]
 FROM [dbo].[silver_Medals]



---- ******* Teams *********


SELECT *
FROM OPENROWSET(
    BULK 'Teams.csv',
    DATA_SOURCE = 'medallionproject',
    FORMAT = 'CSV', PARSER_VERSION = '2.0',
    FIELDTERMINATOR =',',
    HEADER_ROW = TRUE
    ) AS [r]


--  External Table ---


CREATE EXTERNAL TABLE silver_Teams
( 
    TeamName VARCHAR(50),
    Discipline VARCHAR(50), 
    Country VARCHAR(50),
    [Event]  VARCHAR(50)
) 
WITH (
    LOCATION = 'Teams.csv',
    DATA_SOURCE = medallionproject, 
    FILE_FORMAT = csv_file_format
 );




SELECT TOP (100) [TeamName]
,[Discipline]
,[Country]
,[Event]
 FROM [dbo].[silver_Teams]









------ ****** Data Quality Check  *****  ------ 

-- Checking for Duplicate Values -- 
-- Athlets -- 
SELECT * FROM dbo.silver_athlets

SELECT 
    PersonName, Discipline, COUNT(1) AS DuplicateCount
FROM dbo.silver_athlets
GROUP BY PersonName, Discipline
HAVING COUNT(1) > 1;


--- Checking for Null Values ---- 

SELECT 
    SUM(CASE WHEN PersonName IS NULL THEN 1 ELSE 0 END) AS Null_PersonName,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN Discipline IS NULL THEN 1 ELSE 0 END) AS Null_Discipline
FROM dbo.silver_athlets;

-- Observations-- 
-- We get output '0' in each of the Column which indicated there is no Null value in our Athlete Dataset.
-- We get 2 Duplicate Values in Athlets Table 



-- Coaches -- 


SELECT 
    [Name], 
    Country, 
    Discipline,  
    COUNT(1) AS DuplicateCount
FROM dbo.silver_coaches
GROUP BY [Name], Country, Discipline
HAVING COUNT(1) > 1;



SELECT 
    SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN Discipline IS NULL THEN 1 ELSE 0 END) AS Null_Discipline
FROM dbo.silver_coaches;


-- Observations -- 
-- We have No Null Values 
-- We have 13 Duplicate Values in Coaches Table.




-- Gender Entries-- 



SELECT 
    Discipline, 
    Female, 
    Male, 
    Total, 
    COUNT(1) AS DuplicateCount
FROM dbo.silver_EntriesGender
GROUP BY Discipline, Female, Male, Total
HAVING COUNT(1) > 1;


SELECT 
    SUM(CASE WHEN [Discipline] IS NULL THEN 1 ELSE 0 END) AS Null_Discipline,
    SUM(CASE WHEN Female IS NULL THEN 1 ELSE 0 END) AS Null_Female,
    SUM(CASE WHEN Male IS NULL THEN 1 ELSE 0 END) AS Null_Male,
    SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS Null_Total
FROM dbo.silver_EntriesGender

-- Observation -- 
-- In this Table we dont have any Null Values nither any Duplicate values 



-- Medals -- 

SELECT 
    [Rank],
    TeamCountry,
    Gold,
    Silver,
    bronze,
    Total,  
    COUNT(1) AS DuplicateCount
FROM dbo.silver_Medals
GROUP BY [Rank],
    TeamCountry,
    Gold,
    Silver,
    bronze,
    Total
HAVING COUNT(1) > 1;




SELECT 
    SUM(CASE WHEN [Rank] IS NULL THEN 1 ELSE 0 END) AS Null_Rank,
    SUM(CASE WHEN TeamCountry IS NULL THEN 1 ELSE 0 END) AS Null_TeamCountry,
    SUM(CASE WHEN Gold IS NULL THEN 1 ELSE 0 END) AS Null_Gold,
    SUM(CASE WHEN Silver IS NULL THEN 1 ELSE 0 END) AS Null_Silver,
    SUM(CASE WHEN Bronze IS NULL THEN 1 ELSE 0 END) AS Null_Bronze,
    SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS Null_Total
FROM dbo.silver_Medals


-- No null Values nor Any Duplicate Values 

--- Teams -- 

SELECT 
    TeamName,
    Discipline,
    Country,
    Event,
    COUNT(1) AS DuplicateCount
FROM dbo.silver_Teams
GROUP BY TeamName,
    Discipline,
    Country,
    Event
HAVING COUNT(1) > 1;




SELECT 
    SUM(CASE WHEN [TeamName] IS NULL THEN 1 ELSE 0 END) AS Null_TeamName,
    SUM(CASE WHEN [Discipline] IS NULL THEN 1 ELSE 0 END) AS Null_Discipline,
    SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
    SUM(CASE WHEN Event IS NULL THEN 1 ELSE 0 END) AS Null_Event
FROM dbo.silver_Teams

--- No Null or Duplicate Values in Teams Table.




--- Created a Gold Layer by Removing all the Duplicate values from Coaches Table 

CREATE EXTERNAL TABLE gold_coaches
WITH(
    LOCATION = 'golddata',
    DATA_SOURCE = medallionproject,
    FILE_FORMAT = csv_file_format
)
AS
SELECT [Name], Country, Discipline
FROM dbo.silver_coaches
EXCEPT
SELECT [Name], Country, Discipline
FROM dbo.silver_coaches
GROUP BY [Name], Country, Discipline
HAVING COUNT(1) > 1;

SELECT * FROM gold_coaches





-- Creating a Gold Layer for Athlets by Removing the Duplicate values 

CREATE EXTERNAL TABLE gold_athlets
WITH(
    LOCATION = 'goldathletedata',
    DATA_SOURCE = medallionproject,
    FILE_FORMAT = csv_file_format
)
AS
SELECT [PersonName], Country, Discipline
FROM dbo.silver_athlets
EXCEPT
SELECT [PersonName], Country, Discipline
FROM dbo.silver_athlets
GROUP BY [PersonName], Country, Discipline
HAVING COUNT(1) > 1;

SELECT * FROM gold_athlets



DROP EXTERNAL TABLE silver_athlets

DROP EXTERNAL TABLE silver_coaches

