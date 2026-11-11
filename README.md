# -GeoPulse-Hyper-Local-Retail-Mobility-Analytics

1. Project Overview

GeoPulse is a geospatial analytics project designed to help retailers make better store-location decisions using anonymized mobile GPS movement data.

Traditional retail location planning often depends on static census data, population density, and assumptions about customer movement. GeoPulse uses location pings collected over time to understand how people move through different areas of a city.

The system processes GPS coordinates, connects them to store catchment areas, calculates hourly footfall, and visualizes movement patterns through an interactive geospatial dashboard.

The main objective is to help a coffee chain identify promising store locations while reducing the risk of cannibalizing traffic from existing stores.

 2. Business Problem

Retailers may select new store locations using population estimates without understanding actual movement patterns.

This can lead to:
- Opening stores in areas with low real footfall.
- Overlapping catchment areas between existing and proposed stores.
- Losing customers from one existing store to another nearby location.
- Missing differences between morning, afternoon, and evening traffic.
- Making expensive real estate decisions without dynamic mobility insights.

GeoPulse aims to address these problems through time-based spatial analysis.

3. Project Objectives

- Generate a synthetic dataset of anonymized GPS pings.
- Store geographic coordinates using Snowflake.
- Create 500-meter store catchment areas.
- Perform spatial joins between GPS pings and store areas using PySpark and Apache Sedona.
- Use dbt to transform spatial results into hourly footfall metrics.
- Identify devices that visit multiple store locations.
- Calculate potential customer overlap and store cannibalization indicators.
- Build an interactive Kepler.gl map with time-based visualizations.
- Automate the daily data pipeline using Apache Airflow.

4. Technology Stack

| Technology | Purpose |
|---|---|
| Python | Data generation and analysis |
| Pandas / NumPy | Synthetic data preparation |
| Snowflake | Geospatial data storage |
| GEOGRAPHY | Geographic point and polygon representation |
| PySpark | Distributed data processing |
| Apache Sedona | Spatial joins and geospatial operations |
| SQL | Spatial analysis and business metrics |
| dbt | Data transformation and testing |
| H3 | Hexagonal spatial aggregation |
| Kepler.gl | Geospatial visualization |
| React | Dashboard frontend |
| Apache Airflow | Pipeline orchestration |
| Git and GitHub | Version control and collaboration |

5. Proposed Project Architecture

1. Data Generation: Generate synthetic GPS pings containing DeviceID, latitude, longitude, and timestamp.
2. Data Ingestion: Load the generated records into Snowflake.
3. Geospatial Preparation: Convert coordinates into geographic point objects and prepare store catchment polygons.
4. Spatial Processing: Use PySpark and Apache Sedona to identify GPS points within store catchment areas.
5. Data Transformation: Use dbt to clean, validate, and aggregate the spatial results.
6. Mobility Analysis: Calculate hourly visitors, unique devices, overlapping visitors, and potential cannibalization.
7. Visualization: Display footfall density, store catchments, and time-based movement in Kepler.gl.
8. Automation: Schedule the pipeline using Apache Airflow.

6. Suggested Repository Structure

```text
GeoPulse-Hyperlocal-Retail-Analytics/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── README.md
│
├── src/
│   ├── generate_gps_data.py
│   ├── generate_store_locations.py
│   └── validate_data.py
│
├── snowflake/
│   ├── create_tables.sql
│   └── load_data.sql
│
├── spatial_processing/
│   ├── create_catchment_areas.py
│   ├── spatial_join.py
│   └── spatial_validation.py
│
├── dbt_geopulse/
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   ├── tests/
│   └── dbt_project.yml
│
├── analytics/
│   ├── hourly_footfall.sql
│   ├── visitor_overlap.sql
│   └── cannibalization_analysis.sql
│
├── dashboard/
│   ├── public/
│   ├── src/
│   └── README.md
│
├── airflow/
│   └── dags/
│       └── geopulse_daily_pipeline.py
│
├── tests/
├── docs/
│   ├── architecture.md
│   ├── data_dictionary.md
│   └── methodology.md
│
├── requirements.txt
├── .gitignore
└── README.md
```

7. Dataset Design

GPS ping dataset

| Column | Description |
|---|---|
| DeviceID | An anonymized synthetic device identifier |
| Latitude | GPS latitude |
| Longitude | GPS longitude |
| Timestamp | Date and time of the location ping |

 location dataset

| Column | Description |
|---|---|
| StoreID | Unique store identifier |
| StoreName | Store name |
| Latitude | Store latitude |
| Longitude | Store longitude |
| StoreType | Existing or proposed store |

Spatial visit dataset

| Column | Description |
|---|---|
| DeviceID | Anonymized device identifier |
| StoreID | Store whose catchment contains the ping |
| Timestamp | Time of the ping |
| DistanceMeters | Distance from the store |
| VisitDate | Date of the observation |
| VisitHour | Hour of the observation |

A GPS ping inside a catchment area is a potential presence observation, not automatically a confirmed store visit or purchase.

8. Week-wise Development Plan

Week 1 – Data Generation and Snowflake Setup

Spatial Data Engineering
- Understand the GPS dataset structure.
- Generate synthetic device IDs, coordinates, and timestamps.
- Simulate movement across selected city areas.
- Generate existing and proposed store locations.
- Validate coordinate ranges and timestamps.

