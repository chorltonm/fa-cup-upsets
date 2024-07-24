CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_leagues` ()

BEGIN

TRUNCATE TABLE preparation_layer.leagues;

INSERT INTO preparation_layer.leagues


SELECT

lges.id AS league_id,
lges.name AS league_name,
lges.most_titles AS league_most_titles,
lges.level AS league_level,
un_tmt.team_id AS league_teams_most_titles_team_id,
un_tmt.team_name AS league_teams_most_titles_team_name,
lges.class_name AS league_class_name,
lges.start_league AS league_start_league,
lges.importance AS league_importance,
lges.class_id AS league_class_id,
lges.end_league AS league_end_league,
lges.current_champion_team_num_titles AS league_current_champion_team_num_titles,
lges.current_champion_team_name AS league_current_champion_team_name,
lges.current_champion_team_id AS league_current_champion_team_id,
hl.league_higher_leagues_league_id,
hl.league_higher_leagues_league_name,
ll.league_lower_leagues_league_id,
ll.league_lower_leagues_league_name

FROM
  `extract_layer.all_api_sportdevs_fb_leagues` lges

-- Unnest array for teams_most_titles for repeated values. This preserves the rows coutn of the data for first unneset by performing a CROSS JOIN
CROSS JOIN
  UNNEST (teams_most_titles) AS un_tmt

-- Unnest higher leagues with primary key id for rows and use this to perform a left join back to the lges table
LEFT JOIN (
  SELECT
    lges.id,
    un_hl.league_id AS league_higher_leagues_league_id,
    Un_hl.league_name AS league_higher_leagues_league_name
  FROM
    `extract_layer.all_api_sportdevs_fb_leagues` lges
  CROSS JOIN
    UNNEST (higher_leagues) AS un_hl ) hl
ON
  lges.id = hl.id

-- Unnest lower leagues with primary key id for rows and use this to perform a left join back to the lges table
LEFT JOIN (
  SELECT
    lges.id,
    un_ll.league_id AS league_lower_leagues_league_id,
    un_ll.league_name AS league_lower_leagues_league_name
  FROM
    `extract_layer.all_api_sportdevs_fb_leagues` lges
  CROSS JOIN
    UNNEST (lower_leagues) AS un_ll ) ll
ON
  lges.id = ll.id

GROUP BY

lges.id,
lges.name,
lges.most_titles,
lges.level,
un_tmt.team_id,
un_tmt.team_name,
lges.class_name,
lges.start_league,
lges.importance,
lges.class_id,
lges.end_league,
lges.current_champion_team_num_titles,
lges.current_champion_team_name,
lges.current_champion_team_id,
hl.league_higher_leagues_league_id,
hl.league_higher_leagues_league_name,
ll.league_lower_leagues_league_id,
ll.league_lower_leagues_league_name
;
END
