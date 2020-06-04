% Applies a 2d wavelet transform to an image and writes the result to file.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';
dwtmode('per', 'nodisp');

N = 512;

fname_core = 'phantom_brain';
im_name = sprintf('%s_%d.%s', fname_core, N, cil_dflt.image_format);
im = double(imread(fullfile(cil_dflt.data_path, 'test_images', im_name)));

im = imresize(im, [N,N]);

vm = 2;
wname = sprintf('db%d', vm);

nres = 3;
[C, S] = wavedec2(im, nres, wname);
wave_coeff = abs(cil_wave_ord_2d_image(C, S, wname));
wave_coeff = (wave_coeff - min(wave_coeff(:)))/(max(wave_coeff(:)) - min(wave_coeff(:)));

out_im = im2uint8(wave_coeff.^(1/3));
fname = sprintf('wavelet_scales_2d_db%d.%s', vm, cil_dflt.image_format);
imwrite(out_im, fullfile(dest, fname));


