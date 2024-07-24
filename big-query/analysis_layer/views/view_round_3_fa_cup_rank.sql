CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.analysis_layer.view_round_3_fa_cup_rank` AS

WITH round_3_dates AS

(
SELECT  

  vmtc.season_year,
  vmtc.match_league_id,
  vmtc.match_league_name,
  vmtc.match_round_name,
  MIN(vmtc.match_date) AS earliest_round_3_date

FROM `birkbeck-msc-project-422917.transform_layer.view_matches` vmtc

WHERE 

vmtc.match_league_name = 'FA Cup' AND vmtc.match_round_name = 'Round 3'AND vmtc.match_status_reason  IN ('Ended','AET','AP')

GROUP BY 

vmtc.season_year,
vmtc.match_league_id,
vmtc.match_league_name,
vmtc.match_round_name
), 

round_3_league AS

(
SELECT

vlr.season_year,
vlr.league_id,
vlr.league_name,
MAX(vlr.match_day) AS last_league_game_before_round_3,
MAX(vlr.played) AS games_played_before_round_3


FROM `analysis_layer.view_league_ranking_sorted` vlr

LEFT JOIN round_3_dates rd ON vlr.season_year = rd.season_year

WHERE vlr.match_day < rd.earliest_round_3_date

GROUP BY 

vlr.season_year,
vlr.league_id,
vlr.league_name


ORDER BY vlr.season_year ASC
) 

, team_round_3_league_position AS (

SELECT

vlr.season_year,
vlr.league_id,
vlr.league_name,
vlr.team_id,
vlr.team_name,
last_league_game_before_round_3,
games_played_before_round_3,
vlr.league_level,
vlr.position AS league_position,
vlr.played AS league_games_played,
vlr.form_home_and_away AS league_form_home_away,



FROM `analysis_layer.view_league_ranking_sorted` vlr

INNER JOIN round_3_league rdl ON vlr.season_year = rdl.season_year AND vlr.league_id = rdl.league_id AND vlr.played = rdl.games_played_before_round_3

ORDER BY vlr.season_year ASC, vlr.league_level ASC, vlr.position ASC

), fa_cup_teams AS (

SELECT 

vmtc.season_year,
hlp.league_id,
hlp.league_name,
match_home_team_id AS team_id,
match_home_team_name AS team_name,
IFNULL(hlp.league_level,6) AS league_level,
IFNULL(hlp.league_position,180) AS league_position

FROM transform_layer.view_matches vmtc

LEFT JOIN team_round_3_league_position hlp ON vmtc.season_year = hlp.season_year AND  vmtc.match_home_team_id = hlp.team_id

WHERE  vmtc.match_league_name = 'FA Cup' AND vmtc.match_round_name = 'Round 3'AND vmtc.match_status_reason  IN ('Ended','AET','AP')  -- Ended notmal time, AET after extra time, AP after penalties

AND vmtc.match_home_team_score_end <> vmtc.match_away_team_score_end

UNION ALL

SELECT 

vmtc.season_year,
alp.league_id,
alp.league_name,
match_away_team_id AS team_id,
match_away_team_name AS team_name,
IFNULL(alp.league_level,6) AS league_level,
IFNULL(alp.league_position,180) AS league_position

FROM transform_layer.view_matches vmtc

LEFT JOIN team_round_3_league_position alp ON vmtc.season_year = alp.season_year AND  vmtc.match_away_team_id = alp.team_id 

WHERE  vmtc.match_league_name = 'FA Cup' AND vmtc.match_round_name = 'Round 3'AND vmtc.match_status_reason  IN ('Ended','AET','AP')  -- Ended notmal time, AET after extra time, AP after penalties

AND vmtc.match_home_team_score_end <> vmtc.match_away_team_score_end

ORDER BY season_year ASC, league_level ASC, league_position ASC
)

SELECT

season_year,
league_id,
league_name,
team_id,
team_name,
league_level,
league_position,
ROW_NUMBER() OVER (PARTITION BY season_year ORDER BY league_level,league_position) AS round_3_fa_cup_rank

FROM fa_cup_teams
