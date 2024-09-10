CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.analysis_layer.all_rating_ranking_model_all_predictions_unseen`

(
`Unnamed: 0` INT64,
    `ratings_model` STRING,
    `match_id` INT64,
    `home_team_no` INT64,
    `home_team_league_level` INT64,
    `away_team_no` INT64,
    `away_team_league_level` INT64,
    `home_team_rating` FLOAT64,
    `away_team_rating` FLOAT64,
    `home_team_rank` INT64,
    `away_team_rank` INT64,
    `predicted_winner` INT64,
    `actual_winner` INT64,
    `actual_upset` INT64,
    `predicted_upset` INT64,
    `upset_probability` FLOAT64
)
