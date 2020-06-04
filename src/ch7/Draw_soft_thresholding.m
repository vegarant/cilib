clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots/';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';
dwtmode('per', 'nodisp');

th = 1;
S = @(z) sign(z).*(abs(z) - th).*(abs(z) >= th); 

bd = 2;

t = linspace(-bd,bd,101);

fig = figure('visible', disp_plots);


plot(t,S(t), cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

axis([-bd, bd, -bd+th,bd-th]);

set(gca, 'FontSize', cil_dflt.font_size);

fname = sprintf('soft_thresholding_tau_%d', th);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);
