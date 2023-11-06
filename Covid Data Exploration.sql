
-- show all the data from coviddeaths table
SELECT * FROM coviddeaths;

-- show all the data from covidvaccination table
select * from covidvaccination;


-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From covidanalysis.coviddeaths
Where location like '%states%'
and continent is not null 


-- Shows what percentage of population infected with Covid in your country
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From covidanalysis.coviddeaths
Where location like '%states%'

-- Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From covidanalysis.coviddeaths
Group by Location, Population
order by PercentPopulationInfected desc
limit 5;

-- Countries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From covidanalysis.coviddeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc


-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From covidanalysis.coviddeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

select * from covidanalysis.coviddeaths as dea
join covidanalysis.covidvaccination as vac
on dea.location = vac.location
and dea.date = vac.date


-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, ReceivedVaccination)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--
)
Select *, (ReceivedVaccination/Population)*100
From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
ReceivedVaccination numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
--, (ReceivedVaccination/population)*100
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
    where dea.continent is not null 

Select *, (ReceivedVaccination/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
--, (ReceivedVaccination/population)*100
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From covidanalysis.coviddeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
--, (ReceivedVaccination/population)*100
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, ReceivedVaccination)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
--, (ReceivedVaccination/population)*100
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--
)
Select *, (ReceivedVaccination/Population)*100
From PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
ReceivedVaccination numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
--, (ReceivedVaccination/population)*100
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--

Select *, (ReceivedVaccination/Population)*100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as ReceivedVaccination
From covidanalysis.coviddeaths dea
Join covidanalysis.covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 