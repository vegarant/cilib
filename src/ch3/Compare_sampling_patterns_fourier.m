% Figure 3.5
% Description: Perform a CS-experiment with various sampling fourier sampling
% patterns 
% - Multilevel gaussian pattern 
% - 2 level
% - uniformly random
%
% Vegard Antun 2019
%

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
dwtmode('per', 'nodisp');

disp_plots = 'off';

vm = 4;                                     % Number of vanishing moments
subsampling_rate = 0.05;                    % ∈ [0,1]
sigma = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma


N = 2048;
N_print = 512;
fname_core = 'phantom_brain';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
xs = 780;
ys = 1470;
lx = 256;
ly = 256;
idx_crop_x = xs:xs+lx-1;
idx_crop_y = ys:ys+ly-1;

nbr_samples = round(subsampling_rate*N*N);
nbr_samples_print = round(subsampling_rate*N_print*N_print);

r0 = 2;
a = 1;
nbr_levels = 100;
[idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels); 

% Fourier wavelet
fprintf('Computing wavelet reconstruction %s\n', str_id);
fname = sprintf('aFourier_comp_patt_N_%d_srate_%g_db%d_%s', N, subsampling_rate*100, vm, str_id);
[im_rec, wcoeff] = cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

im_crop = im_rec(idx_crop_x, idx_crop_y);
filename = fullfile(dest, [fname, '_crop.', cil_dflt.image_format]);
imwrite(im2uint8(im_crop), filename);

[idx, str_id] = cil_spf2_gcircle(N_print, nbr_samples_print, a, r0, nbr_levels); 
Z = zeros(N_print,N_print, 'uint8');
Z(idx) = uint8(255);
imwrite(Z, fullfile(dest, [fname, '_samp.', cil_dflt.image_format]));


% Fourier Wavelet uniformly random
[idx, str_id] = cil_sp2_uniform(N, nbr_samples);
fprintf('Computing wavelet reconstruction %s\n', str_id);
fname = sprintf('aFourier_comp_patt_N_%d_srate_%g_db%d_%s', N, subsampling_rate*100, vm, str_id);
[im_rec, wcoeff] = cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

im_crop = im_rec(idx_crop_x, idx_crop_y);
filename = fullfile(dest, [fname, '_crop.', cil_dflt.image_format]);
imwrite(im2uint8(im_crop), filename);

[idx, str_id] = cil_sp2_uniform(N_print, nbr_samples_print);
Z = zeros(N_print,N_print, 'uint8');
Z(idx) = uint8(255);
imwrite(Z, fullfile(dest, [fname, '_samp.', cil_dflt.image_format]));


%% Fourier wavelet
p_norm = 2;
r_factor = 4;
[idx, str_id] = cil_spf2_2level(N, nbr_samples, p_norm, r_factor);
fprintf('Computing wavelet reconstruction %s\n', str_id);
fname = sprintf('aFourier_comp_patt_N_%d_srate_%g_db%d_%s', N, subsampling_rate*100, vm, str_id);
[im_rec, wcoeff] = cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

im_crop = im_rec(idx_crop_x, idx_crop_y);
filename = fullfile(dest, [fname, '_crop.', cil_dflt.image_format]);
imwrite(im2uint8(im_crop), filename);

[idx, str_id] = cil_spf2_2level(N_print, nbr_samples_print, p_norm, r_factor);
Z = zeros(N_print,N_print, 'uint8');
Z(idx) = uint8(255);
imwrite(Z, fullfile(dest, [fname, '_samp.', cil_dflt.image_format]));


