import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("data/Battery_dataset.csv")

# Estimate Voc as maximum discharge voltage per battery
voc_per_battery = df.groupby("battery_id")["disV"].transform("max")

# Estimate internal resistance
df["R_internal"] = (voc_per_battery - df["disV"]) / df["disI"]

plt.figure(figsize=(10,6))

for battery in df["battery_id"].unique():
    subset = df[df["battery_id"] == battery]
    plt.plot(subset["cycle"], subset["R_internal"], label=battery)

plt.xlabel("Cycle")
plt.ylabel("Estimated Internal Resistance (Ohms)")
plt.title("Estimated Internal Resistance Growth")
plt.legend()
plt.grid()
plt.show()
