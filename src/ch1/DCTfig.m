% Computes the discrete cosine transform of a sparse vector and
% plots it
% 
% Ben Adcock, Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';

% Parameters
nu = 6; % 2^nu = signal size

% Dependent parameters
N = 2^(nu);

% construct sparse vector x
x = zeros(N,1);
supp = [12 ; 16 ; 32 ; 40 ; 128 ; 200 ]/4;
x(supp) = randn(size(supp));

% plot x
fig1 = figure('Visible', disp_plots);
ms = 8;
lw = 2;
t = x;
t(x==0) = NaN;
stem(t, 'Marker', cil_dflt.marker, ...
        'MarkerSize',cil_dflt.marker_size,...
        'MarkerEdgeColor', cil_dflt.marker_edge_color, ...
        'Color',  [0,0,0], ...  %cil_dflt.color, ...
        'LineWidth', cil_dflt.line_width);

xlim([1,N+1]);
ymax = max(abs(x))*1.1;
ylim([-ymax,ymax]);

saveas(fig1, fullfile(dest, 'sparse_x'), cil_dflt.plot_format);

% plot sinusoid
fig2 = figure('Visible', disp_plots);

y = dct(x)/sqrt(N);
stem(y, 'Marker', cil_dflt.marker, ...
        'MarkerSize',cil_dflt.marker_size,...
        'MarkerEdgeColor', cil_dflt.marker_edge_color, ...
        'Color',  [0,0,0], ...  %cil_dflt.color, ...
        'LineWidth', cil_dflt.line_width);

xlim([1,N+1]);
ymax = max(abs(y))*1.1;
ylim([-ymax,ymax]);

saveas(fig2, fullfile(dest, 'sparse_cos'), cil_dflt.plot_format);




