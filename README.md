# Startup Funding Analysis

## Description
This repository contains an analysis of startup funding data. The analysis includes data cleaning, processing, and visualizations to explore various aspects of the startup ecosystem, such as industry verticals, investment types, and city-wise funding distributions.

## Dataset
The dataset used in this analysis is loaded from an Excel file (`startup_funding.xlsx`). It includes information about startup funding rounds, investors, cities, industries, and more.

## Visualizations
The analysis includes the following visualizations:

1. **Number of Startups Funded by Year**:
   - A bar chart showing the number of startups funded each year.
   
2. **Distribution of Startups by Industry Vertical**:
   - A bar chart showing the distribution of startups across different industry verticals after compacting categories into meaningful groups.
   
3. **Distribution of Investment Types**:
   - A bar chart showing the distribution of different investment types, such as Seed Funding, Series A, Debt Funding, etc.
   
4. **Top 10 Investors by Number of Investments**:
   - A pie chart representing the top 10 investors based on the number of investments made.
   
5. **Total Funding by City**:
   - A horizontal bar chart showing the total amount of funding received by startups in different cities.
   
6. **Top 10 Cities by Total Funding**:
   - A vertical bar chart showing the top 10 cities by total funding with the funding amounts displayed on top of the bars.

## Prerequisites
- R (version 4.0 or higher)
- RStudio (optional)
- The following R libraries:
  - `readxl`
  - `dplyr`
  - `ggplot2`
  - `tidyr`
  - `stringr`

## Files in the Repository
- `analysis.R`: The main R script containing all the code for data processing and visualization.
- `startup_funding.xlsx`: The dataset used for analysis (make sure to include this file in your local setup).
- `README.md`: This file, providing instructions and details about the project.
