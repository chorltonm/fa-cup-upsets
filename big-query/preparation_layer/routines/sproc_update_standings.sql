CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_standings` ()

BEGIN


TRUNCATE TABLE preparation_layer.standings;

INSERT INTO preparation_layer.standings


SELECT

stn.id AS standings_id,
name AS standings_name,
league_id AS standings_league_id,
league_name AS standings_league_name,
season_id AS standings_season_id,
season_name AS standings_season_name,
type AS standings_type,
cmp.standings_competitors_team_id,
cmp.standings_competitors_team_name,
cmp.standings_competitors_position,
cmp.standings_competitors_matches,
cmp.standings_competitors_wins,
cmp.standings_competitors_draws,
cmp.standings_competitors_losses,
cmp.standings_competitors_scores_for,
cmp.standings_competitors_scores_against,
cmp.standings_competitors_points,

FROM `birkbeck-msc-project-422917.extract_layer.all_api_sportdevs_fb_standings` stn

# Flatten Compeitors

LEFT JOIN 

(

SELECT

id,
un_cmp.team_id AS standings_competitors_team_id,
un_cmp.team_name AS standings_competitors_team_name,
un_cmp.position AS standings_competitors_position,
un_cmp.matches AS standings_competitors_matches,
un_cmp.wins AS standings_competitors_wins,
un_cmp.draws AS standings_competitors_draws,
un_cmp.losses AS standings_competitors_losses,
un_cmp.scores_for AS standings_competitors_scores_for,
un_cmp.scores_against AS standings_competitors_scores_against,
un_cmp.points AS standings_competitors_points 

FROM `birkbeck-msc-project-422917.extract_layer.all_api_sportdevs_fb_standings` stn

CROSS JOIN UNNEST (competitors) AS un_cmp


) cmp ON stn.id = cmp.id
;
END