Data Loading
- Create a Snowflake account or use an approved project environment.
- Create a database and schema.
- Create raw GPS and store tables.
- Define GEOGRAPHY columns.
- Load sample GPS data and verify records.

Deliverables
- Synthetic GPS dataset.
- Store location dataset.
- Snowflake table creation scripts.
- Data dictionary.
- Initial data quality report.

Week 2 – Spatial Joins and dbt Modeling

Spatial Data Engineering
- Create 500-meter catchment areas around stores.
- Convert GPS records and store areas into spatial objects.
- Configure PySpark and Apache Sedona.
- Join GPS points to store catchment polygons.
- Validate the spatial join using a small sample before scaling.

Geospatial BI
- Configure dbt with Snowflake.
- Create staging models for GPS and store data.
- Create intermediate models for spatial matches.
- Aggregate unique devices by store and hour.
- Add dbt tests for required fields, unique keys, and valid values.

Mid-Project Review
- Record the number of input GPS points.
- Record the number of spatial matches.
- Check unmatched points.
- Compare morning and evening footfall.
- Document runtime and memory usage for the tested data size.

Deliverables
- Spatial join output.
- dbt models and tests.
- Hourly footfall table.
- Data integrity report.

Week 3 – Cannibalization Analysis and Dashboard

Spatial and Business Analytics
- Identify anonymized devices appearing in multiple store catchments.
- Compare store overlap by date and hour.
- Calculate unique visitor counts for each store.
- Estimate potential overlap between existing and proposed stores.
- Compare morning, afternoon, and evening patterns.

Dashboard Development
- Create a React application.
- Integrate Kepler.gl.
- Load the processed spatial data.
- Display store locations and catchment areas.
- Add hourly filters and a time slider.
- Visualize footfall using H3 hexagons.

Deliverables
- Visitor overlap SQL models.
- Cannibalization analysis.
- React and Kepler.gl prototype.
- Initial mobility dashboard.

Week 4 – Automation and Final Review

Pipeline Automation
- Create an Airflow DAG.
- Schedule GPS ingestion, spatial processing, and dbt transformations.
- Add logging and failure handling.
- Validate pipeline dependencies and reruns.

Dashboard Refinement
- Configure 3D H3 hexagon visualizations.
- Add a 24-hour time slider.
- Improve map legends, filters, and tooltips.
- Validate that dashboard figures match the underlying data.

Final Review
- Run automated tests.
- Capture screenshots.
- Update README and architecture documentation.
- Prepare a project demonstration.
- Explain the spatial join, data model, cannibalization calculation, and dashboard.

Deliverables
- Integrated GeoPulse prototype.
- Automated pipeline.
- Final interactive map.
- Test results.
- Technical documentation.
- Final presentation.

9. Key Business Metrics

| Metric | Meaning |
|---|---|
| Total GPS Pings | Total location observations |
| Unique Devices | Distinct anonymized devices observed |
| Hourly Footfall | Unique devices detected in a store catchment during an hour |
| Catchment Coverage | Number of devices observed within a store's catchment |
| Visitor Overlap | Devices detected in multiple store catchments |
| Potential Cannibalization | Estimated share of a target store's relevant audience that overlaps with an existing store |
| Morning Footfall | Unique devices observed during the defined morning period |
| Evening Footfall | Unique devices observed during the defined evening period |

Important methodology note: Visitor overlap is not proof of cannibalization. A device may pass through multiple areas without visiting either store. A defensible cannibalization estimate needs a clearly defined time window, comparable audience denominator, visit-detection rules, and ideally sales or customer conversion data.

10. Data Privacy and Responsible Use

- Use synthetic or appropriately anonymized location data.
- Do not collect or expose personally identifiable information.
- Avoid attempting to identify individual people from device movement.
- Apply access controls and data retention limits.
- Clearly label simulated results and assumptions.

11. Expected Final Outcome

GeoPulse will provide a reproducible geospatial analytics pipeline that transforms location pings into hourly footfall and store-overlap insights.

The final prototype will allow a retail decision-maker to compare store catchments, inspect footfall patterns across the day, and evaluate whether a proposed store location may overlap with an existing store's audience.

The project is intended as an analytical decision-support prototype. Its outputs should be validated against real visits and sales before being used for actual real-estate investment decisions.

## 12. How to Run the Project

The exact commands depend on the installed tools and configured credentials. The intended execution sequence is:

1. Install Python dependencies from `requirements.txt`.
2. Generate the synthetic GPS and store datasets.
3. Configure Snowflake credentials securely.
4. Create the Snowflake database, schema, and tables.
5. Load the raw datasets.
6. Configure and run the PySpark/Sedona spatial join.
7. Configure dbt profiles and run models and tests.
8. Start the React and Kepler.gl dashboard.
9. Configure and trigger the Airflow DAG.

Do not commit credentials, passwords, private keys, or real personal location data to GitHub.

13. Project Status

This README describes the proposed project design and implementation plan. Update this section as work is completed. Do not mark Snowflake, Sedona, dbt, React, Kepler.gl, or Airflow as implemented until each component has been run and validated.

---

Project: GeoPulse – Hyper-Local Retail Mobility Analytics  
Domain: Retail Strategy and Geospatial Analytics  
Primary Goal: Use time-based mobility patterns to support better retail location decisions.
