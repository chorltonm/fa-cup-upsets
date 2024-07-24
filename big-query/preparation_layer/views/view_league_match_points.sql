CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_league_match_points` AS

WITH home_away_matches AS

(
SELECT 

match_league_id, 
match_league_name,
match_league_level,
match_season_id, 
match_season_name,
match_season_year,
match_id,
match_name,
CAST(FORMAT_DATETIME('%Y-%m-%d', match_start_time) AS DATE) AS match_date,
match_round_round,
match_final_score,
match_count,
'home' AS match_flag,
match_home_team_id AS match_team_id, 
match_home_team_name AS match_team_name ,
match_home_team_outcome AS match_team_outcome,
match_home_team_win AS match_team_win,
match_home_team_draw AS match_team_draw,
match_home_team_loss AS match_team_loss,
match_home_team_points AS match_team_points,
match_home_team_goals_for AS match_team_goals_for,
match_home_team_goals_against AS match_team_goals_against,
match_home_teams_goal_diff AS match_teams_goal_diff,
SUM(CAST(match_home_team_points AS INT64)) OVER (PARTITION BY match_season_id, match_home_team_id ORDER BY match_season_id, match_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS form_match_points_last_5_home_games,
0 AS form_match_points_last_5_away_games,


FROM preparation_layer.view_matches vmtc

WHERE vmtc.match_league_name <> 'FA Cup' AND match_status_reason  IN ('Ended') 

UNION ALL

SELECT 

match_league_id, 
match_league_name,
match_league_level,
match_season_id, 
match_season_name,
match_season_year,
match_id,
match_name,
CAST(FORMAT_DATETIME('%Y-%m-%d', match_start_time) AS DATE) AS match_date,
match_round_round,
match_final_score,
match_count,
'away' AS match_flag,
match_away_team_id AS match_team_id, 
match_away_team_name AS match_team_name ,
match_away_team_outcome AS match_team_outcome,
match_away_team_win AS match_team_win,
match_away_team_draw AS match_team_draw,
match_away_team_loss AS match_team_loss,
match_away_team_points AS match_team_points,
match_away_team_goals_for AS match_team_goals_for,
match_away_team_goals_against AS match_team_goals_against,
match_away_teams_goal_diff AS match_teams_goal_diff,
0 AS form_match_points_last_5_home_games,
SUM(CAST(match_away_team_points AS INT64)) OVER (PARTITION BY match_season_id, match_away_team_id ORDER BY match_season_id, match_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS form_match_points_last_5_away_games


FROM preparation_layer.view_matches vmtc

WHERE vmtc.match_league_name <> 'FA Cup' AND match_status_reason  IN ('Ended') 

)

SELECT 

match_league_id, 
match_league_name,
match_league_level,
match_season_id, 
match_season_name,
match_season_year,
match_id,
match_name,
match_date,
match_round_round AS match_round,
match_final_score,
match_count,
SUM(CAST(match_count AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id,match_date) AS match_team_games_played,
match_flag,
match_team_id, 
match_team_name ,
match_team_outcome,
match_team_win,
SUM(CAST(match_team_win AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id, match_date) AS cumulative_match_team_won,
match_team_draw,
SUM(CAST(match_team_draw AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id, match_date) AS cumulative_match_team_draw,
match_team_loss,
SUM(CAST(match_team_loss AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id, match_date) AS cumulative_match_team_lost,
match_team_points,
SUM(CAST(match_team_points AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id, match_date) AS cumulative_match_team_points,
match_team_goals_for,
SUM(CAST(match_team_goals_for AS INT64)) OVER (PARTITION BY match_season_id, match_team_id  ORDER BY match_season_id, match_date) AS cumulative_match_home_team_goals_for,
match_team_goals_against,
SUM(CAST(match_team_goals_against AS INT64)) OVER (PARTITION BY match_season_id, match_team_id  ORDER BY match_season_id, match_date) AS cumulative_match_home_team_goals_against,
match_teams_goal_diff,
SUM(CAST(match_teams_goal_diff AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id, match_date) AS cumulative_match_home_team_goal_diff,
form_match_points_last_5_home_games,
form_match_points_last_5_away_games,
SUM(CAST(match_team_points AS INT64)) OVER (PARTITION BY match_season_id, match_team_id ORDER BY match_season_id, match_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS form_match_points_last_5_home_and_away_both_games

FROM home_away_matches

ORDER BY match_league_name, match_season_name, match_date, match_team_name
