import numpy as np

def generate_can_frames(row, dt=1):
    I = row["disI"]
    V_avg = row["disV"]
    C = row["BCt"]

    t_total = (C / I) * 3600
    t = np.arange(0, t_total, dt)

    V_start = V_avg + 0.2
    V_end = V_avg - 0.4
    V = V_start - (V_start - V_end) * (t/t_total)**1.5

    frames = []

    for v in V:
        voltage_scaled = int(v * 100)  # scale to 0.01V
        current_scaled = int(I * 100)  # scale to 0.01A

        frame = {
            "id": 0x100,
            "voltage": voltage_scaled,
            "current": current_scaled
        }

        frames.append(frame)

    return frames
