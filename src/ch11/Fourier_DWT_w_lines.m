% Plot the Fourier-wavelet matrix and visualise the different levels. 

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
dwtmode('per', 'nodisp');

% Parameters
nu = 9; % 2^nu = signal size
vm = 1;
cmap = jet(256);
cmap(end,:) = [0,0,0];

% Dependent parameters
N = 2^(nu);
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);
% Compute Fourier matrix
F = cil_f1_linear(dftmtx(N))/sqrt(N);


% Compute Phi for Haar wavelets
Phi = zeros(N);
I = eye(N);
S = cil_get_wavedec_s(nu, nres);
for i=1:N
    Phi(:,i) = waverec(I(:,i), S, wname);
end
FPhi = F*Phi;

FPhi_abs = abs(FPhi);
im = FPhi_abs;
N = 2^nu;
n_max_value  = -nu;

im = max(log2(FPhi_abs), n_max_value);
im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]
im2 = im; % Make a copy

Mp1 = 0;
st = nu-nres+1;
for k = st:nu+1
    Mk = 2^(k-1);
    Mp2 = 0; % used for j index
    for j = st:nu+1
        Mj = 2^(j-1);
        ma = max(max(im(Mp1+1:Mk, Mp2+1:Mj)));
        im2(Mp1+1:Mk, Mp2+1:Mj) = ma;
        Mp2 = Mj;
    end
    Mp1 = Mk;
end

im = im2uint8(im);
im2 = im2uint8(im2);


im(im==255) = uint8(254);
im2(im2==255) = uint8(254);

for k = 1:nu
    Mk = 2^(k-1) + 1;
    im(Mk, :) = uint8(255);
    im(:, Mk) = uint8(255);
    im2(Mk, :) = uint8(255);
    im2(:, Mk) = uint8(255);
end

fname1 = fullfile(dest, sprintf('Fourier_haar_matrix_w_lines.%s', cil_dflt.image_format));
fname2 = fullfile(dest, sprintf('Fourier_haar_matrix_w_lines_dense.%s', cil_dflt.image_format));
imwrite(im, cmap,fname1);
imwrite(im2, cmap,fname2);




