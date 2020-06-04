% Plot a discrete and continous version of a function

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';


f = @(x) (x.*x+1).*cos(2*pi*x);


N = 32;
dx = 1/N;

pixle = linspace(0, 1-1/N, N);


% Continuous function
t = linspace(0,1, 8*N);
a = f(t);
ma = max(a(:));
mi = min(a(:));
f_pix = f(pixle);

b = zeros([2*N, 1]);
b(1:2:2*N) = f_pix;
b(2:2:2*N) = f_pix;
b_xbar = zeros([2*N, 1]);

b_xbar(1) = pixle(1);
b_xbar(2:2:2*N-1) = pixle(2:N);
b_xbar(3:2:2*N) = pixle(2:N);
b_xbar(2*N) = 1;

fig = figure('visible', disp_plots);
plot(t, a, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
axis([0,1, mi - sign(mi)*0.1*mi, ma+sign(ma)*0.1*ma]);
set(gca, 'FontSize', cil_dflt.font_size);
fname = sprintf('cont_func_N_%d_true', N);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

% Discrete pixel values
fig = figure('visible', disp_plots);
stem(0:N-1, f_pix, ...
           'Color', cil_dflt.black, ...
           'Marker', cil_dflt.marker, ...
           'MarkerSize', cil_dflt.marker_size, ...
           'MarkerEdgeColor', cil_dflt.black, ...
           'LineWidth', cil_dflt.line_width);
axis('square');
axis([-1,N, mi - sign(mi)*0.1*mi, ma+sign(ma)*0.1*ma]);
set(gca, 'FontSize', cil_dflt.font_size);
fname = sprintf('cont_func_N_%d_bar_plot', N);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

% Discrete image
fig = figure('visible', disp_plots);
plot(b_xbar, b, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');

axis([0,1, mi - sign(mi)*0.1*mi, ma+sign(ma)*0.1*ma]);
set(gca, 'FontSize', cil_dflt.font_size); 
fname = sprintf('cont_func_N_%d_discete', N);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);



