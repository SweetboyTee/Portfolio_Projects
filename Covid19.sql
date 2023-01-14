SELECT *
FROM Covid19PortfolioProject..Covid_Deaths_Info
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM Covid19PortfolioProject..Covid_Vaccinations_Info
--ORDER BY 3,4

--Selecting data that we going to  be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Covid19PortfolioProject..Covid_Deaths_Info
ORDER BY 1,2

--Looking at total cases vs total deaths
--Shows the likelihood of dying if you contact Covid19 in Nigeria

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage 
FROM Covid19PortfolioProject..Covid_Deaths_Info
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2

--Looking at the total cases vs population
--This shows the percentage of polulation that got infected

SELECT Location, date, total_cases, total_deaths, population, (total_cases/population)*100 AS percentage_Infected 
FROM Covid19PortfolioProject..Covid_Deaths_Info
WHERE location LIKE '%Nigeria%'
ORDER BY 1,2

--Looking at countries with highest infection rate comared to population

SELECT Location, population, MAX(total_cases) AS Highest_Infection, MAX((total_cases/population))*100 AS percentage_of_Infected_population
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
GROUP BY location, population
ORDER BY percentage_of_Infected_population DESC

--this is showing the countrieswith the highest death count

SELECT Location, MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_deaths_count DESC

---Let's break it by continent

SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths_count DESC

--Showing the continent with the higest death count

SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_deaths_count
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_deaths_count DESC

--Global numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS Death_Percentage
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--joining the covid19 deaths table and the vaccination table together

SELECT *
FROM Covid19PortfolioProject..Covid_Deaths_Info AS cd
JOIN Covid19PortfolioProject..Covid_Vaccinations_Info AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date

--looking at total population VS vaccinaions

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated--, (rolling_people_vaccinated/population)*100
FROM Covid19PortfolioProject..Covid_Deaths_Info AS cd
JOIN Covid19PortfolioProject..Covid_Vaccinations_Info AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

--Using a CTE

WITH PopulationvsVaccination (continent, location, date,population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated--, (rolling_people_vaccinated/population)*100
FROM Covid19PortfolioProject..Covid_Deaths_Info AS cd
JOIN Covid19PortfolioProject..Covid_Vaccinations_Info AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *,(rolling_people_vaccinated/population)*100 AS percentage_Vaccination
FROM PopulationvsVaccination

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_Vaccinations numeric,
rolling_people_vaccinated numeric
)



INSERT INTO #PercentPopulationVaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated--, (rolling_people_vaccinated/population)*100
FROM Covid19PortfolioProject..Covid_Deaths_Info AS cd
JOIN Covid19PortfolioProject..Covid_Vaccinations_Info AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY 2,3

SELECT *,(rolling_people_vaccinated/population)*100 AS percentage_Vaccination
FROM #PercentPopulationVaccinated


--Creating view to stor data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, SUM(CAST(cv.new_vaccinations AS BIGINT)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS rolling_people_vaccinated--, (rolling_people_vaccinated/population)*100
FROM Covid19PortfolioProject..Covid_Deaths_Info AS cd
JOIN Covid19PortfolioProject..Covid_Vaccinations_Info AS cv
	ON cd.location = cv.location
	AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated