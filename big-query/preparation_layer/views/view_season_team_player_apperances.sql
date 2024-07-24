CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_season_team_player_apperances` AS

WITH player_appreances_home_away AS

(


SELECT 

vmtc.match_season_year,
vmtc.match_season_id,
vmtc.match_season_name,
vmtc.match_league_id,
vmtc.match_league_name,
vmtc.match_id,
vmtc.match_name,
lnps.lineup_id,
vmtc.match_home_team_id AS match_team_id,
vmtc.match_home_team_name AS match_team_name,
CAST(match_date AS DATE) AS match_date,
match_round_name,
lineup_home_away_flag,
lineup_player_id,
lineup_player_name, 
lineup_position,
lineup_substitute,
lineup_players_availability,
lineup_players_availability_reason,
apperance_count,
SUM(apperance_count) OVER (PARTITION BY match_season_id, match_home_team_name, lineup_player_id ORDER BY match_season_id, match_date) AS cumulative_home_away_apperances,

-- SELECT *
FROM preparation_layer.view_matches vmtc

LEFT JOIN preparation_layer.lineups lnps ON vmtc.match_lineups_id = lnps.lineup_id AND lineup_home_away_flag = 'home'

WHERE match_status_reason  IN ('Ended','AET','AP') AND lineup_players_availability_reason = 'selected' --AND lineup_player_id = 19472

UNION ALL

-- away

SELECT 

vmtc.match_season_year,
vmtc.match_season_id,
vmtc.match_season_name,
vmtc.match_league_id,
vmtc.match_league_name,
vmtc.match_id,
vmtc.match_name,
lnps.lineup_id,
vmtc.match_away_team_id AS match_team_id,
vmtc.match_away_team_name AS match_team_name,
CAST(match_date AS DATE) AS match_date,
match_round_name,
lineup_home_away_flag,
lineup_player_id,
lineup_player_name, 
lineup_position,
lineup_substitute,
lineup_players_availability,
lineup_players_availability_reason,
apperance_count,
SUM(apperance_count) OVER (PARTITION BY match_season_id, match_away_team_name, lineup_player_id ORDER BY match_season_id, match_date) AS cumulative_home_away_apperances,

-- SELECT *
FROM preparation_layer.view_matches vmtc

LEFT JOIN preparation_layer.lineups lnps ON vmtc.match_lineups_id = lnps.lineup_id AND lineup_home_away_flag = 'away'

WHERE match_status_reason  IN ('Ended','AET','AP')  AND lineup_players_availability_reason = 'selected' --AND lineup_player_id = 19472

) 


SELECT

*,
SUM(apperance_count) OVER (PARTITION BY match_season_id, match_team_name, lineup_player_id ORDER BY match_season_id, match_date) AS cumulative_total_apperances,

FROM player_appreances_home_away

ORDER BY match_season_name, match_team_name, match_date ASC
