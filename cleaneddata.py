import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# ==============================
# LOAD DATA
# ==============================

df = pd.read_csv("data/Battery_dataset.csv")

print("Original shape:", df.shape)
print("Batteries found:", df["battery_id"].unique())

# ==============================
# BASIC CLEANING
# ==============================

df = df.drop_duplicates()

# Remove impossible physical values
df = df[(df['chV'] > 3.0) & (df['disV'] > 2.0)]
df = df[(df['chI'] > 0) & (df['disI'] > 0)]
df = df[df['BCt'] > 0]
df = df[df['SOH'] > 0]

# Sort properly
df = df.sort_values(["battery_id", "cycle"]).reset_index(drop=True)

print("After cleaning shape:", df.shape)

# ==============================
# MONOTONIC RESISTANCE MODEL
# ==============================

# Initial capacity per battery
df["Capacity_initial"] = df.groupby("battery_id")["BCt"].transform("first")

# Resistance growth using inverse capacity model
df["R_internal_raw"] = df["Capacity_initial"] / df["BCt"]

# Normalize so first cycle = 1
df["R_internal"] = df.groupby("battery_id")["R_internal_raw"].transform(
    lambda x: x / x.iloc[0]
)

# Smooth (rolling average)
df["R_internal_smooth"] = df.groupby("battery_id")["R_internal"].transform(
    lambda x: x.rolling(window=5, min_periods=1).mean()
)

# ==============================
# CREATE OUTPUT FOLDER
# ==============================

if not os.path.exists("plots"):
    os.makedirs("plots")

# ==============================
# PLOT EACH BATTERY SEPARATELY
# ==============================

for battery in df["battery_id"].unique():

    subset = df[df["battery_id"] == battery]

    plt.figure(figsize=(10, 6))
    plt.plot(
        subset["cycle"],
        subset["R_internal_smooth"],
        linewidth=2
    )

    # Calculate total resistance increase
    total_increase = (
        subset["R_internal_smooth"].iloc[-1] - 1
    ) * 100

    plt.xlabel("Cycle Number")
    plt.ylabel("Normalized Internal Resistance Growth")
    plt.title(f"{battery} - Resistance Growth\nTotal Increase: {total_increase:.2f}%")
    plt.grid(True, alpha=0.3)
    plt.tight_layout()

    # Save image
    plt.savefig(f"plots/{battery}_resistance_growth.png")
    plt.show()

# ==============================
# EXPORT CLEANED DATA
# ==============================

df.to_csv("cleaned_with_monotonic_resistance.csv", index=False)

print("\nAll graphs generated successfully.")
print("Cleaned dataset saved as 'cleaned_with_monotonic_resistance.csv'")
