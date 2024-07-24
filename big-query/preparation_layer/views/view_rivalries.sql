CREATE OR REPLACE VIEW `birkbeck-msc-project-422917.preparation_layer.view_rivalries` AS

SELECT DISTINCT

CONCAT(CAST(team1_id AS STRING),'_',CAST(team2_id AS STRING)) AS rivalry_id,
team1_name,
team2_name,
team1_id,
team2_id,
1 AS rivalry_flag

FROM extract_layer.web_scrape_wikipedia_rivalries

WHERE team1_id <> -1 OR team2_id <> -1


