"""
Generate synthetic GPS ping data for the GeoPulse Hyderabad project.

Output columns:
    DeviceID, Latitude, Longitude, Timestamp

Install dependencies:
    pip install pandas numpy

Run:
    python generate_geopulse_gps.py
"""
import numpy as np
import pandas as pd

SEED = 42
N_PINGS = 50_000
N_DEVICES = 5_000

STORES = [
    ("ST001", 17.4156, 78.4347),
    ("ST002", 17.4310, 78.4075),
    ("ST003", 17.4483, 78.3915),
    ("ST004", 17.4474, 78.3762),
    ("ST005", 17.4602, 78.3677),
    ("ST006", 17.4401, 78.3489),
    ("ST007", 17.4448, 78.4670),
    ("ST008", 17.4375, 78.4483),
    ("ST009", 17.4218, 78.3374),
    ("ST010", 17.4052, 78.3858),
]

rng = np.random.default_rng(SEED)
store_coords = np.array([(lat, lon) for _, lat, lon in STORES])

device_ids = np.array([f"DEV{i:05d}" for i in range(1, N_DEVICES + 1)])
ping_devices = rng.choice(device_ids, size=N_PINGS, replace=True)

cluster_choice = rng.choice(len(STORES), size=N_PINGS)
centers = store_coords[cluster_choice]
clustered = rng.random(N_PINGS) < 0.82

lat = np.empty(N_PINGS)
lon = np.empty(N_PINGS)
lat[clustered] = centers[clustered, 0] + rng.normal(0, 0.0025, clustered.sum())
lon[clustered] = centers[clustered, 1] + rng.normal(0, 0.0025, clustered.sum())

background_count = (~clustered).sum()
lat[~clustered] = rng.uniform(17.36, 17.49, background_count)
lon[~clustered] = rng.uniform(78.30, 78.50, background_count)

lat = np.clip(lat, 17.34, 17.51)
lon = np.clip(lon, 78.29, 78.51)

start = pd.Timestamp("2026-10-01 00:00:00", tz="Asia/Kolkata")
end = pd.Timestamp("2026-10-08 00:00:00", tz="Asia/Kolkata")
offset_seconds = rng.integers(0, int((end - start).total_seconds()), size=N_PINGS)
timestamps = start + pd.to_timedelta(offset_seconds, unit="s")

df = pd.DataFrame({
    "DeviceID": ping_devices,
    "Latitude": np.round(lat, 6),
    "Longitude": np.round(lon, 6),
    "Timestamp": timestamps.strftime("%Y-%m-%dT%H:%M:%S%z"),
})
df["Timestamp"] = df["Timestamp"].str.replace(
    r"(\+)(\d{2})(\d{2})$", r"\1\2:\3", regex=True
)
df = df.sort_values("Timestamp").reset_index(drop=True)

output_file = "GeoPulse_Hyderabad_Synthetic_GPS_Pings.csv"
df.to_csv(output_file, index=False)
print(f"Created {len(df):,} GPS pings: {output_file}")
print(f"Unique devices: {df['DeviceID'].nunique():,}")
print(f"Latitude range: {df['Latitude'].min()} to {df['Latitude'].max()}")
print(f"Longitude range: {df['Longitude'].min()} to {df['Longitude'].max()}")
