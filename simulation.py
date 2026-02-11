import numpy as np

def simulate_energy(row, dt=1):
    I = row["disI"]
    V_avg = row["disV"]
    C = row["BCt"]

    # total discharge time in seconds
    t_total = (C / I) * 3600

    t = np.arange(0, t_total, dt)

    # Nonlinear voltage curve
    V_start = V_avg + 0.2
    V_end = V_avg - 0.4
    V = V_start - (V_start - V_end) * (t / t_total)**1.5

    I_array = np.full_like(t, I)

    E_est = np.sum(V * I_array * dt) / 3600  # Wh

    return E_est


def apply_simulation(df):
    df["E_est_Wh"] = df.apply(simulate_energy, axis=1)
    return df
