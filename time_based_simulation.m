clc;
clear;
close all;

%% ===============================
% LOAD DATASET
%% ===============================

filename = 'Battery_RUL.csv';  % change here
data = readtable(filename, 'VariableNamingRule','preserve');

vars = data.Properties.VariableNames;

% Detect degradation parameter (capacity-like)
capIdx = find(contains(vars,'BCt','IgnoreCase',true));
if isempty(capIdx)
    capIdx = find(contains(vars,'Discharge','IgnoreCase',true));
end

Q = data.(vars{capIdx});

% Detect cycle
cycleIdx = find(contains(vars,'cycle','IgnoreCase',true));
cycles = data.(vars{cycleIdx});

% Sort
[cycles, sortIdx] = sort(cycles);
Q = Q(sortIdx);

%% ===============================
% CONVERT CYCLE TO TIME
%% ===============================

% If discharge time exists, use it
timeIdx = find(contains(vars,'disT','IgnoreCase',true));

if ~isempty(timeIdx)
    disT = data.(vars{timeIdx});
    disT = disT(sortIdx);
    t = cumsum(disT);  % cumulative operating time
else
    % If no time column, assume 1 unit per cycle
    t = cycles;
end

%% ===============================
% UNIVERSAL MODEL
%% ===============================

Q = filloutliers(Q,'linear');
Q = movmean(Q,5);

Q0 = max(Q);

SOH = Q ./ Q0;
fade_percent = (1 - SOH) * 100;
R_norm = Q0 ./ Q;

%% ===============================
% PLOTS
%% ===============================

figure;
plot(t, Q,'LineWidth',2);
xlabel('Time');
ylabel('Capacity Parameter Q');
title('Dataset Capacity vs Time');
grid on;

figure;
plot(t, fade_percent,'LineWidth',2);
xlabel('Time');
ylabel('Capacity Fade (%)');
title('Dataset Capacity Fade vs Time');
grid on;

figure;
plot(t, R_norm,'LineWidth',2);
xlabel('Time');
ylabel('Normalized Internal Resistance');
title('Inverse Resistance Growth vs Time');
grid on;
%% =============================
% SAVE TIME-BASED SIMULATION FIGURES
% ==============================

% Create plots folder if it doesn't exist
if ~exist('plots','dir')
    mkdir('plots');
end

% Save all open figures automatically
figs = findall(0,'Type','figure');

for i = 1:length(figs)
    filename = fullfile('plots', ...
        ['TimeModel_Figure_', num2str(i), '.png']);
    saveas(figs(i), filename);
end

fprintf('Time-based simulation plots saved successfully.\n');

