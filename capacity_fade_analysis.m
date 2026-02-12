clc;
clear;
close all;

%% =============================
%  LOAD DATA
% ==============================

filename = 'cleaned_with_monotonic_resistance.csv';
data = readtable(filename);

%% =============================
%  SELECT BATTERY
% ==============================

batteryID = 'B5';   % Change if needed

subset = data(strcmp(data.battery_id, batteryID), :);

% Sort by cycle
subset = sortrows(subset, 'cycle');

%% =============================
%  EXTRACT VARIABLES
% ==============================

cycles = subset.cycle;
capacity = subset.BCt;   % Battery capacity column

% Remove NaN values
validIdx = ~isnan(capacity);
cycles = cycles(validIdx);
capacity = capacity(validIdx);

%% =============================
%  COMPUTE SOH & FADE
% ==============================

C0 = capacity(1);        % Initial capacity
SOH = capacity / C0;     % Normalized capacity
fade_percent = (1 - SOH) * 100;

%% =============================
%  PLOT RAW CAPACITY
% ==============================

figure;
plot(cycles, capacity, 'LineWidth', 2);
xlabel('Cycle Number');
ylabel('Capacity (Ah)');
title(['Raw Capacity Fade - Battery ', batteryID]);
grid on;

%% =============================
%  PLOT SOH
% ==============================

figure;
plot(cycles, SOH, 'LineWidth', 2);
hold on;
yline(0.8, '--r', '80% EOL');
xlabel('Cycle Number');
ylabel('State of Health (SOH)');
title(['Normalized Capacity (SOH) - Battery ', batteryID]);
grid on;
hold off;

%% =============================
%  PLOT FADE %
% ==============================

figure;
plot(cycles, fade_percent, 'LineWidth', 2);
xlabel('Cycle Number');
ylabel('Capacity Fade (%)');
title(['Capacity Fade Percentage - Battery ', batteryID]);
grid on;

%% =============================
%  PRINT SUMMARY
% ==============================

fprintf('Initial Capacity: %.4f Ah\n', C0);
fprintf('Final Capacity: %.4f Ah\n', capacity(end));
fprintf('Final SOH: %.2f %%\n', SOH(end)*100);
% Create folder if not exists
if ~exist('plots', 'dir')
    mkdir('plots');
end

%% =============================
% SAVE RESULTS INSIDE PROJECT
% ==============================

% Create folders if they don't exist
if ~exist('plots','dir')
    mkdir('plots');
end

if ~exist('results','dir')
    mkdir('results');
end

% ---- Save Figures ----
saveas(1, fullfile('plots', ['Raw_Capacity_', batteryID, '.png']));
saveas(2, fullfile('plots', ['SOH_', batteryID, '.png']));
saveas(3, fullfile('plots', ['Fade_Percentage_', batteryID, '.png']));

% ---- Save Processed Data ----
results = table(cycles, capacity, SOH, fade_percent);

writetable(results, fullfile('results', ...
    ['Capacity_Analysis_', batteryID, '.csv']));

% ---- Save Workspace ----
save(fullfile('results', ...
    ['Workspace_', batteryID, '.mat']));

fprintf('\nAll simulations saved inside project folder successfully.\n');


