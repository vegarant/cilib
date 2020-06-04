% This script read the files produced by Compare_sparsifying_transforms_binary.m
% crop out the same part of the image in all the tree reconstructions and create 
% an image containing these three crops + a crop of the orignal image.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

vm = 4;                                     % Number of vanishing moments
subsampling_rate = 0.06;                    % ∈ [0,1]

N = 1024;
fname_core = 'dog3';
fname = sprintf('%s_%d.png',fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));
X = X/255;
cil_dflt.image_format = 'png';

v = 206;
vs = 210;
hs = 550;
idx_v = vs:vs+v-1;
idx_h = hs:hs+v-1;


str_id = 'h_exp0_5';
fname1 = fullfile(cil_dflt.data_path, 'test_images', sprintf('%s_%d.png',fname_core, N));
fname2 = fullfile(dest, sprintf('aBernoulli_%s_db%d_wavelet.%s', fname_core, vm, cil_dflt.image_format ));
fname3 = fullfile(dest, sprintf('aWalsh_%s_wavelet_srate_%d_db%d_%s.%s',fname_core, 100*subsampling_rate, vm, str_id, cil_dflt.image_format ));
fname4 = fullfile(dest, sprintf('aWalsh_%s_shearlet_srate_%d_%s.%s', fname_core,100*subsampling_rate, str_id, cil_dflt.image_format ));
fname5 = fullfile(dest, sprintf('aWalsh_%s_TV_srate_%d_%s.%s', fname_core, 100*subsampling_rate, str_id, cil_dflt.image_format));

str_id1 = 'uniform';
fname6 = fullfile(dest, sprintf('aWalsh_%s_db%d_wavlet_%s.%s', fname_core, vm, str_id1, cil_dflt.image_format));
 
fnames = {fname1, fname3, fname4, fname5}; 
text = {'Original', 'Wavelet', 'Shearlet', 'TV'}; 

im = cil_create_crop_image(fnames, text, idx_v, idx_h, cil_dflt.font_size);
fname_out = sprintf('aWalsh_%s_srate_%d_%s_crop.%s', fname_core, 100*subsampling_rate, str_id, cil_dflt.image_format);
imwrite(im, fullfile(dest, fname_out));

