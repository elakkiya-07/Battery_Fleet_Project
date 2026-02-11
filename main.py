from ground_truth import compute_ground_truth
from can_simulator import generate_can_frames
from firmware_sim import firmware_energy_integration

def main():
    filepath = "data/Battery_dataset.csv"

    df = compute_ground_truth(filepath)
    print("Total raw rows in dataset:", len(df))
    print("Unique batteries in dataset:", df["battery_id"].unique())
    print("Total unique batteries:", df["battery_id"].nunique())

    results = []

    for _, row in df.iterrows():
        frames = generate_can_frames(row)
        energy_est = firmware_energy_integration(frames)

        results.append({
            "battery_id": row["battery_id"],
            "cycle": row["cycle"],
            "E_true": row["E_true_Wh"],
            "E_est": energy_est
        })

    import pandas as pd
    result_df = pd.DataFrame(results)

    result_df["Error_percent"] = abs(
        result_df["E_true"] - result_df["E_est"]
    ) / result_df["E_true"] * 100

    print("Total rows:", len(result_df))
    print("Unique batteries:", result_df["battery_id"].unique())
    print("Cycles per battery:")
    print(result_df.groupby("battery_id")["cycle"].max())
    print("\nAverage Error:", result_df["Error_percent"].mean(), "%")


if __name__ == "__main__":
    main()
