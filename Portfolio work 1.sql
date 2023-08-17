Select *
from Portfolio..[Covid Deaths]
where continent is not null 
order by 3,4

--Select *
--from Portfolio..[Covid Vacanations]
--order by 3,4

-- Select data that we are going to use

select location,date,total_cases,new_cases,total_deaths,population
from Portfolio..[Covid Deaths]
where continent is not null 
order by 1,2

--Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contact covid in your country

select location,date,total_cases,total_deaths,(cast(total_deaths as numeric))/cast (total_cases as numeric)*100 as DeathPercentage
from Portfolio..[Covid Deaths]
where location like '%kingdom%'
and continent is not null 
order by 1,2

-- Looking at Total Cases Vs Population
-- Shows what Percentage of population got covid 

select location,date,total_cases,population, (cast(total_cases as numeric))/cast (population as numeric)*100 as DeathPercentage
from Portfolio..[Covid Deaths]
Where location like '%Kingdom%'
where continent is not null 
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

select location,population, MAX(total_cases) as HighestInfectionCount, max(cast(total_cases as numeric))/cast(population as numeric)*100 as PercentPopulationInfectecd
from Portfolio..[Covid Deaths]
group by Location,Population
where continent is not null 
order by PercentPopulationInfectecd

-- Showing Countries with Highest Death Count per Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..[Covid Deaths]
where continent is not null 
group by Location 
order by TotalDeathCount desc

--BREAK THINGS DOWN BY CONTINENT



-- Showing The Continents with Highest Death Counts'

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolio..[Covid Deaths]
where continent is null 
group by Location 
order by TotalDeathCount desc


-- Global Numbers

select sum(cast(new_cases as numeric))as total_cases,sum(cast(new_deaths as numeric)) as total_deaths,sum(cast(new_deaths as numeric))/sum(cast(new_cases as numeric ))*100 as DeathPercentage
from Portfolio..[Covid Deaths]
--where location like '%kingdom%
where continent is not null 
--group by date 
order by 1,2


-- Looking at Total population vs Vaccinations

with PopsVac (Continent, Location , Date ,Population, New_Vaccinations ,RollingPeopleVaccinated)

as 
(


select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert( bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
dea.date) 

as RollingPeopleVaccinated

from Portfolio..[Covid Deaths] dea
join Portfolio..[Covid Vacanations] vac
on  dea.location =vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
from PopsVac

-- Use CTE used above


-- Temp Table

create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert( bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
dea.date) 

as RollingPeopleVaccinated

from Portfolio..[Covid Deaths] dea
join Portfolio..[Covid Vacanations] vac
on dea.location = vac.location
and dea.date = vac.date

Select *,(RollingPeopleVaccinated/Population)*100

from #PercentPopulationVaccinated

-- Creating view to store data for visualistion

Create View PercentPopulationVaccinated as 

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
sum(convert( bigint,vac.new_vaccinations )) over (partition by dea.location order by dea.location,
dea.date) 

as RollingPeopleVaccinated

from Portfolio..[Covid Deaths] dea
join Portfolio..[Covid Vacanations] vac
on dea.location = vac.location
and dea.date = vac.date

where dea.continent is not null
--order by 2,3




