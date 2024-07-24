CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_lineups` ()

BEGIN

TRUNCATE TABLE preparation_layer.lineups;

INSERT INTO preparation_layer.lineups

# Flatten Home Lineups
WITH flatten_home_lineups AS

(

SELECT

lnps.id AS lineup_id,
lnps.confirmed AS lineup_confirmed,
home_team.formation AS lineup_home_team_formation,
htp.lineup_home_team_players_player_id,
htp.lineup_home_team_players_player_name,
htp.lineup_home_team_players_position,
htp.lineup_home_team_players_substitute,
htp.lineup_home_team_players_shirt_number,
htp.lineup_home_team_players_jersey_number,
htp.lineup_home_team_players_player_statistics_id,
home_team.player_color_primary AS lineup_home_team_player_color_primary,
home_team.player_color_number AS lineup_home_team_player_color_number

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

# Unnest home team players

LEFT JOIN 
(
SELECT

lnps.id, 
un_htp.player_id AS lineup_home_team_players_player_id,
un_htp.player_name AS lineup_home_team_players_player_name,
un_htp.position AS lineup_home_team_players_position,
un_htp.substitute AS lineup_home_team_players_substitute,
un_htp.shirt_number AS lineup_home_team_players_shirt_number,
un_htp.jersey_number AS lineup_home_team_players_jersey_number,
un_htp.player_statistics_id AS lineup_home_team_players_player_statistics_id

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

CROSS JOIN UNNEST (home_team.players) AS un_htp

) htp ON lnps.id = htp.id

)

,flatten_home_missing_lineups AS

(

SELECT

lnps.id AS lineup_id,
htmp.lineup_home_team_missing_players_player_id,
htmp.lineup_home_team_missing_players_player_name,
htmp.lineup_home_team_missing_players_reason,
htmp.lineup_home_team_missing_players_type

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

# Unnest home team missing players

LEFT JOIN 
(
SELECT

lnps.id, 
un_htmp.player_id AS lineup_home_team_missing_players_player_id,
un_htmp.player_name AS lineup_home_team_missing_players_player_name,
un_htmp.reason AS lineup_home_team_missing_players_reason,
un_htmp.type AS lineup_home_team_missing_players_type

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

CROSS JOIN UNNEST (home_team.missing_players) AS un_htmp

) htmp ON lnps.id = htmp.id

)

,flatten_away_lineups AS

(
SELECT

lnps.id AS lineup_id,
lnps.confirmed AS lineup_confirmed,
away_team.formation AS lineup_away_team_formation,
atp.lineup_away_team_players_player_id,
atp.lineup_away_team_players_player_name,
atp.lineup_away_team_players_position,
atp.lineup_away_team_players_substitute,
atp.lineup_away_team_players_shirt_number,
atp.lineup_away_team_players_jersey_number,
atp.lineup_away_team_players_player_statistics_id,
away_team.player_color_primary AS lineup_away_team_player_color_primary,
away_team.player_color_number AS lineup_away_team_player_color_number

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

# Unnest away team players

LEFT JOIN 
(
SELECT

lnps.id, 
un_atp.player_id AS lineup_away_team_players_player_id,
un_atp.player_name AS lineup_away_team_players_player_name,
un_atp.position AS lineup_away_team_players_position,
un_atp.substitute AS lineup_away_team_players_substitute,
un_atp.shirt_number AS lineup_away_team_players_shirt_number,
un_atp.jersey_number AS lineup_away_team_players_jersey_number,
un_atp.player_statistics_id AS lineup_away_team_players_player_statistics_id

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

CROSS JOIN UNNEST (away_team.players) AS un_atp

) atp ON lnps.id = atp.id 

)
, flatten_away_missing_lineups AS

(

SELECT

lnps.id AS lineup_id,
atmp.lineup_away_team_missing_players_player_id,
atmp.lineup_away_team_missing_players_player_name,
atmp.lineup_away_team_missing_players_reason,
atmp.lineup_away_team_missing_players_type

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

# Unnest away team missing players

LEFT JOIN 
(
SELECT

lnps.id, 
un_atmp.player_id AS lineup_away_team_missing_players_player_id,
un_atmp.player_name AS lineup_away_team_missing_players_player_name,
un_atmp.reason AS lineup_away_team_missing_players_reason,
un_atmp.type AS lineup_away_team_missing_players_type

FROM extract_layer.all_api_sportdevs_fb_lineups lnps

CROSS JOIN UNNEST (away_team.missing_players) AS un_atmp

WHERE un_atmp.player_id  IS NOT NULL

) atmp ON lnps.id = atmp.id

)
 # Load into final lineups table

SELECT

lineup_id,
'home' AS lineup_home_away_flag,
lineup_confirmed,
lineup_home_team_formation,
lineup_home_team_players_player_id,
lineup_home_team_players_player_name,
lineup_home_team_players_position,
lineup_home_team_players_substitute,
lineup_home_team_players_player_statistics_id,
'available' AS lineup_availability,
'selected' AS lineup_availability_reason,
1 AS apperance_count

FROM flatten_home_lineups

WHERE lineup_home_team_players_player_id IS NOT NULL

UNION ALL

SELECT

lineup_id,
'home' AS lineup_home_away_flag,
null AS lineup_confirmed,
'n/a' AS lineup_home_missing_team_formation,
lineup_home_team_missing_players_player_id,
lineup_home_team_missing_players_player_name,
'n/a' AS lineup_home_team_missing_players_position,
null AS lineup_home_team_missing_players_substitute,
null lineup_home_team_players_player_statistics_id,
IFNULL(lineup_home_team_missing_players_type,'missing') AS lineup_availability,
CASE 
WHEN lineup_home_team_missing_players_reason = 0 then 'Other'
WHEN lineup_home_team_missing_players_reason = 1 then 'Injured'
WHEN lineup_home_team_missing_players_reason = 2 then 'Ill'
WHEN lineup_home_team_missing_players_reason = 3 then 'Suspended'
WHEN lineup_home_team_missing_players_reason = 11 then 'YellowCard'
WHEN lineup_home_team_missing_players_reason = 12 then 'YellowRedCard'
WHEN lineup_home_team_missing_players_reason = 13 then 'RedCard'
WHEN lineup_home_team_missing_players_reason = 21 then 'OnLoan'
ELSE 'n/a' END AS lineup_availability_reason,
0 AS apperance_count

FROM flatten_home_missing_lineups

WHERE lineup_home_team_missing_players_player_id IS NOT NULL

UNION ALL

SELECT

lineup_id,
'away' AS lineup_away_away_flag,
lineup_confirmed,
lineup_away_team_formation,
lineup_away_team_players_player_id,
lineup_away_team_players_player_name,
lineup_away_team_players_position,
lineup_away_team_players_substitute,
lineup_away_team_players_player_statistics_id,
'available' AS lineup_availability,
'selected' AS lineup_availability_reason,
1 AS apperance_count

FROM flatten_away_lineups

WHERE lineup_away_team_players_player_id IS NOT NULL

UNION ALL

SELECT

lineup_id,
'away' AS lineup_away_away_flag,
null AS lineup_confirmed,
'n/a' AS lineup_away_missing_team_formation,
lineup_away_team_missing_players_player_id,
lineup_away_team_missing_players_player_name,
'n/a' AS lineup_away_team_missing_players_position,
null AS lineup_away_team_missing_players_substitute,
null lineup_away_team_players_player_statistics_id,
IFNULL(lineup_away_team_missing_players_type,'missing') AS lineup_availability,
CASE 
WHEN lineup_away_team_missing_players_reason = 0 then 'Other'
WHEN lineup_away_team_missing_players_reason = 1 then 'Injured'
WHEN lineup_away_team_missing_players_reason = 2 then 'Ill'
WHEN lineup_away_team_missing_players_reason = 3 then 'Suspended'
WHEN lineup_away_team_missing_players_reason = 11 then 'YellowCard'
WHEN lineup_away_team_missing_players_reason = 12 then 'YellowRedCard'
WHEN lineup_away_team_missing_players_reason = 13 then 'RedCard'
WHEN lineup_away_team_missing_players_reason = 21 then 'OnLoan'
ELSE 'n/a' END AS lineup_availability_reason,
0 AS apperance_count

FROM flatten_away_missing_lineups

WHERE lineup_away_team_missing_players_player_id IS NOT NULL

;

END
