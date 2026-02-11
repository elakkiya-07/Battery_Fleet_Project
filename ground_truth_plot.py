import pandas as pd
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv("data/Battery_dataset.csv")

# Compute true discharge energy
df["E_true_Wh"] = df["BCt"] * df["disV"]

# Plot energy vs cycle
plt.figure(figsize=(10,6))

for battery in df["battery_id"].unique():
    subset = df[df["battery_id"] == battery]
    plt.plot(subset["cycle"], subset["E_true_Wh"], label=battery)

plt.xlabel("Cycle")
plt.ylabel("True Discharge Energy (Wh)")
plt.title("Ground Truth Energy Degradation")
plt.legend()
plt.grid()
plt.show()