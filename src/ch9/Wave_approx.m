% Computes the best N term wavelet approximation of a function for two 
% different wavelets and plot the corresponding functions. 


clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';
dwtmode('per', 'nodisp');

p1  = 1; % Numer of vanishing moments
p2  = 4; % Numer of vanishing moments
r  = 6; % N = 2^r


a = 1/6;
b = 5/11;
c = 9/11;
f1 = @(x) (0.5+4*(x-a)).*(x>=a).*(x<b);
f2 = @(x) (1-4*(x-b).^2).*(x>=b).*(x < c); 
f = @(x) f1(x) + f2(x);

d1 = cil_sample_wavelet(f,p1,r);
d2 = cil_sample_wavelet(f,p2,r);

M = 2^r;
N = 2^(r+3);
A1 = get_scaling_matrix_per(p1,N,M);
A2 = get_scaling_matrix_per(p2,N,M);

t = linspace(0,1,N);

fig = figure('visible', disp_plots);
plot(t,A1*d1, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
%axis([0,1, -0.2, 1.8]);
set(gca, 'FontSize', cil_dflt.font_size)
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('approx_db%d_V_%d', p1, r);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

fig = figure('visible', disp_plots);
plot(t,A2*d2, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
%axis([0,1, -0.2, 1.8]);
set(gca, 'FontSize', cil_dflt.font_size)
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('approx_db%d_V_%d', p2, r);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);


