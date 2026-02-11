import pandas as pd

def compute_ground_truth(filepath):
    df = pd.read_csv(filepath)

    # True discharge energy (Wh)
    df["E_true_Wh"] = df["BCt"] * df["disV"]

    return df
