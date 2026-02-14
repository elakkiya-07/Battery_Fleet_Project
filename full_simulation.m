clc;
clear;
close all;

%% Load Dataset
data = readtable('Battery_RUL.csv');

% Convert battery_id to string (important)
data.battery_id = string(data.battery_id);

%% Get unique batteries
batteries = unique(data.battery_id);

for b = 1:length(batteries)

    battery = batteries(b);
    subset = data(data.battery_id == battery, :);

    %% ------------------------------
    % 1️⃣ SIMULATE DISCHARGE ENERGY
    % Physics equation
    E_sim = (subset.disI .* subset.disV .* subset.disT) ./ 3600;

    %% Compare with dataset energy
    E_dataset = subset.dis_energy;

    energy_error = mean(abs(E_sim - E_dataset) ./ E_dataset) * 100;

    %% ------------------------------
    % 2️⃣ SIMULATE INTERNAL RESISTANCE
    % Voc approximation = max discharge voltage of battery
    Voc = max(subset.disV);

    R_sim = (Voc - subset.disV) ./ subset.disI;

    R_dataset = subset.R_internal;

    resistance_error = mean(abs(R_sim - R_dataset) ./ R_dataset) * 100;

    %% ------------------------------
    % Plot Energy Comparison
    figure;
    plot(subset.cycle, E_dataset, 'LineWidth', 2);
    hold on;
    plot(subset.cycle, E_sim, '--', 'LineWidth', 2);
    grid on;
    title("Battery " + battery + " - Discharge Energy Simulation");
    xlabel("Cycle");
    ylabel("Energy (Wh)");
    legend("Dataset", "Simulated");

    %% ------------------------------
    % Plot Resistance Comparison
    figure;
    plot(subset.cycle, R_dataset, 'LineWidth', 2);
    hold on;
    plot(subset.cycle, R_sim, '--', 'LineWidth', 2);
    grid on;
    title("Battery " + battery + " - Internal Resistance Simulation");
    xlabel("Cycle");
    ylabel("Resistance (Ohm)");
    legend("Dataset", "Simulated");

    %% Print Errors
    fprintf('\nBattery %s\n', battery);
    fprintf('Energy Error: %.4f %%\n', energy_error);
    fprintf('Resistance Error: %.4f %%\n', resistance_error);

end
