Select *
From PortfolioProject..CovidDeaths1
Where Continent is NOT NULL
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select data that we are using

Select  location, date ,total_cases, new_cases,total_deaths,population
From PortfolioProject..CovidDeaths1
Where Continent is NOT NULL
Order by 1,2

--Looking at Total Cases Vs Total Deaths

Select  location, date ,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths1
Where Location like '%India%'
Order by 1,2

--Looking at Total Cases Vs the population
--Shows what percentage of population got covid

Select  Location, date ,Population,total_cases, (total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths1
--Where Location like '%India%'
Order by 1,2


Select  Location , Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 
as PercentPopulationInfected
From PortfolioProject..CovidDeaths1
--Where Location like '%India%'
Group by Location , Population
Order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
Select  Location , MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths1
--Where Location like '%India%'
Where Continent is NOT NULL
Group by Location , Population
Order by  TotalDeathCount desc

-- BREAK THINGS DOWN BY CONTINENT

--Showing continents with the highest death count per population
Select  Continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths1
--Where Location like '%India%'
Where Continent is not null
Group by Continent 
Order by  TotalDeathCount desc 

--GLOBAL NUMBERS
Select SUM(new_cases) as total_cases ,SUM(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths1
--Where Location like '%India%'
where continent is not null
--Group by date
Order by 1,2


--Looking at Total Population vs Vaccinations
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths1 dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3

--use CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths1 dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location  nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)




Insert into  #PercentPopulationVaccinated



Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
 SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths1 dea
Join PortfolioProject..CovidVaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

Select * 
from PercentPopulationVaccinated