% Computes a wavelet approximation to the phantom image using different
% wavelets.
clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';
dwtmode('per', 'nodisp');

N = 2048; % High resulution image
j = 7;
Ns = 2^j;
im = phantom(N);

wname1 = 'db1';
wname2 = 'db4';

nres1 = wmaxlev(N, wname1);  % Maximum wavelet decomposition level
nres2 = wmaxlev(N, wname2);  % Maximum wavelet decomposition level
nres = min(nres1, nres2);

[wcoeff1, S1] = wavedec2(im, nres, wname1);
[wcoeff2, S2] = wavedec2(im, nres, wname2);

w1 = cil_wave_ord_2d_image(wcoeff1, S1, wname1);
w2 = cil_wave_ord_2d_image(wcoeff2, S2, wname2);

% Zero out the fine scale wavelet coefficients.
w1(Ns+1:N, 1:N) = 0;
w1(1:Ns, Ns+1:N) = 0;

w2(Ns+1:N, 1:N) = 0;
w2(1:Ns, Ns+1:N) = 0;

approx1 = cil_wave_ord_2d_leveled(w1, S1);
approx1 = waverec2(approx1, S1, wname1);

approx2 = cil_wave_ord_2d_leveled(w2, S2);
approx2 = waverec2(approx2, S2, wname2);

L = round(2^9.5);
a = N/2 - L/2+1;

crop_im = im(a:a+L, a:a+L);
crop_approx1 = approx1(a:a+L, a:a+L);
crop_approx2 = approx2(a:a+L, a:a+L);

ma = max(crop_im(:));

idx1 = crop_approx1 > ma;
idx2 = crop_approx2 > ma;

crop_approx1(idx1) = ma;
crop_approx2(idx2) = ma;

fname_orig = sprintf('phantom_orig_crop.%s', cil_dflt.image_format); 
fname_w1 = sprintf('phantom_%s_j_%d_crop.%s', wname1, j, cil_dflt.image_format); 
fname_w2 = sprintf('phantom_%s_j_%d_crop.%s', wname2, j, cil_dflt.image_format); 

imwrite(im2uint8(crop_im), fullfile(dest, fname_orig));
imwrite(im2uint8(crop_approx1), fullfile(dest, fname_w1));
imwrite(im2uint8(crop_approx2), fullfile(dest, fname_w2));

