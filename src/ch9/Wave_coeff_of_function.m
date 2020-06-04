% Computes and display the wavelet coefficents of a function at different 
% wavelet scales

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';
dwtmode('per', 'nodisp');

a = 1/6;
b = 5/11;
c = 9/11;
f1 = @(x) (0.5+4*(x-a)).*(x>=a).*(x<b);
f2 = @(x) (1-4*(x-b).^2).*(x>=b).*(x < c); 
f = @(x) f1(x) + f2(x);


r = 7;
vm = 1;
j0 = 3;
nres = r-j0;
wname = sprintf('db%d', vm);
d = cil_sample_wavelet(f, vm, r);
[c,S] = wavedec(d, nres, wname);
N3 = 2^j0;
N8 = 2^(r-1);
coeff3 = abs(c(N3+1:2*N3));
coeff8 = abs(c(N8+1:2*N8));


fig = figure('visible', disp_plots);
stem(0:N3-1,abs(coeff3), ...
            'Color', cil_dflt.black, ...
            'Marker', cil_dflt.marker, ...
            'MarkerSize', cil_dflt.marker_size, ...
            'MarkerEdgeColor',  cil_dflt.black, ...
            'LineWidth', cil_dflt.line_width);
          
          % 'o','MarkerSize',cil_dflt.marker_size,...
          % 'MarkerEdgeColor', cil_dflt.black, ...
          % 'MarkerFaceColor', cil_dflt.black, ...
          % 'LineWidth', cil_dflt.line_width);

axis('square');
set(gca, 'FontSize', cil_dflt.font_size)
%set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('wave_coeff3_db%d', vm);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

fig = figure('visible', disp_plots);
stem(0:N8-1,abs(coeff8), ...
            'Color', cil_dflt.black, ...
            'Marker', cil_dflt.marker, ...
            'MarkerSize', cil_dflt.marker_size, ...
            'MarkerEdgeColor',  cil_dflt.black, ...
            'LineWidth', cil_dflt.line_width);

xlim([0,N8-1]);
axis('square');
set(gca, 'FontSize', cil_dflt.font_size);
%set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('wave_coeff6_db%d', vm);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

t = linspace(0,1,701);
fig = figure('visible', disp_plots);
plot(t,f(t), cil_dflt.line_color, 'LineWidth', cil_dflt.line_width);
axis('square');
axis([0,1, -0.2, 1.8]);
set(gca, 'FontSize', cil_dflt.font_size);
%set(gca,'LooseInset',get(gca,'TightInset'));
saveas(fig, fullfile(dest, 'picewise_func'), cil_dflt.plot_format);



