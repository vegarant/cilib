% Compute various compressive sensing experiments with different sparsifying transforms. 
% - Walsh & Wavelets
% - Walsh & Shearlets
% - Walsh & TV
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
shearlet_levels = 4;                        % Number of shearlet levels
subsampling_rate = 0.06;                    % ∈ [0,1]
sigma = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma
sigma_tv = 0.1;

N = 1024;
imname = 'dog3';
fname = sprintf('%s_%d.png', imname, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
X = X/255;

nbr_samples = round(subsampling_rate*N*N);

nbr_levels = 50;
radius = 2;
p_norm_exp = 0.5;
a = 2;
r0=2;
[idx, str_id] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm_exp);
% Walsh wavelet
fprintf('Computing Walsh wavelet db%d reconstruction with %s\n', vm, str_id);
fname = sprintf('aWalsh_%s_wavelet_srate_%d_db%d_%s', imname, 100*subsampling_rate, vm, str_id);
rec_wave = cil_sample_walsh_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

% Walsh shearlet
fprintf('Computing Walsh Shearlet reconstruction with %s\n', str_id);
fname = sprintf('aWalsh_%s_shearlet_srate_%d_%s', imname,100*subsampling_rate, str_id);
rec_shear = cil_sample_walsh_shearlet(X, sigma, idx, ...
                         fullfile(dest, fname), shearlet_levels);

% Walsh TV
fprintf('Computing Walsh TV reconstruction with %s\n', str_id);
fname = sprintf('aWalsh_%s_TV_srate_%d_%s', imname,100*subsampling_rate, str_id);
fprintf('Walsh TV reconstruction\n')
rec_TV = cil_sample_walsh_TV(X, sigma_tv, idx, fullfile(dest, fname));

