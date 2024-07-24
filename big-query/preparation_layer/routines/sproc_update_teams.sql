CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_teams` ()

BEGIN

TRUNCATE TABLE `preparation_layer.teams`;

INSERT INTO `preparation_layer.teams`

SELECT 

id AS team_id,
name_code AS team_name_code,
name AS team_name,
country_id AS team_country_id,
full_name AS team_full_name,
tournament_id AS team_tournament_id,
short_name AS team_short_name,
tournament_name AS team_tournament_name,
class_id AS team_class_id,
class_name AS team_class_name,
primary_league_id AS team_primary_league_id,
arena_id AS team_arena_id,
arena_name AS team_arena_name,
primary_league_name AS team_primary_league_name,
coach_id AS team_coach_id,
coach_name AS team_coach_name,
gender AS team_gender,
color_primary AS team_color_primary,
color_secondary AS team_color_secondary,
national AS team_national,
country_name AS team_country_name,
foundation_date AS team_foundation_date,
color_text AS team_color_text,
type AS team_type

FROM extract_layer.all_api_sportdevs_fb_teams
;

END
