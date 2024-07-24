CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_leagues` AS
SELECT 

lges.league_id,
lges.league_name,
lges.league_level,
IFNULL(lges.league_higher_leagues_league_id,0) AS league_higher_leagues_league_id,
IFNULL(lges.league_higher_leagues_league_name,'n/a') AS league_higher_leagues_league_name,
CASE 
WHEN lges.league_level = 1 THEN 0
ELSE lges.league_level - 1 END AS league_higher_leagues_league_level,
lges.league_level + 1 AS league_lower_leagues_league_level,
IFNULL(lges.league_lower_leagues_league_id,0)  AS league_lower_leagues_league_id_1,
IFNULL(lges.league_lower_leagues_league_name,'n/a')  AS league_lower_leagues_league_name_1,
IFNULL(llges.league_lower_leagues_league_id,0)  AS league_lower_leagues_league_id_2,
IFNULL(llges.league_lower_leagues_league_name,'n/a')  AS league_lower_leagues_league_name_2,

 FROM `birkbeck-msc-project-422917.transform_layer.leagues` lges

LEFT JOIN 

(
SELECT DISTiNCT 

league_id,
league_name,
league_lower_leagues_league_id,
league_lower_leagues_league_name

FROM `birkbeck-msc-project-422917.transform_layer.leagues`  WHERE league_lower_leagues_league_name = 'National League South'

) llges ON lges.league_id = llges.league_id

GROUP BY

lges.league_id,
lges.league_name,
lges.league_level,
lges.league_higher_leagues_league_id,
lges.league_higher_leagues_league_name,
lges.league_lower_leagues_league_id,
lges.league_lower_leagues_league_name,
llges.league_lower_leagues_league_id,
llges.league_lower_leagues_league_name

HAVING lges.league_name IN 

('Premier League', 'Championship','League One', 'League Two', 'National League')

AND lges.league_lower_leagues_league_name <> 'National League South'

ORDER BY league_level
