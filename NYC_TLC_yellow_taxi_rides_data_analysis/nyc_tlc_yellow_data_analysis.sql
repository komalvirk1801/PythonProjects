SELECT * FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset` LIMIT 100;


select data_file_year as trip_year from `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`;


-- STEP 1: Count trips per year (2019-2023)
SELECT 
  data_file_year as trip_year, COUNT(*) AS total_trips
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
GROUP BY trip_year
ORDER BY trip_year;


-- STEP 2: Monthly average trip distance
SELECT 
  data_file_month AS trip_month,
  AVG(trip_distance) AS avg_distance
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
GROUP BY trip_month
ORDER BY trip_month;

-- STEP 3: Revenue metrics (avg fare, tip, total amount)
SELECT 
  data_file_year AS year,
  ROUND(AVG(fare_amount), 2) AS avg_fare,
  ROUND(AVG(tip_amount), 2) AS avg_tip,
  ROUND(AVG(total_amount), 2) AS avg_total
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
GROUP BY year
ORDER BY year;


-- STEP 4: Tipping behavior by hour
SELECT 
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  ROUND(AVG(tip_amount / NULLIF(total_amount, 0)) * 100, 2) AS avg_tip_pct
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
WHERE total_amount > 0
GROUP BY hour
ORDER BY hour;

------------------------
--- Peak Hour & Location Demand
--Objective: Identify surge times and high-demand pickup/drop-off zones.


SELECT 
  EXTRACT(HOUR FROM pickup_datetime) AS hour,
  pickup_location_id,
  COUNT(*) AS total_trips
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
GROUP BY hour, pickup_location_id
ORDER BY total_trips DESC
LIMIT 50;

-- STEP 5: Rolling 7-day average of trips
WITH daily_trips AS (
  SELECT 
    DATE(pickup_datetime) AS trip_date,
    COUNT(*) AS daily_count
  FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
  GROUP BY trip_date
)
SELECT 
  trip_date,
  daily_count,
  ROUND(AVG(daily_count) OVER (ORDER BY trip_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS rolling_avg
FROM daily_trips
ORDER BY rolling_avg desc;

-- STEP 6: Detect outliers - extreme distances
SELECT *
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
WHERE trip_distance > 100
ORDER BY trip_distance DESC
LIMIT 100;

-- STEP 7: Tip % by day of week
WITH tip_data AS (
  SELECT 
    FORMAT_DATE('%A', DATE(pickup_datetime)) AS day_of_week,
    ROUND(AVG(tip_amount / NULLIF(total_amount, 0)) * 100, 2) AS avg_tip_pct
  FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
  WHERE total_amount > 0
  GROUP BY day_of_week
)
SELECT *
FROM tip_data
ORDER BY 
  CASE day_of_week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;


--STEP 8: TRIP DURATION AND SPEED ANALYSIS
--Objective: Spot unusual rides or inefficiencies.

SELECT 
  pickup_datetime,
  dropoff_datetime,
  TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS duration_sec,
  trip_distance,
  SAFE_DIVIDE(trip_distance, TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND)/3600.0) AS avg_speed_mph
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
WHERE trip_distance > 0 AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) > 0
ORDER BY avg_speed_mph DESC
LIMIT 100;

--STEP 9: Zero or Negative Fare Anomalies
-- Objective: Clean and explain financial outliers.

SELECT *
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
WHERE fare_amount <= 0 OR total_amount <= 0
ORDER BY fare_amount;

--STEP 10: Passenger Count & Ride-Sharing Behavior
--Objective: Understand usage patterns (solo vs group).
SELECT 
  passenger_count,
  COUNT(*) AS num_trips,
  ROUND(AVG(trip_distance), 2) AS avg_distance
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
GROUP BY passenger_count
ORDER BY passenger_count;

-- 11. Revenue Lost to Cash Payments (Payment Type Analysis)
--Objective: Estimate cash vs card behavior and tipping behavior by payment type.


SELECT 
  payment_type,
  COUNT(*) AS total_trips,
  ROUND(AVG(tip_amount), 2) AS avg_tip,
  ROUND(AVG(total_amount), 2) AS avg_total
FROM `data-analysis-project-463906.nyc_taxi_sql_project.merged-taxi-dataset`
GROUP BY payment_type
ORDER BY total_trips DESC;

