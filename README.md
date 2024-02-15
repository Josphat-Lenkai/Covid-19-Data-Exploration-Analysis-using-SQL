# Covid-19-Data-Exploration-Analysis-using-SQL

# Data Analysis Project: COVID-19 Insights

## Introduction
The Covid-19 Data Exploration and Analysis project aims to gain valuable insights into the impact of the pandemic by utilizing SQL queries on Covid-19 datasets. The analysis focuses on key metrics such as total cases, deaths, population, and vaccination rates. Through a series of SQL queries, this project explores patterns, trends, and variations in Covid-19 data, providing a comprehensive overview of the global situation and specific regional dynamics.

## Overview
This project involves exploratory data analysis (EDA) on COVID-19 data, focusing on various aspects such as total cases, deaths, population, and vaccination rates. The SQL queries below analyze the dataset, providing insights into different metrics related to the pandemic.

## SQL Code Explanation

### Initial Data Exploration

```sql
-- View all columns in the CovidDeaths table
SELECT * FROM CovidDeaths;

-- View all columns in the CovidVaccinations table, ordered by columns 3 and 4
SELECT * FROM CovidVaccinations
ORDER BY 3, 4;
```

### Exploratory Data Analysis (EDA)

```sql
-- Select data with non-null continents, ordered by columns 1 and 2
SELECT * FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Select specific columns for analysis, ordered by location and date
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1, 2;
```
### Analysis Queries

1) Total cases vs total deaths, calculating death rate percentage for Africa
```sql
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS PercentageDeathrate
FROM CovidDeaths
WHERE location LIKE 'Africa'
ORDER BY total_cases, total_deaths, PercentageDeathrate DESC;
```
3) Total cases vs population, calculating infected population percentage for Africa
```sql
SELECT location, date, total_cases, population, (total_cases / population) * 100 AS PercentageInfectedPopulation
FROM CovidDeaths
WHERE location LIKE 'Africa'
ORDER BY 1, 2;
```

4) Countries with the highest infection rate compared to population
```sql
SELECT location, population, MAX(total_cases) AS Highestinfectioncount, MAX(total_cases / population) * 100 AS PercentageInfectedPopulation
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentageInfectedPopulation DESC;
```
6) Countries with the highest death count per population
```sql
SELECT location, MAX(CAST(total_deaths AS INT)) AS totalDeathcount
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY totalDeathcount DESC;
```

-- For China only
```sql
SELECT location, MAX(CAST(total_deaths AS INT)) AS totalDeathcount
FROM CovidDeaths
WHERE continent IS NOT NULL AND location LIKE 'China'
GROUP BY location
ORDER BY totalDeathcount DESC;
```
5) Breaking things down by continent
```sql
Continent with the highest death count per population
SELECT continent, MAX(CAST(total_deaths AS INT)) AS totalDeathcount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY totalDeathcount DESC;
```
### Global Numbers
Computed total global cases, deaths, and death percentage, offering a comprehensive overview of the overall impact of Covid-19 on a global scale.
```sql
Total global cases, deaths, and death percentage
SELECT SUM(new_cases) AS totalcases, SUM(CAST(new_deaths AS INT)) AS total_deaths,
SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS Deathpercentage
FROM CovidDeaths
WHERE continent IS NOT NULL;
```
### Total Population vs Vaccinations
Explored the percentage of the population that has received at least one Covid vaccine, highlighting the progress and coverage of vaccination efforts.
```sql
Shows the percentage of the population that has received at least one Covid vaccine
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND vac.new_vaccinations IS NOT NULL
ORDER BY 1, 2, 3;
```
# Conclusion

The Covid-19 Data Exploration and Analysis project, through SQL queries, has provided a thorough examination of various aspects of the pandemic. From regional disparities to global trends, the findings offer valuable insights for public health officials, researchers, and policymakers. The project not only facilitates a better understanding of the current state of affairs but also serves as a foundation for ongoing research and decision-making in the ongoing battle against the Covid-19 pandemic.
