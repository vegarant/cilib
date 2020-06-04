% This script read the array produced by `Compute_psnr_lasso_lambda.m`
% and creates a plot of it.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

% create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
dest_data = 'data';
if (exist(dest_data) ~= 7) 
    mkdir(dest_data);
end
N = 2^8;
disp_plot = 'off';
sigma_val = [0.1, 0.01, 0.001]; 
nbr_of_itr = 10000;

fig = figure('visible', disp_plot);
n = length(sigma_val);
lstyles = {'-', '--', ':', '-.'};
labels = cell(n,1);
% Create black and white image
for i = 1:n

    sigma = sigma_val(i);
    
    fname = fullfile(dest_data, sprintf('psnr_fista_fourier_sigma_%g_N_%d_itr_%d.mat', sigma, N, nbr_of_itr));
    load(fname); % k_values, psnr_arr
    labels{i} = sprintf('\\sigma = %g', sigma);
    semilogx(2.^k_values, psnr_arr, 'LineWidth', cil_dflt.line_width, ...
             'color', cil_dflt.black, 'linestyle', lstyles{i});
    hold('on');

end
legend(labels, 'FontSize', cil_dflt.font_size, 'Location', 'northwest');
ylabel('PSNR', 'FontSize', cil_dflt.font_size);
set(gca, 'FontSize', cil_dflt.font_size);
xlim([2^(k_values(1)), 2^(k_values(end))] );
fname = sprintf('Lasso_PSNR_N_%d_itr_%05d_bw.eps', N, nbr_of_itr);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

fig = figure('visible', disp_plot);
% Create color image
for i = 1:n

    sigma = sigma_val(i);
    
    fname = fullfile(dest_data, sprintf('psnr_fista_fourier_sigma_%g_N_%d_itr_%d.mat', sigma, N, nbr_of_itr));
    load(fname); % k_values, psnr_arr
    labels{i} = sprintf('\\sigma = %g', sigma);
    semilogx(2.^k_values, psnr_arr, 'LineWidth', cil_dflt.line_width);
    hold('on');

end
legend(labels, 'FontSize', cil_dflt.font_size, 'Location', 'northwest');
ylabel('PSNR', 'FontSize', cil_dflt.font_size);
set(gca, 'FontSize', cil_dflt.font_size);
xlim([2^(k_values(1)), 2^(k_values(end))] );
fname = sprintf('Lasso_PSNR_N_%d_itr_%05d.eps', N, nbr_of_itr);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);


