/*

Covid19 Project Queries for Tableau Visualization

*/

--1 (Total Covid19 Cases, Total Covid19 Deaths, Total Covid19 Death Percentage in Nigeria where there is no NULL values in Continent)

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS BIGINT)) AS total_deaths, SUM(CAST(new_deaths AS BIGINT))/SUM(new_cases)*100 AS Death_Percentage
FROM Covid19PortfolioProject..Covid_Deaths_Info
WHERE location LIKE '%Nigeria' AND continent IS NOT NULL
ORDER BY 1,2

--2 (Here we are looking at where the Continents are NULL and the locations are are not in World, European Union, International or the income levels(all these aren't continents)) in Desending Order)

SELECT location, SUM(CAST(new_deaths AS BIGINT)) AS Total_Death_count
FROM Covid19PortfolioProject..Covid_Deaths_Info
WHERE continent IS NULL AND location NOT IN ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
GROUP BY location
ORDER BY Total_Death_count DESC


--3 (This showes the highest number of infection and the percentage of the population infected. Example if i check for Nigeria (which i have commented out) it shows me the total population of Nigeria and gives me the highest count of infection and then the percentage of the population infected)

SELECT location, population, MAX(total_cases) AS Highest_infection_count, MAX((total_cases/population))*100 AS Percentage_Polulation_infected
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
GROUP BY location, population
ORDER BY Percentage_Polulation_infected DESC

--4(This shows the highest count of infection and also the percentage of people infected by location and date)

SELECT location, population, date, MAX(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS Percent_Poplulation_Infected
FROM Covid19PortfolioProject..Covid_Deaths_Info
--WHERE location LIKE '%Nigeria%'
GROUP BY location, population, date
ORDER BY Percent_Poplulation_Infected DESC