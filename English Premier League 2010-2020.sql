Select * from PortfolioProjects..PremierLeague

Select * from PortfolioProjects.dbo.EplGoalsData


Drop Table if exists #eplstats

Create Table #Eplstats(
 
Position int,

Club varchar(50),Matches int, 

Wins int,Draws int,

Losses int,GoalsScored int,

GoalsConceded int,

Points int)


-- Inserting Data into our temporary table created from our PremierLeague Table
insert into #Eplstats

Select Position, club, Matches, wins,draws,losses, goalsscored, goalsconceded, Points from PortfolioProjects.dbo.PremierLeague

--Clubs with MostPoints from 2010-2020
Select Club, SUM(Points) as MostPoints from #Eplstats
group by club 
order by MostPoints desc;

--
--Win Percentage, Loss Percentage and Draw Percenage
WITH LeagueStat as (
   select club ,SUM(wins)/SUM(matches)*100 as WinPercentage, SUM(losses)/SUM(matches)*100 as LossPercentage ,SUM(Draws)/SUM(matches)*100 as DrawPercentage
   
   from PortfolioProjects.dbo.PremierLeague
   Group by Club)
   
   Select * from LeagueStat


--Goals Conceded Per Match and Goals Scored Per Match for Each Team 

Select PlGoals.Club, (SUM(PlStats.GoalsScored)/SUM(PlStats.Matches)) as ScoredPerMatch, (SUM(PlStats.GoalsConceded)/SUM(PlStats.Matches)) as ConcededPerMatch

from PortfolioProjects.dbo.PremierLeague as PlStats

INNER JOIN PortfolioProjects..EplGoalsData as PlGoals
        
		ON PlStats.Club = PlGoals.Club
    
	Group by PlGoals.Club
	
	Order by ScoredPerMatch desc, ConcededPerMatch desc


--Comparing the Concession rate to the Scoring rate for the Big Six Teams

Select PlGoals.Club, (SUM(PlStats.GoalsScored)/SUM(PlStats.Matches)) as ScoredPerMatch, (SUM(PlStats.GoalsConceded)/SUM(PlStats.Matches)) as ConcededPerMatch


from PortfolioProjects.dbo.PremierLeague as PlStats


INNER JOIN PortfolioProjects..EplGoalsData as PlGoals
        
		ON PlStats.Club = PlGoals.Club
   
   WHERE PlStats.Club IN('man utd','man city', 'liverpool', 'chelsea','Arsenal','Tottenham') 
	
	Group by PlGoals.Club
	Order by ScoredPerMatch desc, ConcededPerMatch desc



Drop Table if exists #MostGoalsConceded

Create Table #MostGoalsConceded(
 Position int,

Club varchar(50),Matches int, 

Wins int,Draws int,

Losses int,GoalsScored int,

GoalsConceded int,
Points int)

insert into #MostGoalsConceded

Select Position, club, Matches, wins,draws,losses, goalsscored, goalsconceded, Points from PortfolioProjects.dbo.PremierLeague

Select Club, SUM(GoalsConceded) as MostConceded, SUM(GoalsScored) as MostScored, AVG(goalsconceded) as AVGConceded, AVG(goalsscored) as AVGScored from #MostGoalsConceded
group by club 

order by MostConceded desc, MostScored desc,AVGConceded desc, AVGScored

insert into #MostGoalsConceded

Select Position, club, Matches, wins,draws,losses, goalsscored, goalsconceded, Points from PortfolioProjects.dbo.PremierLeague

Select Club, SUM(GoalsConceded) as MostConceded, SUM(GoalsScored) as MostScored, AVG(goalsconceded) as AVGConceded, AVG(goalsscored) as AVGScored from #MostGoalsConceded
 
 WHERE Club IN('man utd','man city', 'liverpool', 'chelsea','Arsenal','Tottenham')

group by club 

order by  MostScored desc,AVGConceded desc, AVGScored





