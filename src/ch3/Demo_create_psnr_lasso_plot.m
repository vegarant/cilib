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
sigma = 0.001;
nbr_of_itr = 10000;

fname = fullfile(dest_data, sprintf('psnr_fista_fourier_sigma_%g_N_%d_itr_%d.mat', sigma, N, nbr_of_itr));
load(fname); % k_values, psnr_arr


fig = figure('visible', disp_plot);

semilogx(2.^k_values, psnr_arr, 'linewidth', cil_dflt.line_width);
%xlabel('\lambda/\sigma', 'FontSize', cil_dflt.font_size);
ylabel('PSNR', 'FontSize', cil_dflt.font_size)
set(gca, 'FontSize', cil_dflt.font_size);
xlim([2^(k_values(1)), 2^(k_values(end))] );
%title1 = sprintf('Shepp-Logan, N %d, max_itr: %d, sigma: %g', ...
%                 N, nbr_of_itr,sigma);
%title(title1);
fname = sprintf('Lasso_PSNR_sigma_%g_N_%d_itr_%05d.eps', sigma, N, nbr_of_itr);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);



