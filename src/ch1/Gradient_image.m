% Description: Computes the gradient image of the boat image
% Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';
N = 256;
fname_core = 'peppers';
fname = sprintf('%s_%d.png', fname_core, N);

im = imread(fullfile(cil_dflt.data_path, 'test_images', fname)); % load image
X = im2double(im); 

H = fspecial('sobel');

Y1 = imfilter(X,H, 'symmetric');
Y2 = imfilter(X,H', 'symmetric');

Y = max(abs(Y1), abs(Y2));

fname = sprintf('%s_gradient.%s', fname_core, cil_dflt.image_format); 
imwrite(im2uint8(Y), fullfile(dest, fname)); 

