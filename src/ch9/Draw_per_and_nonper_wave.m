% Draws a wavelet with and without a periodic boundary extension.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end
dest = 'plots/';
disp_plots = 'off';
dwtmode('per', 'nodisp');

p  = 4; % Numer of vanishing moments
r  = 9; % N = 2^r
j0 = 3; % Minimum wavelet decomposition level


nres = r-j0;
N = 2^r;
S = cil_get_wavedec_s(r,nres);
wname = sprintf('db%d', p);

psi = zeros([N,1]);
psi(2^(j0) + p) = 2^(nres/2);
psi = waverec(psi, S, wname);
ub = 2^(nres)*(2*p - 1);
psi = psi(1:ub);
a = 2^nres;

k = 0; % translation

psi = 2^(j0/2)*psi;


fig = figure('visible', disp_plots);
% Left edge
z = zeros([(p+k)*a, 1]);
z(end-(p-1+k)*a:end) = psi(1:(p-1+k)*a+1);
t = linspace(-(p+k)/(2^j0), 0, (p+k)*a);
plot(t, z, 'Color',    [0.79, 0.79, 0.79], ...
                 'LineWidth', cil_dflt.line_width);

% Right edge
hold('on');
z = zeros([(p+1-k)*a, 1]);
z(1:(p-k)*a+1) = psi(end-(p-k)*a:end);
hold('on');
t = linspace(1, 1+(p+1-k)/(2^j0), (p+1-k)*a);
plot(t, z, '-', 'Color', [0.79, 0.79, 0.79], ...
                 'LineWidth', cil_dflt.line_width);

% Plot main wavelet
z = zeros([2^r,1]);
z(1:(p-k)*a) = psi(((p-1+k)*a)+1:end);
z(end-(p-1+k)*a+1:end) = psi(1:(p-1+k)*a);
t = linspace(0,1,2^r);
plot(t, z, 'Color', cil_dflt.line_color,...
           'LineWidth', cil_dflt.line_width);
hold('on');
plot([0,0], [0, z(1)], '--', 'Color', cil_dflt.line_color,...
                       'LineWidth', cil_dflt.line_width);
hold('on');
plot([1,1], [0, z(end)], '--', 'Color', cil_dflt.line_color,...
                         'LineWidth', cil_dflt.line_width);




plot([(-p-k)/2^j0, 1+(p-k+1)/2^j0],[0,0],...
                 'Color',     cil_dflt.line_color, ...
                 'LineWidth', cil_dflt.line_width);


text(0,0.8, '0', 'FontSize', cil_dflt.font_size, 'HorizontalAlignment', 'center' );
text(1,0.8, '1', 'FontSize', cil_dflt.font_size, 'HorizontalAlignment', 'center' );
axis([(-p-k)/2^j0, 1+(p-k+1)/2^j0, -4,5])

set(gca,'xticklabel',{[]}) 
set(gca,'yticklabel',{[]}) 
set(gca,'Visible','off');

xlim([(-p-k)/2^j0, 1+(p-k+1)/2^j0]);
set(gca, 'FontSize', cil_dflt.font_size)
set(gca,'LooseInset',get(gca,'TightInset'));
daspect([1, 15, 1])


fig.PaperUnits = 'inches';
fig.PaperPosition = [0, 0, 6, 2];
fig.PaperSize = [6, 2];
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('per_and_noper_p_%d', p);
print(fullfile(dest, fname),'-depsc','-r0')




