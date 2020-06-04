% Plots the activaction functions

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

M = 5;
xtic = [-M,-2.5,0,2.5,M];
t = linspace(-M,M,101);


fig = figure('visible', disp_plots);
plot(t, t.*(t>0), 'linewidth', cil_dflt.line_width, 'color', cil_dflt.black);
xticks(xtic);
set(gca, 'FontSize', cil_dflt.font_size+5);
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig,fullfile(dest, 'act_relu'), cil_dflt.plot_format);


fig = figure('visible', disp_plots);
plot(t, 1./(1+exp(-t)), 'linewidth', cil_dflt.line_width, 'color', cil_dflt.black);
xticks(xtic);
set(gca, 'FontSize', cil_dflt.font_size+5);
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig,fullfile(dest, 'act_sigmoid'), cil_dflt.plot_format);


fig = figure('visible', disp_plots);
plot(t, tanh(t), 'linewidth', cil_dflt.line_width, 'color', cil_dflt.black);
xticks(xtic);
set(gca, 'FontSize', cil_dflt.font_size+5);
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig,fullfile(dest, 'act_tanh'), cil_dflt.plot_format);


fig = figure('visible', disp_plots);
plot(t, t.*(t>0) + 0.2.*t.*(t<0), 'linewidth', cil_dflt.line_width, 'color', cil_dflt.black);
xticks(xtic);
set(gca, 'FontSize', cil_dflt.font_size+5);
set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig,fullfile(dest, 'act_lrelu'), cil_dflt.plot_format);



