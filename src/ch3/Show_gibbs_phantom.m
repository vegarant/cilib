% Shows the gibbs effect on the GLPU phantom
% Vegard Antun 2019

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

N = 2048;
sfactor = 8;
fname_core = 'phantom_brain';
fname = sprintf('%s_%d.png', fname_core, N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)));

Y = fftshift(fft2(X))/N;
keep  = N/sfactor;
Nh    = N/2;
keeph = keep/2;

idx = (Nh-keeph+1):(Nh+keeph);

Z = zeros([N,N]);
Z(idx,idx) = Y(idx,idx);

im = ifft2(ifftshift(Z))*N;
im = abs(im);

fname = sprintf('gibbs_%s_N_%d_sfact_%d.%s', fname_core, N, sfactor, cil_dflt.image_format);
imwrite(uint8(im), fullfile(dest,fname));

vs = round(N/16);
hs = round(N/2);
v = N/4; 

im_zoom =  im(vs:vs+v-1, hs:hs+v-1);
fname = sprintf('gibbs_%s_N_%d_sfact_%d_zoom.%s', fname_core, N, sfactor, cil_dflt.image_format);
imwrite(uint8(im_zoom), fullfile(dest,fname));

