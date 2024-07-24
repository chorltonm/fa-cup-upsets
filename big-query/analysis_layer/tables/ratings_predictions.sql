CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.analysis_layer.ratings_predictions` 

(
`ratings_model` STRING,
    `fold_number` INT64,
    `match_id` INT64,
    `home_team_no` INT64,
    `home_team_league_level` INT64,
    `away_team_no` INT64,
    `away_team_league_level` INT64,
    `home_team_rating` FLOAT64,
    `away_team_rating` FLOAT64,
    `predicted_winner` INT64,
    `actual_winner` INT64,
    `actual_upset` INT64,
    `predicted_upset` INT64,
    `upset_probability` FLOAT64
)
