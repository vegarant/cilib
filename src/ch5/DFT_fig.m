% Plot the absolute value of the discrete Fourier transform of a sparse vector.
% 
% Ben Adcock, Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

path_to_this_file = mfilename('fullpath');
path_to_this_file = path_to_this_file(1:end-length(mfilename)-1);
dest = fullfile(path_to_this_file, 'plots');

% Create destination for the plots
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
supp = [16 ; 19 ; 32; 38; 50; 55 ];
x(supp) = randn(size(supp));

% plot x
fig1 = figure('Visible', disp_plots);
ms = 8;
lw = 2;
t = x;
t(x==0) = NaN;
stem(t, 'Marker', cil_dflt.marker, ...
        'MarkerSize',cil_dflt.marker_size,...
        'MarkerEdgeColor', cil_dflt.black, ...
        'Color', cil_dflt.black, ...
        'LineWidth', cil_dflt.line_width);
           %'MarkerFaceColor', cil_dflt.marker_face_color, ...
xlim([1,N+1]);
ymax = max(abs(x))*1.1;
ylim([-ymax,ymax]);

set(gca, 'FontSize', cil_dflt.font_size);

saveas(fig1, fullfile(dest, 'sparse_x'), cil_dflt.plot_format);

% plot sinusoid
fig2 = figure('Visible', disp_plots);

y = abs(fft(x)/sqrt(N));
stem(y, 'Marker', cil_dflt.marker, ...
        'MarkerSize',cil_dflt.marker_size,...
        'MarkerEdgeColor', cil_dflt.black, ...
        'Color', cil_dflt.black, ...
        'LineWidth', cil_dflt.line_width);

xlim([1,N+1]);
ymax = max(abs(y))*1.1;
ylim([0,ymax]);

set(gca, 'FontSize', cil_dflt.font_size);

saveas(fig2, fullfile(dest, 'sparse_dft'), cil_dflt.plot_format);




