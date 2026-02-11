def validate(df):
    df["Error_percent"] = abs(df["E_true_Wh"] - df["E_est_Wh"]) / df["E_true_Wh"] * 100
    return df
