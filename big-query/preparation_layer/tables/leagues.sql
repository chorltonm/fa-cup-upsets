CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.preparation_layer.leagues`

(
`league_id` INT64,
    `league_name` STRING,
    `league_most_titles` INT64,
    `league_level` INT64,
    `league_teams_most_titles_team_id` INT64,
    `league_teams_most_titles_team_name` STRING,
    `league_class_name` STRING,
    `league_start_league` TIMESTAMP,
    `league_importance` INT64,
    `league_class_id` INT64,
    `league_end_league` TIMESTAMP,
    `league_current_champion_team_num_titles` INT64,
    `league_current_champion_team_name` STRING,
    `league_current_champion_team_id` INT64,
    `league_higher_leagues_league_id` INT64,
    `league_higher_leagues_league_name` STRING,
    `league_lower_leagues_league_id` INT64,
    `league_lower_leagues_league_name` STRING
)
