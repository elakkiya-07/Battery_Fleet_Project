data = readtable('cleaned_with_monotonic_resistance.csv');

batteries = unique(data.battery_id);

for i = 1:length(batteries)
    battery = batteries{i};
    subset = data(strcmp(data.battery_id, battery), :);

    figure;
    plot(subset.cycle, subset.R_internal_smooth, 'LineWidth', 2);
    grid on;

    title([battery ' - Monotonic Internal Resistance Growth']);
    xlabel('Cycle Number');
    ylabel('Normalized Internal Resistance');
end
