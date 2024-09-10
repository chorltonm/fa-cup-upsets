CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.extract_layer.api_sportdevs_fb_leagues`

(
`current_champion_team_num_titles` INT64,
    `current_champion_team_name` STRING,
    `current_champion_team_hash_image` STRING,
    `current_champion_team_id` INT64,
    `class_hash_image` STRING,
    `class_id` INT64,
    `end_league` TIMESTAMP,
    `higher_leagues` RECORD,
    `importance` INT64,
    `start_league` TIMESTAMP,
    `lower_leagues` RECORD,
    `class_name` STRING,
    `secondary_color` STRING,
    `primary_color` STRING,
    `teams_most_titles` RECORD,
    `level` INT64,
    `most_titles` INT64,
    `name` STRING,
    `hash_image` STRING,
    `id` INT64
)
