% This script produces two images. (1) It stores an image of the wavelet transformed
% image and (2) it produces an image compressed by only storing X percent of the 
% wavelet coefficients. 
% Edvard Aksnes July 2017, Vegard Antun 2020

clear('all'); close('all');
load('cilib_defaults')

dest = 'plots';
% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end

dwtmode('per', 'nodisp');

wname='db4';

N = 768;
fname_core = 'donkey';
fname = sprintf('%s_%d.png', fname_core, N);
% Load image
im = im2double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));

percent = 5; 
keep_fraction = percent/100; % percent of wavelet coefficients to be retained

% Create sparse version of the image.
[im_sparse, wave_coef, S] = cil_wavelet_sparsify2d(im, keep_fraction, wname);

% Order the wavelet coefficients as a square
O = cil_wave_ord_2d_image(wave_coef, S, wname);
O = abs(O);

O(O>1) = 1;

fname = sprintf('wavelet_coef_%s_percent_%02d.%s' , fname_core, percent, cil_dflt.image_format);
imwrite(im2uint8(O),fullfile(dest, fname) );

fname = sprintf('sparsified_%s_percent_%02d.%s' , fname_core, percent, cil_dflt.image_format);
imwrite(im2uint8(im_sparse), fullfile(dest, fname) );

