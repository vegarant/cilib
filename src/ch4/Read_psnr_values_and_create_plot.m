% This script reads PNSR values from file and computes a PSNR values vs 
% sampling rate plot.
%
% To run this fil sucessfully, first run the `Compute_psnr_curve_fourier.m` or 
% `Compute_psnr_curve_walsh.m` files. This will generate data stored 
% in `psnr_data/run{runID}`, where `runID` is an integer spesific for that run.
% To make this script read that data, set the `r_id` below to be the `runID`
% of that run. This script will then create a plot of that run. 
% 
% List of dependent files
% * Compute psnr_curve_fourier.m or Compute_psnr_curve_walsh.m - Need to be run before this script.
% * psnr_data/run{runID}/config_psnr.m - Information about the spesific run and plot options.
% * psnr_data/run{runID}/psnr_{dataID}.mat - The stored PSNR values.
%
% Vegard Antun, 2019

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

r_id = 53; % set this value to the desired `runID`.
disp_plots = 'off';
dest = 'plots';

fprintf('Computing PSNR plots for run %d\n', r_id);

data_full_path = fullfile('psnr_data', sprintf('run%03d', r_id));
run(fullfile(data_full_path, 'config_psnr.m')); % change name to `config_psnr_walsh.m` 
                                                % if this is a Walsh experiment

nbr_patterns = length(str_identifier);
psnr_curves= cell([nbr_patterns, 1]);

for i = 1:nbr_patterns

    fname = sprintf('psnr_%d.mat', i);
    load(fullfile(data_full_path, fname)); 
    psnr_curves{i} = psnr_arr;
end

fig = figure('visible', disp_plots);

for i = 1:nbr_patterns;
    plot(subsampling_rates, psnr_curves{i}, 'linewidth', cil_dflt.line_width, ...
         'Color', color_handles{i}{1}, 'LineStyle', color_handles{i}{2});
    hold('on')
end
legend(str_identifier, 'Interpreter', 'none','location', 'northwest' );
title(sprintf('%s, N: %d', im_name_core, N), 'Interpreter', 'none');

fname = sprintf('psnr_curve_%s_run_%02d', im_name_core, r_id);
saveas(fig, fullfile(dest, [fname, '.png']));


fig = figure('visible', disp_plots);

new_str_id = cell(nbr_patterns,1);

for i = 1:nbr_patterns;
    plot(100*subsampling_rates, psnr_curves{i}, ...
         'linewidth', cil_dflt.line_width, ...
         'Color', color_handles{i}{1}, ...
         'LineStyle', color_handles{i}{2});
    new_str_id{i} = sprintf('Strategy %d', i);
    hold('on')
end
xlabel('Subsampling rate', 'FontSize', cil_dflt.font_size);
ylabel('PSNR', 'FontSize', cil_dflt.font_size);
set(gca, 'FontSize', cil_dflt.font_size);
legend(new_str_id, 'location', 'northwest', 'Fontsize', cil_dflt.font_size);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);


