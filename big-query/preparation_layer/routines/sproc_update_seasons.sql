CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_seasons` ()

BEGIN

TRUNCATE TABLE `preparation_layer.seasons`;

INSERT INTO `preparation_layer.seasons`

SELECT 

league_id AS season_league_id,
league_name AS season_league_name,
id AS season_id,
name AS season_name,
year AS season_year,
start_time AS season_start_time,
end_time AS season_end_time,

FROM `extract_layer.all_api_sportdevs_fb_seasons`


;


END
