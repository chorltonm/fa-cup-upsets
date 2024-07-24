CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_league_ranking_sorted` AS
WITH league_teams AS 

(

SELECT DISTINCT

season_year,
league_id,
team_id,
1 AS team_count

FROM preparation_layer.league_ranking

ORDER BY season_year, league_id, team_id ASC

), number_teams AS

(

SELECT

season_year,
league_id,
SUM(team_count) AS number_of_teams

FROM league_teams

GROUP BY

season_year,
league_id 

ORDER BY season_year, league_id ASC

)


SELECT 

lr.season_year, 
lr.league_id, 
lr.league_name, 
lr.league_level, 
lr.season_id, 
lr.season_name, 
lr.match_day, 
lr.match_round, 
lr.match_flag,
lr.match_team_points,
lr.position, 
lr.team_id, 
lr.team_name, 
lr.played, 
lr.won,
lr.lost, 
lr.drawn,
lr.goals_for, 
lr.goal_against, 
lr.goal_difference, 
lr.points, 
lr.form_home,
lr.form_away, 
lr.form_home_and_away,
CASE 
WHEN position BETWEEN number_of_teams - 6 AND number_of_teams THEN 0
WHEN position BETWEEN 1 AND 6 THEN 0 ELSE 1 END AS promotion_relegation



FROM preparation_layer.league_ranking lr

LEFT JOIN number_teams nt ON lr.season_year = nt.season_year AND  lr.league_id = nt.league_id

--WHERE league_id = 166

ORDER BY lr.season_year ASC, played ASC, league_level DESC, position ASC
