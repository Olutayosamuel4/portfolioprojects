select * 
from portfolioproject..CovidDeaths 
where continent is not null
order by 3,4

--select * 
--from portfolioproject..covidvacination
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..CovidDeaths 
order by 1,2

--Total cases vs Total deaths
--Shows likelihood of not surving if you contract covid in UK

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from portfolioproject..CovidDeaths 
where location like '%kingdom%'
order by 1,2

--looking at the total cases vs population

select location, date, population, total_cases, (total_cases/population)*100 as percentpopulationInfected
from portfolioproject..CovidDeaths 
--where location like '%kingdom%'
order by 1,2

--coutries with highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as percentpopulationinfected
from portfolioproject..CovidDeaths 
--where location like '%kingdom%'
group by location, population 
order by percentpopulationinfected desc


--coutries with highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths 
where continent is not null
group by location 
order by TotalDeathCount desc

-- break things down by continent

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths 
where continent is not null
group by continent  
order by TotalDeathCount desc


--showing the continent with the highhest death count per population


select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from portfolioproject..CovidDeaths 
where continent is not null
group by continent  
order by TotalDeathCount desc




--global numbers


select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from portfolioproject..CovidDeaths 
--where location like '%kingdom%'
where continent is not null
group by date
order by 1,2


select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
from portfolioproject..CovidDeaths 
--where location like '%kingdom%'
where continent is not null
--group by date
order by 1,2

--total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths dea 
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent  is not null
  order by 1,2 


-- USE CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths dea 
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
   where dea.continent  is not null
  --order by 1,2 
  )
  select *, (RollingPeopleVaccinated/population)*100
  from PopvsVac


  --Temp Table

  drop table if exists #PercentPopulationVaccinated
  create table #PercentPopulationVaccinated
  (
  continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  RollingPeopleVaccinated numeric
  )

  insert into #PercentPopulationVaccinated 
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths dea 
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent  is not null
  order by 3,4
  
  select *, (RollingPeopleVaccinated/population)*100
  from #PercentPopulationVaccinated  


  --creating view to store data for visualizations

create view percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date ) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from portfolioproject..CovidDeaths dea 
join portfolioproject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
 where dea.continent  is not null
  --order by 3,4

  select *
  from PercentPopulationVaccinated 












