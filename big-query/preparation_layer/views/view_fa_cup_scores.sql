CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_fa_cup_scores` AS

SELECT 

season_year,
match_id,
match_date,
home_team_round_3_position AS home_team_no,
match_home_team_name AS home_team_name,
home_team_league_level,
match_home_team_score_end AS home_team_score,
away_team_round_3_position AS away_team_no,
match_away_team_name AS away_team_name,
away_team_league_level,
match_away_team_score_end AS away_team_score,
CASE
WHEN match_home_team_score_end > match_away_team_score_end THEN home_team_round_3_position 
ELSE away_team_round_3_position END AS actual_winning_team_no,
CASE
WHEN match_home_team_score_end < match_away_team_score_end THEN home_team_round_3_position 
ELSE away_team_round_3_position END AS actual_losing_team_no,
CASE 
WHEN match_home_team_score_end > match_away_team_score_end THEN 1 ELSE 0 END AS home_win,
CASE 
WHEN match_home_team_score_end < match_away_team_score_end THEN 1 ELSE 0 END AS away_win,
round_3_upset_label AS actual_upset,
CASE 
WHEN home_team_round_3_position < away_team_round_3_position THEN home_team_round_3_position ELSE away_team_round_3_position END AS sort_order,
1 AS match_count

FROM `birkbeck-msc-project-422917.preparation_layer.view_round_3_fa_cup_matches` 


WHERE home_team_league_level <> away_team_league_level

