% Computes the DWT of an image, randomly permutes the
% coefficients and then computes the inverse DWT
% 
% Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dest = 'plots'
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';
dwtmode('per', 'nodisp');

wave_name = 'db4'; % Using a db4 wavelet
percent = 3; % Number of wavelet coefficents

N = 768;
fname_core = 'donkey';
fname = sprintf('%s_%d.png', fname_core, N);

im = imread(fullfile(cil_dflt.data_path, 'test_images', fname)); % load image
im = im2double(im); 
[n, m] = size(im);
s = round(percent*n*m/100);
fprintf('Sparsity: %d\n', s);

[im_sparse, wave_coef, S] = cil_wavelet_sparsify2d(im, percent/100, wave_name);

% Write im_sparse to file
fname = sprintf('sparse_%s_percent_%02d', fname_core, percent);
idx = im_sparse > 1;
im_sparse(idx) = 1;
imwrite(im2uint8(im_sparse), fullfile(dest, [fname, '.', cil_dflt.image_format]))

% randomly permute sparse wavelet coefficients
wave_coef_perm = cil_flip_wavelet_2d_in_levels(wave_coef, S);

% compute permuted image
im_sparse_perm = waverec2(wave_coef_perm, S, wave_name);
im_out = cil_scale_to_01(im_sparse_perm);
fname = sprintf('sparse_permuted_%s_percent_%02d', fname_core, percent);
imwrite(im2uint8(im_out), fullfile(dest,[fname, '.', cil_dflt.image_format]))


