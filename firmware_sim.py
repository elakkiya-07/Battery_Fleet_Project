def firmware_energy_integration(can_frames, dt=1):
    energy = 0  # in Wh

    for frame in can_frames:
        # reverse scaling
        voltage = frame["voltage"] / 100.0
        current = frame["current"] / 100.0

        energy += voltage * current * dt / 3600  # convert to Wh

    return energy
