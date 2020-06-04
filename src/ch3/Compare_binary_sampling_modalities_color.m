% This script requires that you have a color image.
% It compute a reconstructed image using circular convolutions, 
% scrambled Walsh and Walsh sampling

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

path_to_this_file = mfilename('fullpath');
path_to_this_file = path_to_this_file(1:end-length(mfilename)-1);
dest = fullfile(path_to_this_file, 'plots');

% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';

vm = 4;                                     % Number of vanishing moments
subsampling_rate = 0.06;                    % ∈ [0,1]
max_iterations = 3000;
noise = 0.01;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ noise
N = 1024;
nbr_samples = round(subsampling_rate*N*N);
wname = sprintf('db%d', vm);

fname_core = 'dog3';
fname = sprintf('%s_%d.png', fname_core, N);
fname = 'dog_color_1024.png';
X1 = imread('dog_color_1024.png');
X = double(X1);
X = X/255;

Xr = X(:,:,1);
Xg = X(:,:,2);
Xb = X(:,:,3);


nres = wmaxlev(N, wname);   % Maximum wavelet decomposition level
S = cil_get_wavedec2_s(round(log2(N)), nres);

% Walsh wavelet, gauss l=2
nbr_levels = 50;
r0 = 1;
a = 2;
[idx, str_id] = cil_sph2_gcircle(N, nbr_samples, a, r0, nbr_levels);
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_wavelet_%s_srate_%d_db%d_%s',fname_core, 100*subsampling_rate, vm, str_id);
%cil_sample_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_r, zr] = cil_sample_walsh_wavelet(Xr, noise, idx, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_g, zg] = cil_sample_walsh_wavelet(Xg, noise, idx, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_b, zb] = cil_sample_walsh_wavelet(Xb, noise, idx, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);

im_rec_r = waverec2(zr, S, wname);
im_rec_g = waverec2(zg, S, wname);
im_rec_b = waverec2(zb, S, wname);

im_rec_r = cil_cut_values(im_rec_r, 0, 1);
im_rec_g = cil_cut_values(im_rec_g, 0, 1);
im_rec_b = cil_cut_values(im_rec_b, 0, 1);

im_rec = zeros(N,N,3);
im_rec(:,:, 1) = 255*im_rec_r;
im_rec(:,:, 2) = 255*im_rec_g;
im_rec(:,:, 3) = 255*im_rec_b;
imwrite(uint8(im_rec), fullfile(dest,[fname, '.png']));

% Circular convolution
fprintf('Computing circular convolution sampling with  wavelet db%d reconstruction\n', vm);
fname = sprintf('aCircular_wavelet_%s_srate_%d_db%d',fname_core, 100*subsampling_rate, vm);
[im_rec_r, zr] = cil_sample_circulant_wavelet(Xr, nbr_samples, noise, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_g, zg] = cil_sample_circulant_wavelet(Xg, nbr_samples, noise, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_b, zb] = cil_sample_circulant_wavelet(Xb, nbr_samples, noise, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);

im_rec_r = waverec2(zr, S, wname);
im_rec_g = waverec2(zg, S, wname);
im_rec_b = waverec2(zb, S, wname);

im_rec_r = cil_cut_values(im_rec_r, 0, 1);
im_rec_g = cil_cut_values(im_rec_g, 0, 1);
im_rec_b = cil_cut_values(im_rec_b, 0, 1);

im_rec = zeros(N,N,3);
im_rec(:,:, 1) = 255*im_rec_r;
im_rec(:,:, 2) = 255*im_rec_g;
im_rec(:,:, 3) = 255*im_rec_b;
imwrite(uint8(im_rec), fullfile(dest,[fname, '.png']));

 Scrambeled walsh
[idx, str_id] = cil_sp2_uniform(N, nbr_samples);
fprintf('Computing scrambled Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_scramble_wavelet_%s_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id);
[im_rec_r, zr] = cil_sample_scramble_walsh_wavelet(Xr, noise, idx, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_g, zg] = cil_sample_scramble_walsh_wavelet(Xg, noise, idx, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);
[im_rec_b, zb] = cil_sample_scramble_walsh_wavelet(Xb, noise, idx, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);

im_rec_r = waverec2(zr, S, wname);
im_rec_g = waverec2(zg, S, wname);
im_rec_b = waverec2(zb, S, wname);

im_rec_r = cil_clip_values(im_rec_r, 0, 1);
im_rec_g = cil_clip_values(im_rec_g, 0, 1);
im_rec_b = cil_clip_values(im_rec_b, 0, 1);

im_rec = zeros(N,N,3);
im_rec(:,:, 1) = 255*im_rec_r;
im_rec(:,:, 2) = 255*im_rec_g;
im_rec(:,:, 3) = 255*im_rec_b;
imwrite(uint8(im_rec), fullfile(dest,[fname, '.png']));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








%% Walsh wavelet, gauss l=0.5
%nbr_levels = 50;
%radius = 2;
%p_norm_exp = 0.5;
%a = 2;
%r0=2;
%[idx, str_id] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm_exp);
%fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
%fname = sprintf('aWalsh_wavelet_%s_srate_%d_db%d_%s',fname_core, 100*subsampling_rate, vm, str_id);
%cil_sample_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);
%
%% Walsh wavelet, 2 level
%r_factor = 4;
%p_norm = inf;
%[idx, str_id] = cil_sph2_2level(N, nbr_samples, p_norm, r_factor);
%fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
%fname = sprintf('aWalsh_wavelet_%s_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id);
%cil_sample_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);
