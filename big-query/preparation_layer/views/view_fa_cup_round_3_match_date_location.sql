CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_fa_cup_round_3_match_date_location` AS

SELECT 

  match_id,
  match_date,
  match_latitude,
  match_longitude

FROM preparation_layer.view_matches vmtc

WHERE 

vmtc.match_league_name = 'FA Cup' AND vmtc.match_round_name = 'Round 3'AND vmtc.match_status_reason  IN ('Ended','AET','AP')  -- Ended notmal time, AET after extra time, AP after penalties

AND vmtc.match_home_team_score_end <> vmtc.match_away_team_score_end

AND match_id NOT IN (SELECT DISTINCT match_id FROM extract_layer.all_api_visual_crossing_weather)

AND (match_latitude IS NOT NULL OR match_longitude IS NOT NULL)

ORDER BY 2,1

LIMIT 40
