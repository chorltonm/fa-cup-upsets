CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_matches` ()

BEGIN

TRUNCATE TABLE `preparation_layer.matches`;

INSERT INTO `preparation_layer.matches`

SELECT 

  mtc.id AS match_id,
  name AS match_name,
  league_id AS match_league_id,
  league_name AS match_league_name,
  season_id AS match_season_id,
  season_name AS match_season_name,
  round_id AS match_round_id_1,
  home_team_id AS match_home_team_id,
  home_team_name AS match_home_team_name,
  away_team_id AS match_away_team_id,
  away_team_name AS match_away_team_name,
  lineups_id AS match_lineups_id,
  start_time AS match_start_time,
  end_time AS match_end_time,
  time AS match_time,
  duration AS match_duration,
  attendance AS match_attendance,
  arena_id AS match_arena_id,
  arena_name AS match_arena_name,
  #coaches_id AS match_coaches_id,
  sts.match_status_reason,
  sts.match_status_type_1,
  rnd.match_round_start_time,
  rnd.match_round_end_time,
  rnd.match_round_round,
  rnd.match_round_name,
  rnd.match_round_id_2,
  coa.match_coaches_home_coach_name,
  coa.match_coaches_away_coach_name,
  coa.match_coaches_home_coach_id,
  coa.match_coaches_away_coach_id,
  ats.match_away_team_score_overtime,
  ats.match_away_team_score_extra_2,
  ats.match_away_team_score_penalties,
  ats.match_away_team_score_extra_1,
  ats.match_away_team_score_default_time,
  ats.match_away_team_score_period_1,
  ats.match_away_team_score_display,
  ats.match_away_team_score_period_2,
  ats.match_away_team_score_current,
  hts.match_home_team_score_overtime,
  hts.match_home_team_score_extra_2,
  hts.match_home_team_score_penalties,
  hts.match_home_team_score_extra_1,
  hts.match_home_team_score_default_time,
  hts.match_home_team_score_period_1,
  hts.match_home_team_score_display,
  hts.match_home_team_score_period_2,
  hts.match_home_team_score_current,
  tms.match_times_extend_time_2,
  tms.match_times_extend_time_1,
  tms.match_times_extend_time_4,
  tms.match_times_extend_time_3,
  tms.match_times_specific_start_time,
  referee_id AS match_referee_id,
  referee_name AS match_referee_name,
  class_id AS match_class_id,
  class_name AS match_class_name,
  graphs_id AS match_graphs_id,
  last_period AS match_last_period,
  previous_leg_match_id AS match_previous_leg_match_id,
  season_statistics_type AS match_season_statistics_type,
  status_type AS match_status_type_2,
  tournament_id AS match_tournament_id,
  tournament_importance AS match_tournament_importance,
  tournament_name AS match_tournament_name,
  weather_icon AS match_weather_icon,
  weather_id AS match_weather_id,
  weather_main AS match_weather_main

FROM `extract_layer.all_api_sportdevs_fb_matches` mtc


#Flatten Home Team Score
LEFT JOIN 

(
  SELECT 

  id,
  home_team_score.overtime AS match_home_team_score_overtime,
  home_team_score.extra_2 AS match_home_team_score_extra_2,
  home_team_score.penalties AS match_home_team_score_penalties,
  home_team_score.extra_1 AS match_home_team_score_extra_1,
  home_team_score.default_time AS match_home_team_score_default_time,
  home_team_score.period_1 AS match_home_team_score_period_1,
  home_team_score.display AS match_home_team_score_display,
  home_team_score.period_2 AS match_home_team_score_period_2,
  home_team_score.current AS match_home_team_score_current

  FROM `extract_layer.all_api_sportdevs_fb_matches` mtc

) hts ON mtc.id = hts.id

#Flatten Away Team Score
LEFT JOIN 
(
  SELECT 

  id,
  away_team_score.overtime AS match_away_team_score_overtime,
  away_team_score.extra_2 AS match_away_team_score_extra_2,
  CASE 
  # correction for incorrect penalty score between Queens Part Rangers v Rotherham 21/22 season
  WHEN id = 11454 THEN 7 ELSE away_team_score.penalties END AS match_away_team_score_penalties,
  away_team_score.extra_1 AS match_away_team_score_extra_1,
  away_team_score.default_time AS match_away_team_score_default_time,
  away_team_score.period_1 AS match_away_team_score_period_1,
  away_team_score.display AS match_away_team_score_display,
  away_team_score.period_2 AS match_away_team_score_period_2,
  away_team_score.current AS match_away_team_score_current

  FROM `extract_layer.all_api_sportdevs_fb_matches` mtc

) ats ON mtc.id = ats.id

# Flatten Round
LEFT JOIN 
(
  SELECT 

  id,
  round.start_time AS match_round_start_time,
  round.end_time AS match_round_end_time,
  round.round AS match_round_round,
  round.name AS match_round_name,
  round.id AS match_round_id_2,

  FROM `extract_layer.all_api_sportdevs_fb_matches` mtc

) rnd ON mtc.id = rnd.id

# Flatten Status
LEFT JOIN 
(
  SELECT 

  id,
  status.reason AS match_status_reason,
  status.type AS match_status_type_1

  FROM `extract_layer.all_api_sportdevs_fb_matches` mtc

) sts ON mtc.id = sts.id

# Flatten Times
LEFT JOIN 
(
  SELECT 

  id,
  times.extend_time_2 AS match_times_extend_time_2,
  times.extend_time_1 AS match_times_extend_time_1,
  times.extend_time_4 AS match_times_extend_time_4,
  times.extend_time_3 AS match_times_extend_time_3,
  times.specific_start_time AS match_times_specific_start_time

  FROM `extract_layer.all_api_sportdevs_fb_matches` mtc

) tms ON mtc.id = tms.id

# Flatten Coaches
LEFT JOIN 
(
  SELECT 

  id,
  coaches.home_coach_name AS match_coaches_home_coach_name,
  coaches.away_coach_name AS match_coaches_away_coach_name,
  coaches.home_coach_hash_image AS match_coaches_home_coach_hash_image,
  coaches.home_coach_id AS match_coaches_home_coach_id,
  coaches.away_coach_id AS match_coaches_away_coach_id

  FROM `extract_layer.all_api_sportdevs_fb_matches` mtc

) coa ON mtc.id = coa.id
;


END
