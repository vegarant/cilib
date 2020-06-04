% Display the approximation of a function in the spaces V_{j+1}, V_j and W_j.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';
dwtmode('per', 'nodisp');

p  = 1; % Numer of vanishing moments
r  = 6; % N = 2^r
j0 = 3; % Minimum wavelet decomposition level

a = 1/6;
b = 5/11;
c = 9/11;
f1 = @(x) (0.5+4*(x-a)).*(x>=a).*(x<b);
f2 = @(x) (1-4*(x-b).^2).*(x>=b).*(x < c); 
f = @(x) f1(x) + f2(x);

d1 = cil_sample_wavelet(f,p,r);
d2 = cil_sample_wavelet(f,p,r-1);

c2 = wavedec(d1, 1, 'Haar');
c2 = c2(2^(r-1)+1:2^r); % Extract wavelet coefficients.

M1 = 2^r;
N = 2^(r+3);
M2 = 2^(r-1);
A1 = get_scaling_matrix_per(p,N,M1);
A2 = get_scaling_matrix_per(p,N,M2);

% Compute wavelet approximation.
s = 2^((r-1)/2);
a = N/M2;
idx1 = 1:a/2;
idx2 = a/2+1:a;
w = zeros([N,1]);
for k = 1:M2
    w((k-1)*a + idx1) = s*c2(k);
    w((k-1)*a + idx2) = -s*c2(k);
end

t = linspace(0,1,N);

fig = figure('visible', disp_plots);
plot(t,A1*d1, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
axis([0,1, -0.2, 1.8]);
%xlabel(sprintf('$V_{j+1}$', p), 'FontSize',  cil_dflt.font_size, 'Interpreter', 'latex');
set(gca, 'FontSize', cil_dflt.font_size);
fname = sprintf('approx_w_Vjp1_db%d_V_%d', p, r);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

fig = figure('visible', disp_plots);
plot(t,A2*d2, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
axis([0,1, -0.2, 1.8]);
%xlabel(sprintf('$V_{j}$', p), 'FontSize',  cil_dflt.font_size, 'Interpreter', 'latex');
set(gca, 'FontSize', cil_dflt.font_size);
fname = sprintf('approx_w_Vj_db%d_V_%d', p, r-1);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

fig = figure('visible', disp_plots);
plot(t,w, cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
%xlabel(sprintf('$W_{j}$', p), 'FontSize',  cil_dflt.font_size, 'Interpreter', 'latex');
set(gca, 'FontSize', cil_dflt.font_size);
fname = sprintf('approx_w_Wj_db%d_W_%d', p, r-1);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);


