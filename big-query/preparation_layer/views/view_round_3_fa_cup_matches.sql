CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_round_3_fa_cup_matches` AS

SELECT

  vmtc.season_year,
  match_id,
  match_name,
  vmtc.match_league_name,
  vmtc.match_season_name
  match_round_name,
  match_start_time,
  match_date,
  match_1st_half_kick_off,
  match_2nd_half_kick_off,
  match_attendance,
  match_duration,
  arena_name,
  arena_stadium_capacity,
  match_latitude,
  match_longitude,
  match_final_score,
  rankh.league_name  AS home_team_league_name, 
  rankh.league_level  AS home_team_league_level, 
  rankh.league_form_home_or_away  AS home_team_league_form, 
  rankh.league_form_home_and_away  AS home_team_league_form_home_and_away,
  rankh.league_promotion_relegation  AS home_team_league_promotion_relegation, 
  rankh.league_position  AS home_team_league_position, 
  rankh.round_3_fa_cup_rank AS home_team_round_3_position,
  match_home_team_id,
  match_home_team_name,
  match_home_team_outcome,
  match_home_team_score_end,
  match_home_team_normal_time,
  match_home_team_extra_time,
  match_home_team_score_penalties,
  match_home_team_score_first_half,
  match_home_team_score_second_half,
  match_away_team_id,
  match_away_team_name,
  ranka.league_name  AS away_team_league_name, 
  ranka.league_level  AS away_team_league_level, 
  ranka.league_form_home_or_away  AS away_team_league_form, 
  ranka.league_form_home_and_away  AS away_team_league_form_home_and_away,
  ranka.league_promotion_relegation  AS away_team_league_promotion_relegation, 
  ranka.league_position  AS away_team_league_position, 
  ranka.round_3_fa_cup_rank AS away_team_round_3_position,
  match_away_team_outcome,
  match_away_team_score_end, 
  match_away_team_normal_time,
  match_away_team_extra_time ,
  match_away_team_score_first_half,
  match_away_team_score_second_half,
  IFNULL(IFNULL(vrh.rivalry_flag,vra.rivalry_flag),0) AS rivalry_flag,
  CASE 
  WHEN match_away_team_outcome = 'WIN' AND ranka.league_level > rankh.league_level THEN 1
  WHEN match_home_team_outcome = 'WIN' AND rankh.league_level > ranka.league_level THEN 1 ELSE 0 END AS round_3_upset_label
  

FROM preparation_layer.view_matches vmtc

-- Home Team Round 3 League Position
LEFT JOIN preparation_layer.view_round_3_fa_cup_rank rankh ON vmtc.season_year = rankh.season_year AND vmtc.match_home_team_id = rankh.team_id

-- Away Team Round 3 League Position
LEFT JOIN preparation_layer.view_round_3_fa_cup_rank ranka ON vmtc.season_year = ranka.season_year AND vmtc.match_away_team_id = ranka.team_id

-- Does rivalry exist home away teams ids

LEFT JOIN preparation_layer.view_rivalries vrh ON vmtc.match_home_team_id = vrh.team1_id AND vmtc.match_away_team_id = vrh.team2_id

-- Does rivalry exist away home teams ids

LEFT JOIN preparation_layer.view_rivalries vra ON vmtc.match_home_team_id = vra.team2_id AND vmtc.match_away_team_id = vra.team1_id

WHERE 

vmtc.match_league_name = 'FA Cup' AND vmtc.match_round_name = 'Round 3'AND vmtc.match_status_reason  IN ('Ended','AET','AP')  -- Ended notmal time, AET after extra time, AP after penalties

AND vmtc.match_home_team_score_end <> vmtc.match_away_team_score_end

--AND vmtc.season_year NOT IN ('21/22','22/23')


ORDER BY season_year ASC
