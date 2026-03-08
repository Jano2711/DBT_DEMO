WITH daily_weather as (

select date(time) as daily_weather,
weather,
temp,
pressure,
humidity,
clouds
from 
{{ source('demo', 'weathertable') }}

),

daily_weather_agg as (
select
daily_weather,
weather,
ROUND(avg(temp),2) avg_temp,
ROUND(avg(pressure),2) avg_pressure,
ROUND(avg(humidity),2) avg_humidity,
ROUND(avg(clouds),2) avg_cloud

from daily_weather
group by daily_weather, weather

qualify ROW_NUMBER() OVER (PARTITION BY daily_weather ORDER BY count(weather) desc) = 1
)


select * from daily_weather_agg