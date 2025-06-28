# 🗽 NYC TLC Yellow Taxi Rides Data Analysis (2019–2022)

## Overview  
This project analyzes New York City’s Yellow Taxi rides from 2019 to 2022 using BigQuery for data processing and Looker Studio for interactive dashboard visualization. The objective is to uncover urban mobility trends, passenger behavior, revenue patterns, and operational anomalies across time.

## Objectives  
- Analyze trip volume trends by year, month, and hour.

 - Measure tip percentages and tipping behavior by hour and day.

- Track average fare, total revenue, and trip distances.

- Identify peak demand zones, surge hours, and payment type behavior.

- Detect outlier rides (e.g., very long trips, negative fares).

- Visualize rolling 7-day averages for smoother trend analysis.

## Tools & Technologies
- SQL (BigQuery)

- Google Looker Studio (Data Studio)

## Dataset: tlc_yellow_trips_2019, 2020, 2021, 2022 (merged via BigQuery)

### Dataset Source
Public Dataset: NYC TLC Yellow Taxi Trips (2019–2022)
Fields: 
pickup_datetime, dropoff_datetime, trip_distance, fare_amount, tip_amount, total_amount, payment_type, passenger_count, pickup_location_id  

## Dashboard Highlights (Looker Studio)
### Page 1: Trip & Revenue Trends
- Yearly Trip Volume 
- Monthly Average Trip Distance 
- Fare, Tip, and Total Amount Trends
- Average Tip per Rate Code
- Trip duration and Speed
- Payment type Impact

### Page 2: Behavior & Anomalies  
- Tip % by Hour 
- Tip % by Day of Week
- Revenue Distribution by Vendor
- Average Surcharge over Time
- Average Surge behavior in a day
- Contribution to Total fare

## Key Insights
- Trip volume dropped drastically in 2020 due to COVID-19, but gradually recovered.
- Card payments result in higher tipping than cash.
- Evening hours (7–9 PM) show peak tipping behavior.
- Outliers like negative fares, >100 mile trips, and low-speed long rides were detected and flagged for quality control.
