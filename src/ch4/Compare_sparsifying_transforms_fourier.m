% Computes a compressive sensing reconstruction with Fourier sampling and 
% three different sparsifying priors. 
% - Fourier & TV
% - Fourier & Wavelets
% - Fourier & Shearlets
% - Fourier & Curvelets
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

disp_plots = 'off';

vm = 4;                                     % Number of vanishing moments
curvelet_is_real = 0;                       % 0 => Complex valued curvelets
shearlet_levels = 4;                        % Number of shearlet levels
subsampling_rate = 0.15;                    % ∈ [0,1]
sigma = 0.001;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma
is_real = 0;
max_iterations = 1000;

N = 512;
fname_core = 'brain1';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
%X = X/255;

nbr_samples = round(subsampling_rate*N*N);
measurement_noise = sigma*randn(nbr_samples, 1) + 1j*sigma*randn(nbr_samples, 1);


a = 1;
r0 = 2;
nbr_levels = 50;
% Create sampling pattern
[idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);

% Crop region
l = 150;
lh= l/2;
v = 100;
h = 100;
idx_v = v:v+lh-1;
idx_h = h:h+l-1;

% Fourier TV
fprintf('Computing TV reconstruction\n');
fname = sprintf('aFourier_%s_TV_srate_%d_%s', fname_core,100*subsampling_rate, str_id);
fprintf('Fourier TV reconstruction\n')
[rec_tv, z] = cil_sample_fourier_TV(X, sqrt(nbr_samples)*sigma, idx, fullfile(dest, fname), 'measurement_noise', measurement_noise);

imwrite(im2uint8(rec_tv(idx_v, idx_h)), fullfile(dest,[fname, '_zoom.', cil_dflt.image_format]));

% Fourier Curvelet
fprintf('Computing Fourier Curvelet reconstruction with %s\n', str_id);
fname = sprintf('aFourier_%s_curvelet_srate_%d_%s', fname_core,100*subsampling_rate, str_id);
fprintf('Fourier Curvelet reconstruction\n')
rec_curvelet = cil_sample_fourier_curvelet(X, sqrt(nbr_samples)*sigma, idx, fullfile(dest, fname),...
                   is_real, 'spgl1_iterations', max_iterations, 'measurement_noise', measurement_noise);
imwrite(im2uint8(rec_curvelet(idx_v, idx_h)), fullfile(dest,[fname, '_zoom.', cil_dflt.image_format]));

% Fourier wavelet
fprintf('Computing Fourier wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aFourier_%s_wavelet_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id);
rec_wave = cil_sample_fourier_wavelet(X, sqrt(nbr_samples)*sigma, idx, fullfile(dest, fname), vm,...
               'spgl1_iterations', max_iterations, 'measurement_noise', measurement_noise);
imwrite(im2uint8(rec_wave(idx_v, idx_h)), fullfile(dest,[fname, '_zoom.', cil_dflt.image_format]));

% Fourier shearlet
fprintf('Computing Fourier Shearlet reconstruction with %s\n', str_id);
fname = sprintf('aFourier_%s_shearlet_srate_%d_%s', fname_core,100*subsampling_rate, str_id);
rec_shear = cil_sample_fourier_shearlet(X, sqrt(nbr_samples)*sigma, idx, ...
                         fullfile(dest, fname), shearlet_levels, ...
                         'spgl1_iterations', max_iterations, 'measurement_noise', measurement_noise);
imwrite(im2uint8(rec_shear(idx_v, idx_h)), fullfile(dest,[fname, '_zoom.', cil_dflt.image_format]));

