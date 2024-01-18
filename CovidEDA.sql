SELECT * FROM CovidDeaths


SELECT * FROM CovidVaccinations
ORDER BY 3,4

--Now Lets start the EDA
--Let us select the Data we are going to use 

select * from CovidDeaths
where continent is not null
order by 1,2

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2 

--1) Looking for the total cases vs the total Deaths 

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as PercentageDeathrate
from CovidDeaths
where location like 'Africa'
order by total_cases, total_deaths, PercentageDeathrate desc

--2) Looking at total cases vs population 

select location, date, total_cases,population, (total_cases/population)*100 as PercentageInfectedPopulation
from CovidDeaths
where location like 'Africa'
order by 1,2 

--3) Countries with Highest Infection Rate compared to Population

select location,population, MAX(total_cases)AS Highestinfectioncount, MAX(total_cases/population)*100 as PercentageInfectedPopulation
from CovidDeaths
--where location like 'Africa'
GROUP BY location, population
order by PercentageInfectedPopulation desc

--4) Countries with Highest Death Count per Population

select location, max(cast(total_deaths as int )) as totalDeathcount
from CovidDeaths
where continent is  null 
GROUP BY location
ORDER BY totalDeathcount desc



---For china only

select location, max(cast(total_deaths as int )) as totalDeathcount
from CovidDeaths
where continent is not null and location like 'china'
GROUP BY location
ORDER BY totalDeathcount desc

--5) BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

---continent with the highest number of death rate 

select continent, max(cast(total_deaths as int )) as totalDeathcount
from CovidDeaths
where continent is not null 
GROUP BY continent
ORDER BY totalDeathcount desc


-- GLOBAL NUMBERS

select SUM(new_cases) as totalcases, sum(cast(new_deaths as int )) as total_deaths,
sum(cast(new_deaths as int ))/SUM(new_cases)*100 as Deathpercentage
from CovidDeaths
where continent is not null

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent is not null and vac.new_vaccinations is not null
 order by 1,2,3


