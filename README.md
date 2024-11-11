# Medallion Architecture Project: Tokyo Olympics 2021 Medal Tally Analysis

## Table of Contents
1. [Overview](#overview)
2. [Dataset](#dataset)
3. [Architecture Layers](#architecture-layers)
   - [Bronze Layer (Raw Data Ingestion)](#1-bronze-layer-raw-data-ingestion)
   - [Silver Layer (Data Cleansing and Transformation)](#2-silver-layer-data-cleansing-and-transformation)
   - [Gold Layer (Curated Data for Visualization)](#3-gold-layer-curated-data-for-visualization)
5.  [Data Visualization in Power BI](#data-visualization-in-power-bi)
6. [Conclusion](#conclusion)
7. [Summary](#summary)
8. [Author](#author)

   

## Overview

This project implements a Medallion Architecture with three data layers (Bronze, Silver, and Gold) to analyze the Tokyo Olympics 2021 medal tally. The data flows through different layers, from raw ingestion to cleaning and transformation, finally being visualized in Power BI.

## Dataset

The project uses a dataset in CSV format containing details about over 11,000 athletes, 47 disciplines, and 743 teams. The dataset includes:

- Athlete names, countries, and disciplines
- Gender entries
- Coaches and teams
- Medal counts (Gold, Silver, Bronze)

  ## Architecture Layers

### 1. Bronze Layer (Raw Data Ingestion)
- In the Bronze Layer, I ingested the raw CSV file into ADLS Gen 2 Account:

  ![image](https://github.com/user-attachments/assets/85b6310e-01ee-4beb-93d7-28c33f886fcf)


  ![image](https://github.com/user-attachments/assets/a54afb33-84fe-45bb-b42a-6c5de0182e11)


- This Query successfully read the raw data and loaded it into the Bronze Layer for further manipulation. The Bronze Layer serves as the landing zone for raw, uncleaned data.


  ![image](https://github.com/user-attachments/assets/ffc0577a-7980-4803-8d2e-4391b9b587e8)


- To clean the data and store it in the Silver Layer, we need to create an external table. We begin by setting up a database and an external data source, specifying the storage location of the dataset. Additionally, we create a file format that will allow us to read the data in the specified structure. This ensures that the data is properly prepared for analysis in the Silver Layer.

![image](https://github.com/user-attachments/assets/7c0c8d6f-d13e-43f3-aac1-5d0f6b3bedfd)


- The database 'sujeetproject' has now been created. We also set up the external data source 'medallionproject', which specifies the Storage Account link from where the data will be sourced. Additionally, an external file format in 'DELIMITEDTEXT' has been defined since all our data is in .csv format, with ',' as the delimiter.

- We can view our Database, Data Source, and File Format by navigating to the Workspace under the Data tab.
  

  ![image](https://github.com/user-attachments/assets/da5e7b3e-a6bb-4ebd-996e-286b8f797acc)


- Now we have created an External Table for each file to store the data in the Silver Layer.


### 2. Silver Layer (Data Cleansing and Transformation)
-In the Silver Layer, I cleaned and transformed the raw data by renaming columns, ensuring proper data types, and checking for any null or duplicated values.

![image](https://github.com/user-attachments/assets/3da7d293-734a-4f4c-8b35-0433a7300723)


![image](https://github.com/user-attachments/assets/65c32200-9081-4368-95da-d6ee78811246)


- Run the query to check if the external table "silver.athlets" is properly displaying the output. We are getting the Desired output.

  ![image](https://github.com/user-attachments/assets/af74229a-03d8-4621-b51c-2b178d348d36)


- Similarly, I created an external table for all the files, including Coaches, GenderEntries, Team, and Medal.


![image](https://github.com/user-attachments/assets/74f20c84-8a2e-43e5-aaee-05274a1e8c28)


- Now it's time to clean the data and check for any null or duplicated values.


![image](https://github.com/user-attachments/assets/0a8ff83e-78d4-408c-a1e8-29541df0c042)


- I ran the query to check for duplicate values in silver_athlets and found that there are 2 duplicate values.


![image](https://github.com/user-attachments/assets/00e5c51f-13d4-450b-b3c3-28e6d3efaf12)


![image](https://github.com/user-attachments/assets/66b0c164-d4a3-4f3e-9b99-c45a27dd699a)


- I Run query to check for Null Values in silver_athlets from Output we can see that there is no Null Values.


  ![image](https://github.com/user-attachments/assets/0dff3dc5-7e95-4766-ac22-d768519253a1)



- Similarly I Checked for all the Tables.

## For `silver_coaches`



### Identifying Duplicate Records

```sql

SELECT

   [Name], 

   Country, 

   Discipline,  

   COUNT(1) AS DuplicateCount

FROM dbo.silver_coaches

GROUP BY [Name], Country, Discipline

HAVING COUNT(1) > 1;



Checking for Null Values



SELECT

   SUM(CASE WHEN Name IS NULL THEN 1 ELSE 0 END) AS Null_Name,

   SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,

   SUM(CASE WHEN Discipline IS NULL THEN 1 ELSE 0 END) AS Null_Discipline

FROM dbo.silver_coaches;



For silver_EntriesGender



Identifying Duplicate Records



SELECT

   Discipline, 

   Female, 

   Male, 

   Total, 

   COUNT(1) AS DuplicateCount

FROM dbo.silver_EntriesGender

GROUP BY Discipline, Female, Male, Total

HAVING COUNT(1) > 1;



Checking for Null Values



SELECT

   SUM(CASE WHEN [Discipline] IS NULL THEN 1 ELSE 0 END) AS Null_Discipline,

   SUM(CASE WHEN Female IS NULL THEN 1 ELSE 0 END) AS Null_Female,

   SUM(CASE WHEN Male IS NULL THEN 1 ELSE 0 END) AS Null_Male,

   SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS Null_Total

FROM dbo.silver_EntriesGender;



For silver_Teams



Identifying Duplicate Records



SELECT

   TeamName,

   Discipline,

   Country,

   Event,

   COUNT(1) AS DuplicateCount

FROM dbo.silver_Teams

GROUP BY TeamName, Discipline, Country, Event

HAVING COUNT(1) > 1;



Checking for Null Values



SELECT

   SUM(CASE WHEN [TeamName] IS NULL THEN 1 ELSE 0 END) AS Null_TeamName,

   SUM(CASE WHEN [Discipline] IS NULL THEN 1 ELSE 0 END) AS Null_Discipline,

   SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,

   SUM(CASE WHEN Event IS NULL THEN 1 ELSE 0 END) AS Null_Event

FROM dbo.silver_Teams;



For silver_Medals



Identifying Duplicate Records



SELECT

   [Rank],

   TeamCountry,

   Gold,

   Silver,

   Bronze,

   Total,  

   COUNT(1) AS DuplicateCount

FROM dbo.silver_Medals

GROUP BY [Rank], TeamCountry, Gold, Silver, Bronze, Total

HAVING COUNT(1) > 1;



Checking for Null Values



SELECT

   SUM(CASE WHEN [Rank] IS NULL THEN 1 ELSE 0 END) AS Null_Rank,

   SUM(CASE WHEN TeamCountry IS NULL THEN 1 ELSE 0 END) AS Null_TeamCountry,

   SUM(CASE WHEN Gold IS NULL THEN 1 ELSE 0 END) AS Null_Gold,

   SUM(CASE WHEN Silver IS NULL THEN 1 ELSE 0 END) AS Null_Silver,

   SUM(CASE WHEN Bronze IS NULL THEN 1 ELSE 0 END) AS Null_Bronze,

   SUM(CASE WHEN Total IS NULL THEN 1 ELSE 0 END) AS Null_Total

FROM dbo.silver_Medals;

```

### OBSERVATIONS: 

•	The silver_athletes table contains 3 duplicate values and no null values.


•	The silver_coaches table has 13 duplicate values and no null values.


•	All other tables do not have any duplicates or null values.


For visualization purposes, we need cleaned data, so we will store our data in the gold layer by removing the duplicate values from the silver_athletes and silver_coaches tables.


I have used a CETAS (Create External Table As Select) statement to remove the duplicate values and store the cleaned data in the gold layer.



### 3. Gold Layer (Curated Data for Visualization)
- Cleaned and transformed data is stored here.
- Duplicate records are removed using CETAS (Create External Table As Select).
- Data is ready for visualization in Power BI.

  ![image](https://github.com/user-attachments/assets/fead1759-519a-4d20-830e-ebd9ba742a28)


  ![image](https://github.com/user-attachments/assets/9e8aa0ad-7e0d-4878-bcc8-9257ba5ff522)


- We can view the updated table by clicking on Workspace and checking in the External Tables section.

  ![image](https://github.com/user-attachments/assets/589bfceb-02e4-484a-a3af-d9ad5740e703)


- Now, we can drop the silver_athletes and silver_coaches external tables.

  ![image](https://github.com/user-attachments/assets/ae9c38a7-5d55-4852-9e9e-4bd0be31899f)



- We now have a total of six tables that are cleaned and ready for visualization using Power BI.


  ![image](https://github.com/user-attachments/assets/f3876872-f60d-4dc0-996e-3e31ab957730)


  ### Integrating Power BI with Azure Synapse SQL Pool

  ![image](https://github.com/user-attachments/assets/302189aa-8f03-4946-b25d-ed7e9fd569a4)


  ![image](https://github.com/user-attachments/assets/d26e3465-1371-4365-97cc-4f3a1f5724ec)                 ![image](https://github.com/user-attachments/assets/3a68fac2-d584-4c50-a563-a980ba22eabf)





## Data Visualization in Power BI

To prepare the data for visualization in Power BI, I connected Azure Synapse Analytics to Power BI Desktop by selecting the desired workspace and tables.

Description of your Power BI dashboard ‘1’ below:

•	Displays the total count of Gold (340), Silver (338), and Bronze (402) medals won during the event.


•	Shows the total number of participants (11K) and the number of countries that participated in the event (93).


•	Highlights the total number of disciplines (46) and the overall number of medals awarded (1080).


•	A vertical bar chart shows the top countries by the number of medals won, with United States leading with 113 medals, followed by People's Republic of China with 88 medals and ROC (Russian Olympic Committee) with 71 medals.


•	A pie chart provides a comparison of male and female participants, with 48% Male (5K) and 52% Female (6K) participants.


•	A world map shows the distribution and count of athletes by country, represented by green circles of varying sizes, indicating the number of athletes from each country.



![image](https://github.com/user-attachments/assets/9ddfca49-7330-45be-9809-bf20ddba6700)


- This dashboard provides a comprehensive overview of the Tokyo Olympics, including the number of medals, participants, and countries, as well as a breakdown of gender participation and the geographic distribution of athletes.



## Description of your Power BI dashboard ‘2’ below:

•	Displays the total number of coaches (394) who participated in the event.


•	A selection panel on the dashboard allows users to choose a specific country for a more focused analysis of the data.


•	A detailed table shows the gender distribution (Female and Male) for each sport, such as Athletics, Artistic Gymnastics, Basketball, and Boxing etc. For example, Athletics has 969 Female participants and 1072 Male participants.


•	A horizontal bar chart visualizes the number of athletes per country, with United States having the most (615 athletes), followed by Japan (586) and Australia (470).


•	A stacked bar chart shows the sum of female and male athletes for each discipline. For instance, Athletics has the highest participation with 669 females and 1072 males, while other sports like Rhythmic Gymnastics and Swimming also show notable gender participation.


•	A pie chart breaks down the gold medal distribution by country, with United States, People’s Republic of China, Japan, and Great Britain among the top countries in terms of gold medals won.


**This dashboard provides more detailed insights, focusing on gender distribution, athletes by country and discipline, and gold medal allocation across participating nations, offering a comprehensive breakdown of Olympic participation and performance**

  
![image](https://github.com/user-attachments/assets/bea9f156-a973-47ec-a396-a63100235f28)


## Conclusion
The Medallion Architecture framework provided a robust and scalable method for processing and visualizing data. By leveraging Azure Synapse Analytics for data ingestion and cleansing, followed by Power BI for interactive visualizations, I was able to deliver clear insights into the Tokyo Olympics 2021. The integration of Bronze, Silver and Gold layers ensured data consistency and high-quality reporting, making this architecture ideal for large-scale analytics projects.


**Error Logs**

| Error No. | Error Title                         | Description                                                                                                    | Error Message                                                                          | Resolution                                                                                                 |
|-----------|-------------------------------------|----------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| 1         | Incorrect Data Types in CSV File    | When loading the Olympics 2021 medal tally CSV into Azure Synapse via the OPENROWSET query, numeric columns (Gold, Silver, Bronze, Total) were interpreted as strings (nvarchar). | No explicit error, but during further calculations and aggregations, the wrong data type caused issues. | Changed the data type of these columns from nvarchar to int.                                               |
| 2         | External Table Creation Fails in Silver Layer | When creating the External Table in the Silver Layer, specifying incorrect data source or file format caused the failure. | External Table Creation Failed: Cannot find DATA_SOURCE [project_synapsedataset1996.dfs.core.windows.net]. | - Double-check the DATA_SOURCE and FILE_FORMAT definitions. <br> - Ensure that the data source is correctly linked to the ADLS Gen 2 Storage Account. <br> - Correct CREATE EXTERNAL TABLE syntax. |




- When using Azure Synapse Analytics' serverless SQL pool, I have encounter some restrictions and challenges, especially when working with larger or more complex workloads. These limitations can often be addressed by switching to a dedicated SQL pool or a Spark pool. Here’s a comparison of the potential difficulties and how they can be resolved by using these other pools:

**1. Performance and Scaling**
•	Serverless SQL Pool:

o	Limitation: Serverless SQL pools are optimized for on-demand, ad-hoc queries. They do not provide performance guarantees, and query performance can degrade with larger datasets due to the lack of dedicated resources.


o	Resolution with Dedicated SQL Pool: Dedicated SQL pools provide pre-provisioned compute resources, allowing for more predictable performance, faster queries, and better scaling for large datasets, especially in highly concurrent workloads.


o	Resolution with Spark Pool: Spark pools are optimized for large-scale distributed data processing, which can handle massive datasets and complex transformations with better scalability.


 **2. Data Storage and Management**

•	Serverless SQL Pool:

o	Limitation: Data must reside in external storage (e.g., Azure Data Lake), and the serverless pool can only query external tables. This limits your control over indexing, partitioning, and other advanced database management features.


o	Resolution with Dedicated SQL Pool: A dedicated pool allows you to store data internally in the database with full control over how the data is stored, indexed, and partitioned. This results in better query optimization and management.


o	Resolution with Spark Pool: Spark pools can process data directly from external storage, but with Spark’s distributed architecture, you can manage data through partitioning and distributed file systems like Parquet.


**3. Concurrency and Query Limits**
•	Serverless SQL Pool:

o	Limitation: There are limitations on the number of concurrent queries and resource allocation, which can become problematic if you have high concurrency requirements (e.g., many users running queries simultaneously).

o	Resolution with Dedicated SQL Pool: A dedicated SQL pool provides isolated resources, so concurrency limitations are minimized, and performance can be scaled by increasing the number of data warehouse units (DWUs).

o	Resolution with Spark Pool: Spark pools are designed for distributed processing, which naturally supports high concurrency for both batch processing and streaming workloads.


**4. Advanced Query Optimization and Features**
•	Serverless SQL Pool:

o	Limitation: Advanced query optimizations like materialized views, columnstore indexes, or clustered indexes are not available, making complex query optimization difficult.

o	Resolution with Dedicated SQL Pool: Dedicated pools support advanced optimization features such as materialized views, indexed tables, and partitioning for faster query performance.


o	Resolution with Spark Pool: Spark’s optimization engine (Catalyst) allows advanced optimizations, but it is more suitable for complex ETL workloads rather than transactional processing or ad-hoc querying.


**5. Transactional Support**
•	Serverless SQL Pool:

o	Limitation: Serverless SQL pools do not support transactional processing (ACID properties), which may limit your ability to handle transactional workloads or perform consistent updates/deletes.

o	Resolution with Dedicated SQL Pool: Dedicated SQL pools fully support transactional processing, enabling consistent, isolated transactions, and complex updates/deletes.

o	Resolution with Spark Pool: Spark pools support ACID transactions through Delta Lake, which adds reliability to data processing pipelines.


**6. ETL and Data Transformation**
•	Serverless SQL Pool:

o	Limitation: Serverless SQL pools are not ideal for complex ETL (Extract, Transform, Load) workflows or machine learning, as the SQL language has limited capabilities for these operations.

o	Resolution with Dedicated SQL Pool: Dedicated pools offer a more structured environment for running ETL processes but still lack the flexibility of handling machine learning and advanced transformations.

o	Resolution with Spark Pool: Spark pools excel in data transformation, complex ETL, and machine learning with support for both SQL-based and programmatic data processing (via Python, Scala, or Java).


**7. Streaming Data**
•	Serverless SQL Pool:

o	Limitation: Real-time streaming support is limited with serverless SQL pools, and they are not designed for handling streaming workloads.

o	Resolution with Dedicated SQL Pool: Dedicated SQL pools are also not optimized for real-time streaming but can handle batch loads effectively.

o	Resolution with Spark Pool: Spark pools are ideal for handling streaming data using Spark Streaming, making it possible to process large volumes of streaming data in real-time.


## Summary

| Feature               | Serverless SQL Pool                                 | Dedicated SQL Pool                                  | Spark Pool                                 |
|-----------------------|-----------------------------------------------------|-----------------------------------------------------|--------------------------------------------|
| Performance & Scaling | Limited for large datasets                          | Pre-provisioned resources                           | Distributed processing, scalable          |
| Data Storage          | External data only                                  | Internal data with management                       | External data, with partitioning           |
| Concurrency           | Limited concurrency                                 | High concurrency supported                          | High concurrency, distributed              |
| Query Optimization    | Limited advanced optimization                       | Materialized views, indexes                         | Distributed query optimization             |
| Transactional Support | No ACID support                                     | Full transactional support                          | Delta Lake provides ACID support          |
| ETL/Transformations   | Limited                                             | Moderate                                            | Advanced ETL & machine learning           |




## Author
**Sujeet Nayak** 
Data Engineering
