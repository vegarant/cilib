% Creates a bar plot showing for each wavelet scale the percentage of 
% wavelet coefficients having a absolute value greater than epsilon. 
%
% Vegard Antun, 2018
%
clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
if (exist('plots') ~= 7) 
    mkdir('plots');
end

dest = 'plots';
disp_plots = 'off';
dwtmode('per', 'nodisp');

% Parameters
nu = 9;      % 2^nu = signal size
wname = 'Haar';
nres = nu;
eps = .6;

% Dependent parameters
N = 2^(nu);                     % N × N image
fname = sprintf('klubbe_%d.png', N);
fname_desc = fullfile(dest, 'plot_description.txt');
fID =fopen(fname_desc, 'a'); % Write a description of each image to a file
im = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));

ma = max(im(:));
mi = min(im(:));
range = ma-mi;

[c,S] = wavedec2(im, nres, wname);

w = zeros(nres, 1);
for i = 1:nres
    [H1,V1,D1] = detcoef2('all',c,S,nres-i+1);
    A = [H1, V1, D1];
    A = A(:);
    M = length(A);
    w(i) = sum(abs(A) > eps)/M;
end


fig = figure('Visible', disp_plots);
bar(w);
set(gca,'fontsize', cil_dflt.font_size + 5);

fname = fullfile(dest, 'local_sparsity_precentage');

saveas(fig, fname, cil_dflt.plot_format);

fprintf(fID, '%s: %s, N: %d, %s, image range: [%g, %g], epsilon: %g, epsion/range: %g\n', ...
    datestr(datetime('now')), fname, N, wname, mi, ma, eps, eps/range);

fclose(fID);


