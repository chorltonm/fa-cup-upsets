CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.preparation_layer.league_ranking`

(
`season_year` STRING,
    `league_id` INT64,
    `league_name` STRING,
    `league_level` INT64,
    `season_id` INT64,
    `season_name` STRING,
    `match_day` DATE,
    `match_round` INT64,
    `position` INT64,
    `team_id` INT64,
    `team_name` STRING,
    `played` INT64,
    `won` INT64,
    `drawn` INT64,
    `lost` INT64,
    `goals_for` INT64,
    `goal_against` INT64,
    `goal_difference` INT64,
    `points` INT64,
    `form_home` INT64,
    `form_away` INT64,
    `form_home_and_away` INT64,
    `match_flag` STRING,
    `match_team_points` INT64
)
