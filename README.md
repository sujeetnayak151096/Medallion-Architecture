# Medallion Architecture Project: Tokyo Olympics 2021 Medal Tally Analysis

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
- Raw CSV files are ingested into Azure Data Lake Storage (ADLS) Gen 2.
- Data is stored in its raw, unprocessed form.

### 2. Silver Layer (Data Cleansing and Transformation)
- Data is cleaned, validated, and transformed:
  - Renamed columns
  - Checked for null and duplicate values
- External tables are created using Azure Synapse Analytics.

### 3. Gold Layer (Curated Data for Visualization)
- Cleaned and transformed data is stored here.
- Duplicate records are removed using CETAS (Create External Table As Select).
- Data is ready for visualization in Power BI.

## Power BI Dashboards

### Dashboard 1: General Overview
- Total medal counts (Gold, Silver, Bronze).
- Participation metrics: athletes, countries, and disciplines.
- Top countries by medals.
- Gender distribution and geographic representation.

### Dashboard 2: Detailed Analysis
- Number of coaches and athlete distribution by country.
- Gender breakdown per discipline.
- Medal distribution by country and discipline.

## Tools and Technologies
- **Azure Synapse Analytics**: Data ingestion, cleansing, and storage.
- **Azure Data Lake Storage Gen 2**: Data storage.
- **Power BI**: Data visualization and reporting.

## Error Handling
### Common Issues Encountered
1. **Incorrect Data Types**: Fixed by changing column types (e.g., nvarchar to int).
2. **External Table Creation Failures**: Resolved by verifying data source and file format configurations.

## Conclusion
The Medallion Architecture effectively processes and visualizes data, showcasing its utility for large-scale analytics projects. Power BI dashboards provide interactive and insightful visualizations of the Tokyo Olympics 2021 data.

## Author
**Sujeet Nayak** 
Data Engineering
Sent from my iPhone
