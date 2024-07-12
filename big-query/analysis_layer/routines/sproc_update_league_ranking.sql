CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.analysis_layer.sproc_update_league_ranking`()
BEGIN

TRUNCATE TABLE analysis_layer.league_ranking;

INSERT analysis_layer.league_ranking

SELECT 

match_season_year as season_year,
match_league_id as league_id,
match_league_name as league_name,
match_league_level AS league_level,
match_season_id as season_id,
match_season_name as season_name,
match_date AS match_day,
match_round,
ROW_NUMBER() OVER (PARTITION BY match_season_id,match_team_games_played 
                      ORDER BY cumulative_match_team_points DESC, cumulative_match_home_team_goal_diff DESC, cumulative_match_home_team_goals_for DESC, match_team_name ASC) AS position,
match_team_id AS team_id,
match_team_name AS team_name,
match_team_games_played AS played,
cumulative_match_team_won AS won ,
cumulative_match_team_draw AS drawn,
cumulative_match_team_lost AS lost,
cumulative_match_home_team_goals_for AS goals_for,
cumulative_match_home_team_goals_against AS goal_against,
cumulative_match_home_team_goal_diff AS goal_difference,
cumulative_match_team_points AS points,
form_match_points_last_5_home_games AS form_home,
form_match_points_last_5_home_games AS form_away,
form_match_points_last_5_home_and_away_both_games AS form_home_and_away

FROM `birkbeck-msc-project-422917.transform_layer.view_league_match_points`

ORDER BY match_season_year ASC, match_team_games_played ASC, match_league_level DESC, 
                  cumulative_match_team_points DESC, cumulative_match_home_team_goal_diff DESC, cumulative_match_home_team_goals_for DESC, match_team_name ASC
;

END;