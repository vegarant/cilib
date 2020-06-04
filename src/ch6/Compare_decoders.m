% This script plots the performance of the various decoders. It does not
% perform any computations but reads the data from a file. The original
% experiment is done with CVX. Code is not provided.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

fname_data = 'DATA_comparison_Gaussian_N_64_m_32_s_5_n_trials_50_03-May-2019.mat';
fname_data = fullfile(cil_dflt.data_path, 'ch6_data', fname_data);

load(fname_data)

legend_names = cell(4,1);
for i =1:length(noise_levels)
    legend_names{i} = sprintf('\\sigma = %5.1e', noise_levels(i));
end


min_l = round(log10(param_values_qcbp(1)));
max_l = round(log10(param_values_qcbp(end)));
max_median = max(median_err_qcbp(:));
min_median = min(median_err_qcbp(:));

fig = figure('visible', disp_plots);
loglog(param_values_qcbp, median_err_qcbp,'-','LineWidth', cil_dflt.line_width);
%grid on
legend(legend_names, 'FontSize', cil_dflt.font_size, 'location', 'Southeast');
axis([param_values_qcbp(1), param_values_qcbp(end), 0.8*min_median, 1.2*max_median])
xticks(10.^(min_l+1:max_l-1));
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig, fullfile(dest, 'param_values_qcbp'),'epsc');


min_l = round(log10(param_values_lasso(1)));
max_l = round(log10(param_values_lasso(end)));
max_median = max(median_err_lasso(:));
min_median = min(median_err_lasso(:));

fig = figure('visible', disp_plots);
loglog(param_values_lasso, median_err_lasso, '-', 'LineWidth', cil_dflt.line_width);
legend(legend_names, 'FontSize', cil_dflt.font_size, 'location', 'Southeast');
axis([param_values_lasso(1), param_values_lasso(end), 0.8*min_median, 1.2*max_median])
xticks(10.^(min_l+1:max_l-1));
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig, fullfile(dest, 'param_values_lasso'),'epsc');


min_l = round(log10(param_values_classo(1)));
max_l = round(log10(param_values_classo(end)));
max_median = max(median_err_classo(:));
min_median = min(median_err_classo(:));

fig = figure('visible', disp_plots);
loglog(param_values_classo,median_err_classo,'-','LineWidth', cil_dflt.line_width);

legend(legend_names, 'FontSize', cil_dflt.font_size, 'location', 'Southeast');
axis([param_values_classo(1), param_values_classo(end), 0.8*min_median, 1.2*max_median])
xticks(10.^(min_l+1:max_l-1));
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));

saveas(fig, fullfile(dest, 'param_values_classo'),'epsc');


min_l = round(log10(param_values_srlasso(1)));
max_l = round(log10(param_values_srlasso(end)));
max_median = max(median_err_srlasso(:));
min_median = min(median_err_srlasso(:));

fig = figure('visible', disp_plots);
loglog(param_values_srlasso,median_err_srlasso,'-','LineWidth', cil_dflt.line_width);
legend(legend_names, 'FontSize', cil_dflt.font_size, 'location', 'Southeast');
axis([param_values_srlasso(1), param_values_srlasso(end), 0.8*min_median, 1.2*max_median])
xticks(10.^(min_l+1:max_l-1));
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));

saveas(fig, fullfile(dest, 'param_values_srlasso'),'epsc');


