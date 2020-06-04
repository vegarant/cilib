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
subsampling_rate = 0.03;                    % ∈ [0,1]
sigma = 1;                                  % min ||x||_1 s.t. ||Ax-b||_2 ≤ sigma

N = 512;
fname_core = 'peppers';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));

nbr_samples = round(subsampling_rate*N*N);

alpha_values = {1,2,3};

for i = 1:length(alpha_values)

    alpha = alpha_values{i};
    [idx, str_id] = cil_spf2_power_law(N, nbr_samples, alpha);

    % Fourier wavelet
    fprintf('Computing wavelet reconstruction alpha = %g\n', alpha);
    fname = sprintf('aFourier_%s_srate_%g_db%d_%s', ...
                    fname_core, subsampling_rate*100, vm, str_id);
    cil_sample_fourier_wavelet(X, sigma, idx, fullfile(dest, fname), vm);

end

