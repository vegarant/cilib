% Plot the absolute value of various matrices at log scale.
% - Fourier matrix * inverse DWT Haar matrix
% - Fourier matrix * inverse DWT DB4 matrix
% It also plot the colorbar.
% Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';
dwtmode('per', 'nodisp');

% Parameters
nu = 9; % 2^nu = signal size
cmap = jet(256);

% Dependent parameters
N = 2^(nu);

% Compute Fourier matrix
F = cil_f1_linear(dftmtx(N))/sqrt(N);
%F = fftshift(F,1);


% Compute Phi for Haar wavelets
Phi = zeros(N);
I = eye(N);
S = cil_get_wavedec_s(nu, wmaxlev(N,'Haar')-1);
for i=1:N
    Phi(:,i) = waverec(I(:,i), S, 'Haar');
end
FPhi = F*Phi;

FPhi_abs = abs(FPhi);
N = 2^nu;
n_max_value  = -nu;
im = max(log2(FPhi_abs), n_max_value);
im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]

fname = fullfile(dest, sprintf('Fourier_haar_matrix.%s', cil_dflt.image_format));
imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);

% Compute Phi for DB6 wavelets
Phi = zeros(N);
I = eye(N);

wname = 'db4';
S = cil_get_wavedec_s(nu, wmaxlev(N, wname));
for i=1:N
    Phi(:,i) = waverec(I(:,i), S, wname);
end
FPhi = F*Phi;

FPhi_abs = abs(FPhi);
im = max(log2(FPhi_abs), n_max_value);
im = (im - n_max_value)/(-n_max_value);
fname = fullfile(dest, sprintf('Fourier_%s_matrix.%s', wname, cil_dflt.image_format));
imwrite(im2uint8(im), cil_dflt.cmap_matrix, fname);

% Save colorbar
m = round(256/10);
a = linspace(1,0,256)';
im = repmat(a, 1, m);

fname = fullfile(dest, sprintf('colorbar_fourier_dwt.%s', cil_dflt.image_format));
imwrite(im2uint8(im), cil_dflt.cmap_matrix, fname); 




