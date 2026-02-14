clc;
clear;
close all;

%% =============================
% LOAD DATA
%% =============================
filename = 'cleaned_with_monotonic_resistance.csv';   % change if needed
data = readtable(filename, 'VariableNamingRule','preserve');

vars = data.Properties.VariableNames;

%% =============================
% AUTO-DETECT DEGRADATION COLUMN
%% =============================

% Find capacity-like column
capIdx = find(contains(vars,'BCt','IgnoreCase',true));

if isempty(capIdx)
    capIdx = find(contains(vars,'Discharge','IgnoreCase',true));
end

if isempty(capIdx)
    error('No capacity-like column found.');
end

Q = data.(vars{capIdx});

% Find cycle column
cycleIdx = find(contains(vars,'cycle','IgnoreCase',true));
cycles = data.(vars{cycleIdx});

% Sort properly
[cycles, sortIdx] = sort(cycles);
Q = Q(sortIdx);

%% =============================
% CLEAN DATA (NO AGGRESSIVE MONOTONIC FORCING)
%% =============================

Q = filloutliers(Q,'linear');
Q = movmean(Q,5);  % light smoothing only

%% =============================
% UNIVERSAL MATHEMATICAL MODEL
%% =============================

Q0 = Q(1);

SOH = Q ./ Q0;
fade_percent = (1 - SOH) * 100;

R_norm = Q0 ./ Q;   % inverse relationship

%% =============================
% PLOTS
%% =============================

figure(1);
plot(cycles, Q, 'LineWidth',2);
xlabel('Cycle');
ylabel('Degradation Parameter Q');
title('Raw Degradation Trend');
grid on;

figure(2);
plot(cycles, fade_percent,'LineWidth',2);
xlabel('Cycle');
ylabel('Capacity Fade (%)');
title('Capacity Fade (Universal Model)');
grid on;

figure(3);
plot(cycles, R_norm,'LineWidth',2);
xlabel('Cycle');
ylabel('Normalized Internal Resistance');
title('Resistance Growth (Inverse Model)');
grid on;

%% =============================
% SUMMARY
%% =============================

fprintf('\nInitial Q: %.4f\n',Q0);
fprintf('Final Q: %.4f\n',Q(end));
fprintf('Final SOH: %.2f %%\n',SOH(end)*100);
