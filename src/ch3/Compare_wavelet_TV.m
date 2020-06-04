% Show a comparison between a wavelet and TV reconstruction on
% a MR brain image.
%
% Vegard Antun 2019

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


subsampling_rate = 0.15;                    % ∈ [0,1]
noise = 1e-2;                                % min ||x||_1 s.t. ||Ax-b||_2 ≤ noise
noise_tv = 1e-5;

N = 512;
%N = 836;
fname = sprintf('brain1_%d.png', N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));

nbr_samples = round(subsampling_rate*N*N);

% Create sampling pattern
%sparsities = cil_compute_sparsity_of_image(phantom(N), vm); 
%[idx, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities, vm);

a = 1;
r0 = 2;
nbr_levels = 50;
[idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);

wname = 'db4';
nres = 4;
sigma = 0.001;
noise_parameter = sqrt(nbr_samples)*sigma;
measurement_noise = sigma*randn(nbr_samples, 1) + 1j*sigma*randn(nbr_samples, 1);

l = 150;
lh= l/2;
v = 100;
h = 100;
idx_v = v:v+lh-1;
idx_h = h:h+l-1;

% Fourier TV
fprintf('Computing TV reconstruction\n');
fname = sprintf('aFourier_TV_N_%d_srate_%g_%s', N, subsampling_rate*100, str_id);
fname_tv_zoom = sprintf('aFourier_TV_N_%d_srate_%g_%s_zoom', N, subsampling_rate*100, str_id);
fprintf('Fourier TV reconstruction\n')
[im_rec2, z] = cil_sample_fourier_TV(X, sqrt(nbr_samples)*sigma, idx, fullfile(dest, fname), 'measurement_noise', measurement_noise);

imwrite(im_rec2(idx_v, idx_h), fullfile(dest,[fname_tv_zoom, '.', cil_dflt.image_format]));


% Fourier wavelet
fprintf('Computing wavelet reconstruction\n');
fname = sprintf('aFourier_wavelet_N_%d_srate_%g_db%d_%s',N, subsampling_rate*100, vm, str_id);
fname_wave_zoom =sprintf('aFourier_wavelet_N_%d_srate_%g_db%d_%s_zoom',N, subsampling_rate*100, vm, str_id); 
[im_rec1, z] = cil_sample_fourier_wavelet(X, sqrt(nbr_samples)*sigma, idx, fullfile(dest, fname), vm, 'measurement_noise', measurement_noise);
imwrite(im_rec1(idx_v, idx_h), fullfile(dest,[fname_wave_zoom, '.', cil_dflt.image_format]));

