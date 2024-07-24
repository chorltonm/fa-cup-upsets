CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_fa_cup_lineup_strength` AS

WITH fa_cup_3rd_round_lineups

AS

(

SELECT

match_season_year,
match_season_id, 
match_season_name,
match_league_id, 
match_league_name,
match_id,
match_name,
lineup_id AS match_lineups_id,
match_team_id,
match_team_name,
match_date,
match_round_name,
lineup_player_id,
lineup_player_name,
lineup_position,
cumulative_total_apperances

FROM preparation_layer.view_season_team_player_apperances facup

WHERE facup.match_league_name = 'FA Cup' AND facup.match_round_name = 'Round 3' 

ORDER BY match_date, match_id, match_team_name ASC

), round_3_dates AS

(
SELECT  

  vmtc.season_year,
  vmtc.match_league_id,
  vmtc.match_league_name,
  vmtc.match_round_name,
  MIN(vmtc.match_date) AS earliest_round_3_date

FROM preparation_layer.view_matches vmtc

WHERE 

vmtc.match_league_name = 'FA Cup' AND vmtc.match_round_name = 'Round 3'AND vmtc.match_status_reason  IN ('Ended','AET','AP')

GROUP BY 

vmtc.season_year,
vmtc.match_league_id,
vmtc.match_league_name,
vmtc.match_round_name

), round_3_league AS

(

SELECT

vlr.season_year,
vlr.league_id,
vlr.league_name,
vlr.team_id,
vlr.team_name,
rd.earliest_round_3_date,
MAX(vlr.match_day) AS last_league_game_before_round_3,
MAX(vlr.played) AS games_played_before_round_3


FROM `preparation_layer.view_league_ranking_sorted` vlr

LEFT JOIN round_3_dates rd ON vlr.season_year = rd.season_year

WHERE vlr.match_day <= rd.earliest_round_3_date

GROUP BY 

vlr.season_year,
vlr.league_id,
vlr.league_name,
vlr.team_id,
vlr.team_name,
rd.earliest_round_3_date


ORDER BY vlr.season_year ASC

), round_3_league_apperances AS

(
SELECT

match_season_year,
match_team_id,
match_team_name,
match_date,
lineup_player_id,
lineup_player_name,
lineup_position,
cumulative_total_apperances,
games_played_before_round_3


FROM preparation_layer.view_season_team_player_apperances lgeapps

INNER JOIN round_3_league rnd ON lgeapps.match_season_year = rnd.season_year AND lgeapps.match_team_id = rnd.team_id AND lgeapps.match_date = rnd.last_league_game_before_round_3

WHERE lgeapps.match_league_name <> 'FA Cup'

ORDER BY match_date, match_id, match_team_name ASC

), fa_cup_lineups_apperances AS

(
SELECT

r3lnps.match_season_id, 
r3lnps.match_season_name,
r3lnps.match_league_id, 
r3lnps.match_league_name,
r3lnps.match_id,
r3lnps.match_name,
r3lnps.match_lineups_id,
r3lnps.match_team_id,
r3lnps.match_team_name,
r3lnps.match_date,
r3lnps.match_round_name,
r3lnps.lineup_player_id,
r3lnps.lineup_player_name,
r3lnps.lineup_position,
r3lgapps.cumulative_total_apperances,
r3lgapps.games_played_before_round_3

FROM fa_cup_3rd_round_lineups r3lnps

LEFT JOIN round_3_league_apperances r3lgapps ON r3lnps.lineup_player_id = r3lgapps.lineup_player_id AND r3lnps.match_season_year = r3lgapps.match_season_year

)

SELECT

match_season_id, 
match_season_name,
match_league_id, 
match_league_name,
match_id,
match_name,
match_team_id,
match_team_name,
match_date,
match_round_name,
SUM(cumulative_total_apperances) AS totla_appearances,
SUM(games_played_before_round_3) AS total_games,
SUM(cumulative_total_apperances) / SUM(games_played_before_round_3) as lineup_strength

FROM fa_cup_lineups_apperances

GROUP BY

match_season_id, 
match_season_name,
match_league_id, 
match_league_name,
match_id,
match_name,
match_team_id,
match_team_name,
match_date,
match_round_name
