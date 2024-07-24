CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_matches` AS
SELECT

  season_year,
  match_id,
  match_name,
  match_status_reason,
  match_league_id,
  match_league_name,
  match_lineups_id,
  match_home_team_id + match_away_team_id AS match_rivalry_id,
  vlges.league_level AS match_league_level,
  vlges.league_higher_leagues_league_level AS match_league_higher_level,
  vlges.league_lower_leagues_league_level AS match_league_lower_level,
  match_season_id,
  match_season_name,
  sea.season_year AS match_season_year,
  match_round_name,
  match_round_round,
  match_start_time,
  FORMAT_TIME("%R",EXTRACT(TIME FROM  match_start_time )) AS match_1st_half_kick_off,
  FORMAT_TIME("%R",EXTRACT(TIME FROM (DATETIME_ADD(match_start_time, INTERVAL 60 MINUTE)))) AS match_2nd_half_kick_off,
  CAST(FORMAT_DATETIME('%Y-%m-%d', match_start_time) AS DATE) AS match_date,
  1 as match_count,
  match_duration,
  IFNULL(mtc.match_arena_id, arnt.arena_id) AS match_arena_id,
  IFNULL(arnm.arena_name, arnt.arena_name) AS arena_name,
  IFNULL(arnm.arena_stadium_capacity,arnt.arena_stadium_capacity) AS arena_stadium_capacity,
  IFNULL(arnm.arena_geolocation_latitude,arnt.arena_geolocation_latitude) AS match_latitude,
  IFNULL(arnm.arena_geolocation_longitude,arnt.arena_geolocation_longitude) AS match_longitude,
  match_attendance,
  CONCAT(CAST(match_home_team_score_current AS STRING),'-', CAST(match_away_team_score_current AS STRING)) AS match_final_score,
  match_home_team_id,
  match_home_team_name,
  CASE 
  WHEN IFNULL(match_home_team_score_current,0) + IFNULL(match_home_team_score_penalties,0)  > IFNULL(match_away_team_score_current,0) + IFNULL(match_away_team_score_penalties,0) THEN 'WIN' 
  WHEN IFNULL(match_home_team_score_current,0) + IFNULL(match_home_team_score_penalties,0)  = IFNULL(match_away_team_score_current,0) + IFNULL(match_away_team_score_penalties,0)THEN 'DRAW' ELSE 'LOSS' 
  END AS match_home_team_outcome,
  CASE 
  WHEN match_league_name = 'FA Cup' AND match_status_reason = 'AP'THEN IFNULL(match_home_team_score_current,0) + IFNULL 
  (match_home_team_score_penalties,0) ELSE IFNULL(match_home_team_score_current,0) END AS match_home_team_score_end,
  CASE 
  WHEN match_home_team_score_current > match_away_team_score_current THEN 1 ELSE 0 END AS match_home_team_win,
  CASE 
  WHEN match_home_team_score_current = match_away_team_score_current THEN 1 ELSE 0 END AS match_home_team_draw,
  CASE 
  WHEN match_home_team_score_current < match_away_team_score_current THEN 1 ELSE 0 END AS match_home_team_loss,  
  CASE
  WHEN mtc.match_league_name = 'FA Cup' THEN -1
  WHEN match_home_team_score_current > match_away_team_score_current THEN 3
  WHEN match_home_team_score_current = match_away_team_score_current THEN 1 ELSE 0 END AS match_home_team_points,
  IFNULL(match_home_team_score_current,0) AS match_home_team_goals_for,
  IFNULL(match_away_team_score_current,0) AS match_home_team_goals_against,
  IFNULL(match_home_team_score_current,0) - IFNULL(match_away_team_score_current,0)  AS match_home_teams_goal_diff,
  IFNULL(match_home_team_score_default_time,0) AS match_home_team_normal_time,
  IFNULL(match_home_team_score_overtime,0) AS match_home_team_extra_time,
  IFNULL(match_home_team_score_penalties,0) AS match_home_team_score_penalties,
  IFNULL(match_home_team_score_period_1,0) AS match_home_team_score_first_half,
  IFNULL(match_home_team_score_period_2,0) AS match_home_team_score_second_half,
  match_away_team_id,
  match_away_team_name,
  CASE 
  WHEN match_league_name = 'FA Cup' AND match_status_reason = 'AP'THEN  IFNULL(match_away_team_score_current,0) + IFNULL 
  (match_away_team_score_penalties,0) ELSE IFNULL(match_away_team_score_current,0) END AS match_away_team_score_end, 
  CASE 
  WHEN IFNULL(match_home_team_score_current,0) + IFNULL(match_home_team_score_penalties,0)  < IFNULL(match_away_team_score_current,0) + IFNULL(match_away_team_score_penalties,0) THEN 'WIN' 
  WHEN IFNULL(match_home_team_score_current,0) + IFNULL(match_home_team_score_penalties,0)  = IFNULL(match_away_team_score_current,0) + IFNULL(match_away_team_score_penalties,0) THEN 'DRAW' ELSE  
  'LOSS' END AS match_away_team_outcome,
  CASE 
  WHEN match_home_team_score_current < match_away_team_score_current THEN 1 ELSE 0 END AS match_away_team_win,
  CASE 
  WHEN match_home_team_score_current = match_away_team_score_current THEN 1 ELSE 0 END AS match_away_team_draw,
  CASE 
  WHEN match_home_team_score_current > match_away_team_score_current THEN 1 ELSE 0 END AS match_away_team_loss,  
  CASE
  WHEN mtc.match_league_name = 'FA Cup' THEN -1
  WHEN match_home_team_score_current > match_away_team_score_current THEN 0
  WHEN match_home_team_score_current = match_away_team_score_current THEN 1 ELSE 3 END AS match_away_team_points,
  IFNULL(match_away_team_score_current,0) AS match_away_team_goals_for,
  IFNULL(match_home_team_score_current,0) AS match_away_team_goals_against,
  IFNULL(match_away_team_score_current,0) - IFNULL(match_home_team_score_current,0)  AS match_away_teams_goal_diff,
  IFNULL(match_away_team_score_default_time,0) AS match_away_team_normal_time,
  IFNULL(match_away_team_score_overtime,0) AS match_away_team_extra_time ,
  IFNULL(match_away_team_score_penalties,0) AS match_away_team_score_penalties,
  IFNULL(match_away_team_score_period_1,0) AS match_away_team_score_first_half,
  IFNULL(match_away_team_score_period_2,0) AS match_away_team_score_second_half

FROM transform_layer.matches mtc

-- Get League Level from leagues
LEFT JOIN `transform_layer.view_leagues` vlges ON mtc.match_league_id = vlges.league_id

-- Get Season year from seasons
LEFT JOIN `transform_layer.seasons` sea ON mtc.match_season_id = sea.season_id

-- Get areana id from Teams
LEFT JOIN transform_layer.teams tms ON mtc.match_home_team_id = tms.team_id

-- Get lat & long from areana for the home team
LEFT JOIN transform_layer.arenas arnt ON tms.team_arena_id = arnt.arena_id 

-- Get lat & long from areana for the match
LEFT JOIN transform_layer.arenas arnm ON mtc.match_arena_id = arnm.arena_id 

ORDER BY mtc.match_league_name, mtc.match_start_time
