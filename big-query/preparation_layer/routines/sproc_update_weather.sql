CREATE OR REPLACE PROCEDURE `birkbeck-msc-project-422917.preparation_layer.sproc_update_weather` ()

BEGIN

TRUNCATE TABLE preparation_layer.weather;

INSERT INTO preparation_layer.weather

SELECT  

wtr.match_id AS match_id,
wtd.weather_data_day_datetime,
weather_data.latitude AS weather_data_latitude,
weather_data.longitude AS weather_data_longitude,
weather_data.address AS weather_data_address,
weather_data.resolvedAddress AS weather_data_resolvedAddress,
weather_data.timezone AS weather_data_timezone,
weather_data.tzoffset AS weather_data_tzoffset,
wtd.weather_data_day_icon,
wtd.weather_data_day_datetimeEpoch,
wtd.weather_data_day_tempmax,
wtd.weather_data_day_tempmin,
wtd.weather_data_day_feelslikemax,
wtd.weather_data_day_feelslikemin,
wtd.weather_data_day_dew,
wtd.weather_data_day_humidity,
wtd.weather_data_day_precipprob,
wtd.weather_data_day_precipcover,
wtd.weather_data_day_preciptype,
wtd.weather_data_day_snow,
wtd.weather_data_day_windgust,
wtd. weather_data_day_snowdepth,
wtd.weather_data_day_windspeed,
wtd.weather_data_day_winddir,
wtd.weather_data_day_pressure,
wtd.weather_data_day_cloudcover,
wtd.weather_data_day_visibility,
wtd.weather_data_day_uvindex,
wtd.weather_data_day_sunrise,
wtd.weather_data_day_solarenergy,
wtd.weather_data_day_sunsetEpoch,
wtd.weather_data_day_moonphase,
wtd.weather_data_day_conditions,
wtd.weather_data_day_sunset,
wtd.weather_data_day_description,
wtd.weather_data_day_source,
wtd.weather_data_day_solarradiation,
wtd.weather_data_day_sunriseEpoch,
wtd.weather_data_day_precip,
wtd.weather_data_day_temp,
wtd.weather_data_day_feelslike,
wth.weather_data_hours_datetime,
wth.weather_data_hours_datetimeEpoch,
wth.weather_data_hours_temp,
wth.weather_data_hours_feelslike,
wth.weather_data_hours_humidity,
wth.weather_data_hours_dew,
wth.weather_data_hours_precip,
wth.weather_data_hours_precipprob,
wth.weather_data_hours_snow,
wth.weather_data_hours_snowdepth,
wth.weather_data_hours_preciptype,
wth.weather_data_hours_windgust,
wth.weather_data_hours_windspeed,
wth.weather_data_hours_winddir,
wth.weather_data_hours_pressure,
wth.weather_data_hours_visibility,
wth.weather_data_hours_cloudcover,
wth.weather_data_hours_icon,
wth.weather_data_hours_solarradiation,
wth.weather_data_hours_solarenergy,
wth.weather_data_hours_conditions,
wth.weather_data_hours_uvindex

FROM `birkbeck-msc-project-422917.extract_layer.all_api_visual_crossing_weather` wtr


-- Flatten Daily Weather
LEFT JOIN 

(
SELECT 

match_id,
un_wtd.datetime AS weather_data_day_datetime,
un_wtd.icon AS weather_data_day_icon,
un_wtd.datetimeEpoch AS weather_data_day_datetimeEpoch,
un_wtd.tempmax AS weather_data_day_tempmax,
un_wtd.tempmin AS weather_data_day_tempmin,
un_wtd.feelslikemax AS weather_data_day_feelslikemax,
un_wtd.feelslikemin AS weather_data_day_feelslikemin,
un_wtd.dew AS weather_data_day_dew,
un_wtd.humidity AS weather_data_day_humidity,
un_wtd.precipprob AS weather_data_day_precipprob,
un_wtd.precipcover AS weather_data_day_precipcover,
ARRAY_TO_STRING(un_wtd.preciptype,', ') AS weather_data_day_preciptype,
un_wtd.snow AS weather_data_day_snow,
un_wtd.windgust AS weather_data_day_windgust,
un_wtd.snowdepth AS weather_data_day_snowdepth,
un_wtd.windspeed AS weather_data_day_windspeed,
un_wtd.winddir AS weather_data_day_winddir,
un_wtd.pressure AS weather_data_day_pressure,
un_wtd.cloudcover AS weather_data_day_cloudcover,
un_wtd.visibility AS weather_data_day_visibility,
un_wtd.uvindex AS weather_data_day_uvindex,
un_wtd.sunrise AS weather_data_day_sunrise,
un_wtd.solarenergy AS weather_data_day_solarenergy,
un_wtd.sunsetEpoch AS weather_data_day_sunsetEpoch,
un_wtd.moonphase AS weather_data_day_moonphase,
un_wtd.conditions AS weather_data_day_conditions,
un_wtd.sunset AS weather_data_day_sunset,
un_wtd.description AS weather_data_day_description,
un_wtd.source AS weather_data_day_source,
un_wtd.solarradiation AS weather_data_day_solarradiation,
un_wtd.sunriseEpoch AS weather_data_day_sunriseEpoch,
un_wtd.precip AS weather_data_day_precip,
un_wtd.temp AS weather_data_day_temp,
un_wtd.feelslike AS weather_data_day_feelslike,



FROM `birkbeck-msc-project-422917.extract_layer.all_api_visual_crossing_weather` wtr

CROSS JOIN UNNEST (weather_data.days) AS un_wtd

) wtd ON wtd.match_id = wtr.match_id


-- Flatten Hourly Weather

LEFT JOIN 
(

SELECT 

match_id,
un_wth.datetime AS weather_data_hours_datetime,
un_wth.datetimeEpoch AS weather_data_hours_datetimeEpoch,
un_wth.temp AS weather_data_hours_temp,
un_wth.feelslike AS weather_data_hours_feelslike,
un_wth.humidity AS weather_data_hours_humidity,
un_wth.dew AS weather_data_hours_dew,
un_wth.precip AS weather_data_hours_precip,
un_wth.precipprob AS weather_data_hours_precipprob,
un_wth.snow AS weather_data_hours_snow,
un_wth.snowdepth AS weather_data_hours_snowdepth,
ARRAY_TO_STRING(un_wth.preciptype,', ') AS weather_data_hours_preciptype,
un_wth.windgust AS weather_data_hours_windgust,
un_wth.windspeed AS weather_data_hours_windspeed,
un_wth.winddir AS weather_data_hours_winddir,
un_wth.pressure AS weather_data_hours_pressure,
un_wth.visibility AS weather_data_hours_visibility,
un_wth.cloudcover AS weather_data_hours_cloudcover,
un_wth.icon AS weather_data_hours_icon,
un_wth.solarradiation AS weather_data_hours_solarradiation,
un_wth.solarenergy AS weather_data_hours_solarenergy,
un_wth.conditions AS weather_data_hours_conditions,
un_wth.uvindex AS weather_data_hours_uvindex

FROM `birkbeck-msc-project-422917.extract_layer.all_api_visual_crossing_weather` wtr

CROSS JOIN UNNEST (weather_data.days) AS un_day
CROSS JOIN UNNEST (un_day.hours) AS un_wth

) wth ON wth.match_id = wtr.match_id

; 

END
