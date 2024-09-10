CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.analysis_layer.view_unseen_predictions` AS

SELECT 

ratings_model as model,
fa_cup_features.season_year,
rr_preds.match_id,
fa_cup_features.match_name,
fa_cup_features.match_final_score,
fa_cup_features.home_team_league_level,
fa_cup_features.away_team_league_level, 
CASE 
WHEN fa_cup_features.home_team_league_level > fa_cup_features.away_team_league_level THEN CAST((fa_cup_features.home_team_league_level - fa_cup_features.away_team_league_level) AS STRING) || ' Leagues(s) Difference'
ELSE CAST((fa_cup_features.away_team_league_level - fa_cup_features.home_team_league_level) AS STRING) || ' Leagues(s) Difference'END AS number_of_leagues_difference,
actual_upset, 
predicted_upset,
CASE 
WHEN actual_upset = 1 AND predicted_upset = 1 THEN 1 ELSE 0 END AS correct_upset


FROM `birkbeck-msc-project-422917.analysis_layer.all_rating_ranking_model_all_predictions_unseen` rr_preds

INNER JOIN preparation_layer.view_fa_cup_round_3_features fa_cup_features ON rr_preds.match_id = fa_cup_features.match_id

UNION ALL 

SELECT 

ml_name_ranking as model,
fa_cup_features.season_year,
ml_preds.match_id,
fa_cup_features.match_name,
fa_cup_features.match_final_score,
fa_cup_features.home_team_league_level,
fa_cup_features.away_team_league_level, 
CASE 
WHEN fa_cup_features.home_team_league_level > fa_cup_features.away_team_league_level THEN CAST((fa_cup_features.home_team_league_level - fa_cup_features.away_team_league_level) AS STRING) || ' Leagues(s) Difference'
ELSE CAST((fa_cup_features.away_team_league_level - fa_cup_features.home_team_league_level) AS STRING) || ' Leagues(s) Difference'END AS number_of_leagues_difference,
actual AS actual_upset, 
predicted AS predicted_upset,
CASE 
WHEN actual = 1 AND predicted = 1 THEN 1 ELSE 0 END AS correct_upset

# select *
FROM `birkbeck-msc-project-422917.analysis_layer.ml_model_all_predictions_unseen` ml_preds

INNER JOIN preparation_layer.view_fa_cup_round_3_features fa_cup_features ON ml_preds.match_id = fa_cup_features.match_id

ORDER BY 1 ASC

