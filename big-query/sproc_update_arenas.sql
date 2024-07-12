BEGIN

TRUNCATE TABLE preparation_layer.arenas;

INSERT INTO preparation_layer.arenas

SELECT 

arn.id AS arena_id,
arn.name AS arena_name,
operator AS arena_operator,
owner AS arena_owner,
city AS arena_city,
country_name AS arena_country_name,
country_id AS arena_country_id,
stadium_capacity AS arena_stadium_capacity,
gl.arena_geolocation_latitude,
gl.arena_geolocation_longitude,
gl.arena_geolocation_country_code,
gl.arena_geolocation_confidence,
gl.arena_geolocation_locality,
gl.arena_geolocation_region,
gl.arena_geolocation_county,
gl.arena_geolocation_region_code,
gl.arena_geolocation_administrative_area,
gl.arena_geolocation_name,
gl.arena_geolocation_label,
gl.arena_geolocation_continent,
built AS arena_built,
gl.arena_geolocation_type,
cost AS arena_cost,
surface AS arena_surface,
dimensions AS arena_dimensions,
opened AS arena_opened

FROM extract_layer.all_api_sportdevs_fb_arenas arn

LEFT JOIN 

(SELECT 

arn.id AS arena_id,
un_gl.latitude AS arena_geolocation_latitude,
un_gl.longitude AS arena_geolocation_longitude,
un_gl.country_code AS arena_geolocation_country_code,
un_gl.confidence AS arena_geolocation_confidence,
un_gl.locality AS arena_geolocation_locality,
un_gl.region AS arena_geolocation_region,
un_gl.county AS arena_geolocation_county,
un_gl.region_code AS arena_geolocation_region_code,
un_gl.administrative_area AS arena_geolocation_administrative_area,
un_gl.name AS arena_geolocation_name,
un_gl.label AS arena_geolocation_label,
un_gl.continent AS arena_geolocation_continent,
un_gl.type AS arena_geolocation_type,
un_gl.neighbourhood AS arena_geolocation_neighbourhood

FROM extract_layer.all_api_sportdevs_fb_arenas arn,

UNNEST (geolocation) AS un_gl) gl ON arn.id = gl.arena_id
;
END