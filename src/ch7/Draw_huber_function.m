clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots/';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';

bd = 1;
t = linspace(-bd,bd,101);

fig = figure('visible', disp_plots);


mus = {0.2, 0.4, 0.8};
linestyle = {'-.', ':', '--'};
str_legend = cell(4,1);


lstyle = '-';
str_legend{1} = '$\quad|x|$';

plot(t,abs(t), cil_dflt.line_color,...
             'LineWidth', cil_dflt.line_width, ...
             'LineStyle', lstyle);

for i = 1:length(mus)

    mu = mus{i};
    lstyle = linestyle{i};
    str_legend{i+1} = sprintf('$ \\mu = %g$', mu);
    
    S = @(x) (1/(2*mu)).*(x.*x).*(abs(x) <= mu) + (abs(x) - 0.5*mu).*(abs(x)>mu);

    hold('on');
    plot(t,S(t), cil_dflt.line_color,...
                 'LineWidth', cil_dflt.line_width, ...
                 'LineStyle', lstyle);

end
axis([-bd, bd, -0.1*bd,bd]);
legend(str_legend,'Location', 'North', 'interpreter','latex',...
       'FontSize', cil_dflt.font_size);

set(gca, 'FontSize', cil_dflt.font_size);



fname = sprintf('huber_function');
%fname = strrep(fname, '.', '_');
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

