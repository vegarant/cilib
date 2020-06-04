% Plots the Daubechies wavelet and scaling function for p = 1,2,3,4

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';
dwtmode('per', 'nodisp');

p  = 2;
r  = 9;
j0 = 4;

for p = 2:4
    nres = r-j0;
    N = 2^r;
    S = cil_get_wavedec_s(r,nres);
    wname = sprintf('db%d', p);
    
    % Compute an approximation to wavelets using the cascade algorithm.
    % Note that we commit the wavelet crime at this point.
    
    phi = zeros([N,1]);
    phi(p) = 2^(nres/2);
    phi = waverec(phi, S, wname);
    psi = zeros([N,1]);
    psi(2^(j0) + p) = 2^(nres/2);
    psi = waverec(psi, S, wname);
    ub = 2^(nres)*(2*p - 1);
    
    fig = figure('visible', disp_plots);
    plot(linspace(0, 2*p-1,ub), phi(1:ub), cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width);
    set(gca, 'FontSize', cil_dflt.font_size);
    xlim([0, 2*p-1]);
    fname = sprintf('wave_phi%d', p);
    saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);
    
    
    fig = figure('visible', disp_plots);
    plot(linspace(-p+1, p,ub), psi(1:ub), cil_dflt.line_color, ...
         'LineWidth', cil_dflt.line_width);
    set(gca, 'FontSize', cil_dflt.font_size);
    xlim([-p+1, p]);
    fname = sprintf('wave_psi%d', p);
    saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);
end


% Draw Haar wavelet and scaling function


fig = figure('visible', disp_plots);

t = linspace(0,1,101);
z = ones(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)
hold('on');

t = linspace(-0.5,0,101);
z = zeros(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

hold('on');
t = linspace(1,1.5,101);
z = zeros(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

plot([0,0],[0,1], '--', 'Color', cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

plot([1,1],[0,1], '--', 'Color', cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)
axis([-0.5, 1.5, -0.2,1.2]);

set(gca, 'FontSize', cil_dflt.font_size);
%set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('wave_phi%d', 1);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

fig = figure('visible', disp_plots);

t = linspace(0,0.5,101);
z = ones(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)
hold('on');

t = linspace(0.5,1,101);
z = -ones(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

hold('on');
t = linspace(-0.5,0,101);
z = zeros(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

hold('on');
t = linspace(1,1.5,101);
z = zeros(size(t));
plot(t,z, cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

plot([0,0],[0,1], '--', 'Color', cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)

plot([0.5,0.5],[-1,1], '--', 'Color', cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)
plot([1,1],[-1,0], '--', 'Color', cil_dflt.line_color,...
         'LineWidth', cil_dflt.line_width)
axis([-0.5, 1.5, -1.2,1.25]);

set(gca, 'FontSize', cil_dflt.font_size);
%set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('wave_psi%d', 1);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);



