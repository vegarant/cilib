% Plot the Fourier transform of a Daubechies wavelet.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
dwtmode('per', 'nodisp');

disp_plots = 'off';

r = 9;
N = 2^r;
vm = 4;
j0 = 4;
nres = r - j0;
wname = sprintf('db%d', vm);
S = cil_get_wavedec_s(r,nres);

fig = figure('visible', disp_plots);

ma = 0;
t = -N/2+1:N/2;
labels = cell(3,1);
for j = 1:3

    c = zeros([N,1]);
    c(2^(j0+j)+4) = 2^(nres/2);
    z = waverec(c, S, wname);
    z = fftshift(fft(z))/sqrt(N);   
    z = abs(z);
    ma = max(max(z(:)), ma);
    
    plot(t, z, 'linewidth', cil_dflt.line_width);
    hold('on');
    labels{j} = sprintf('j = %d', j);
end
ma = 1.0606*ma;

color_gray = [0.5, 0.5, 0.5];
for j = 0:3;

    s = 2^(j0+j);
    plot([s, s], [0,ma], '--', 'linewidth', cil_dflt.line_width, ...
                                    'color', color_gray, 'HandleVisibility', 'off');
    hold('on');
    plot([-s+1, -s+1], [0,ma], '--', 'linewidth', cil_dflt.line_width, ...
                                    'color', color_gray, 'HandleVisibility', 'off');
    hold('on');

end

legend(labels, 'FontSize', cil_dflt.font_size);
ylim([0,ma]);

set(gca, 'YMinorTick', 'off');
set(gca, 'YMinorGrid', 'off');
set(gca, 'YGrid', 'on');
set(gca, 'XGrid', 'on');
set(gca, 'YTick', []);
set(gca, 'XTick', []);

fname = sprintf('Fourier_transform_%s_wavelet', wname);
saveas(fig, fullfile(dest, fname), cil_dflt.plot_format);

