% Compute various compressive sensing experiments with different binary sampling
% operators and wavelet reconstruction. 
% - Circulant & Wavelet
% - Scramble Walsh & Wavelet
% - Walsh & Wavelets, Gauss multilevel circle sampling pattern
% - Walsh & Wavelets, Gauss multilevel l^(1/2) sampling pattern
% - Walsh & Wavelets, two level l^(infty) sampling pattern 
%
% Vegard Antun 2019
%
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

vm = 4;                                     % Number of vanishing moments
subsampling_rate = 0.06;                    % ∈ [0,1]
max_iterations = 3000;
noise = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ noise
N = 1024;
nbr_samples = round(subsampling_rate*N*N);

fname_core = 'dog3';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
X = X/255;

% Circular convolution
fprintf('Computing circular convolution sampling with  wavelet db%d reconstruction\n', vm);
fname = sprintf('aCircular_wavelet_%s_srate_%d_db%d',fname_core, 100*subsampling_rate, vm);
[im_rec, z] = cil_sample_circulant_wavelet(X, nbr_samples, noise, fullfile(dest,fname), vm, 'spgl1_iterations', max_iterations);


% Scrambeled walsh
[idx, str_id] = cil_sp2_uniform(N, nbr_samples);
fprintf('Computing scrambled Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_scramble_wavelet_%s_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id);
cil_sample_scramble_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);

% Walsh wavelet, gauss l=2
nbr_levels = 50;
r0 = 1;
a = 2;
[idx, str_id] = cil_sph2_gcircle(N, nbr_samples, a, r0, nbr_levels);
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_wavelet_%s_srate_%d_db%d_%s',fname_core, 100*subsampling_rate, vm, str_id);
cil_sample_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);

% Walsh wavelet, gauss l=0.5
nbr_levels = 50;
radius = 2;
p_norm_exp = 0.5;
a = 2;
r0=2;
[idx, str_id] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm_exp);
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_wavelet_%s_srate_%d_db%d_%s',fname_core, 100*subsampling_rate, vm, str_id);
cil_sample_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);

% Walsh wavelet, 2 level
r_factor = 4;
p_norm = inf;
[idx, str_id] = cil_sph2_2level(N, nbr_samples, p_norm, r_factor);
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_wavelet_%s_srate_%d_db%d_%s', fname_core, 100*subsampling_rate, vm, str_id);
cil_sample_walsh_wavelet(X, noise, idx, fullfile(dest, fname), vm, 'spgl1_iterations', max_iterations);
