CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_fa_cup_round_3_features` AS

SELECT 

season_year,
fa_cup_mtchs.match_id,
fa_cup_mtchs.match_name,
fa_cup_mtchs.match_final_score,
arena_stadium_capacity,
home_team_league_level,
CASE 
WHEN match_home_team_score_end > match_away_team_score_end THEN 1 ELSE 0 END AS home_win,
home_team_round_3_position,
rr_home.massey AS home_team_massey,
rr_home.colley AS home_team_colley,
rr_home.keener AS home_team_keener,
rr_home.trueskill AS home_team_trueskill,
rr_home.borda_count AS home_team_borda_count,
rr_home.local_kemeny_optimisation AS home_team_local_kemeny_optimisation,
ROUND(hlnp_str.lineup_strength,2) AS home_lineup_strength,
ROUND((home_team_league_form/18),2) AS home_team_league_form, -- divide by 18 as most points available from last 5 games and form is based on points gained
ROUND((home_team_league_form_home_and_away/18),2) AS home_team_league_form_home_and_away,
IFNULL(home_team_league_promotion_relegation,0) AS home_team_league_promotion_relegation, 
away_team_league_level,
#CASE WHEN match_home_team_score_end < match_away_team_score_end THEN 1 ELSE 0 END AS away_win,
away_team_round_3_position,
rr_away.massey AS away_team_massey,
rr_away.colley AS away_team_colley,
rr_away.keener AS away_team_keener,
rr_away.trueskill AS away_team_trueskill,
rr_away.borda_count AS away_team_borda_count,
rr_away.local_kemeny_optimisation AS away_team_local_kemeny_optimisation,
ROUND(alnp_str.lineup_strength,2) AS away_lineup_strength,
ROUND((away_team_league_form/18),2) AS away_team_league_form, 
ROUND((away_team_league_form_home_and_away/18),2) AS away_team_league_form_home_and_away,
IFNULL(away_team_league_promotion_relegation,0) AS away_team_league_promotion_relegation, 
IFNULL(rivalry_flag,0) AS rivalry_flag,
(match_1st_half_weather_data_hours_feelslike + match_2nd_half_weather_data_hours_feelslike)/2 AS match_weather_data_hours_feelslike,
(match_1st_half_weather_data_hours_humidity + match_2nd_half_weather_data_hours_humidity)/2 AS match_weather_data_hours_humidity ,
(match_1st_half_weather_data_hours_dew + match_2nd_half_weather_data_hours_dew)/2 AS match_weather_data_hours_dew,
(match_1st_half_weather_data_hours_precip + match_2nd_half_weather_data_hours_precip)/2 AS match_weather_data_hours_precip,
(match_1st_half_weather_data_hours_snow + match_2nd_half_weather_data_hours_snow)/2 AS match_weather_data_hours_snow,
(match_1st_half_weather_data_hours_snowdepth + match_2nd_half_weather_data_hours_snowdepth)/2 AS match_weather_data_hours_snowdepth,
(match_1st_half_weather_data_hours_windspeed + match_2nd_half_weather_data_hours_windspeed)/2 AS match_weather_data_hours_windspeed,
(match_1st_half_weather_data_hours_pressure + match_2nd_half_weather_data_hours_pressure)/2 AS match_weather_data_hours_pressure,
(match_1st_half_weather_data_hours_visibility + match_2nd_half_weather_data_hours_visibility)/2 AS match_weather_data_hours_visibility,
(match_1st_half_weather_data_hours_cloudcover + match_2nd_half_weather_data_hours_cloudcover)/2 AS match_weather_data_hours_cloudcover,
CASE 
WHEN match_1st_half_weather_data_hours_conditions IS NULL AND match_2ND_half_weather_data_hours_conditions IS NULL THEN ''
WHEN TRIM(match_1st_half_weather_data_hours_conditions) = TRIM(match_2nd_half_weather_data_hours_conditions) THEN match_1st_half_weather_data_hours_conditions
ELSE CONCAT(TRIM(match_1st_half_weather_data_hours_conditions),' ', TRIM(match_2nd_half_weather_data_hours_conditions)) END AS match_weather_data_hours_condition,
round_3_upset_label AS target_variable


FROM `birkbeck-msc-project-422917.preparation_layer.view_round_3_fa_cup_matches` fa_cup_mtchs


-- Home Team Lineup Strength
LEFT JOIN preparation_layer.view_fa_cup_lineup_strength hlnp_str 
                        ON  fa_cup_mtchs.match_id = hlnp_str.match_id AND fa_cup_mtchs.match_home_team_id = hlnp_str.match_team_id

-- Away Team Lineup Strength
LEFT JOIN preparation_layer.view_fa_cup_lineup_strength alnp_str 
                        ON  fa_cup_mtchs.match_id = alnp_str.match_id AND fa_cup_mtchs.match_away_team_id = alnp_str.match_team_id

-- Match Day Weather
LEFT JOIN preparation_layer.view_fa_cup_match_weather_hourly match_weather ON  fa_cup_mtchs.match_id = match_weather.match_id

-- Ranking data - home team

LEFT JOIN analysis_layer.ratings_model_ranks rr_home ON fa_cup_mtchs.home_team_round_3_position = rr_home.team_no AND rr_home.fold_number = 0

-- Ranking data - away team

LEFT JOIN analysis_layer.ratings_model_ranks rr_away ON fa_cup_mtchs.away_team_round_3_position = rr_away.team_no AND rr_away.fold_number = 0


WHERE home_team_league_level <> away_team_league_level

ORDER BY home_team_round_3_position ASC

