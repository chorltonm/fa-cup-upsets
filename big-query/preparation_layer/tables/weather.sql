CREATE OR REPLACE TABLE `birkbeck-msc-project-422917.preparation_layer.weather`

(
`match_id` INT64,
    `weather_data_days_datetime` DATE,
    `weather_data_latitude` FLOAT64,
    `weather_data_longitude` FLOAT64,
    `weather_data_address` STRING,
    `weather_data_resolvedAddress` STRING,
    `weather_data_timezone` STRING,
    `weather_data_tzoffset` FLOAT64,
    `weather_data_days_icon` STRING,
    `weather_data_days_datetimeEpoch` INT64,
    `weather_data_days_tempmax` FLOAT64,
    `weather_data_days_tempmin` FLOAT64,
    `weather_data_days_feelslikemax` FLOAT64,
    `weather_data_days_feelslikemin` FLOAT64,
    `weather_data_days_dew` FLOAT64,
    `weather_data_days_humidity` FLOAT64,
    `weather_data_days_precipprob` FLOAT64,
    `weather_data_days_precipcover` FLOAT64,
    `weather_data_days_preciptype` STRING,
    `weather_data_days_snow` FLOAT64,
    `weather_data_days_windgust` FLOAT64,
    `weather_data_days_snowdepth` FLOAT64,
    `weather_data_days_windspeed` FLOAT64,
    `weather_data_days_winddir` FLOAT64,
    `weather_data_days_pressure` FLOAT64,
    `weather_data_days_cloudcover` FLOAT64,
    `weather_data_days_visibility` FLOAT64,
    `weather_data_days_uvindex` FLOAT64,
    `weather_data_days_sunrise` TIME,
    `weather_data_days_solarenergy` FLOAT64,
    `weather_data_days_sunsetEpoch` INT64,
    `weather_data_days_moonphase` FLOAT64,
    `weather_data_days_conditions` STRING,
    `weather_data_days_sunset` TIME,
    `weather_data_days_description` STRING,
    `weather_data_days_source` STRING,
    `weather_data_days_solarradiation` FLOAT64,
    `weather_data_days_sunriseEpoch` INT64,
    `weather_data_days_precip` FLOAT64,
    `weather_data_days_temp` FLOAT64,
    `weather_data_days_feelslike` FLOAT64,
    `weather_data_hours_datetime` TIME,
    `weather_data_hours_datetimeEpoch` INT64,
    `weather_data_hours_temp` FLOAT64,
    `weather_data_hours_feelslike` FLOAT64,
    `weather_data_hours_humidity` FLOAT64,
    `weather_data_hours_dew` FLOAT64,
    `weather_data_hours_precip` FLOAT64,
    `weather_data_hours_precipprob` FLOAT64,
    `weather_data_hours_snow` FLOAT64,
    `weather_data_hours_snowdepth` FLOAT64,
    `weather_data_hours_preciptype` STRING,
    `weather_data_hours_windgust` FLOAT64,
    `weather_data_hours_windspeed` FLOAT64,
    `weather_data_hours_winddir` FLOAT64,
    `weather_data_hours_pressure` FLOAT64,
    `weather_data_hours_visibility` FLOAT64,
    `weather_data_hours_cloudcover` FLOAT64,
    `weather_data_hours_icon` STRING,
    `weather_data_hours_solarradiation` FLOAT64,
    `weather_data_hours_solarenergy` FLOAT64,
    `weather_data_hours_conditions` STRING,
    `weather_data_hours_uvindex` FLOAT64
)
