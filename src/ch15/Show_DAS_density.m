clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

dest = './plots';
% create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end


r = 10;
N = 2^r;
vm = 1;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);

sparsity1 = ones([1, nres]);
sparsity2 = 2.^(-(0:nres-1));

j0 = r - nres;
bv = [];
for i = 1:nres
    bv =[bv, 2^(j0+i)];
end
bh = bv;
a = bv(1:end) - [0, bv(1:end-1)];
b = bh(1:end) - [0, bh(1:end-1)];
max_level_size = a'*b;

density1 = cil_compute_density_DAS_fourier(N, sparsity1, vm);
density2 = cil_compute_density_DAS_fourier(N, sparsity2, vm);
density1 = density1./max_level_size;
density2 = density2./max_level_size;

image1 = cil_visualize_DAS_fourier_density(N, density1);
image2 = cil_visualize_DAS_fourier_density(N, density2);
fname1 = sprintf('DAS_dens_r_%d_db%d_s_const.%s', r, vm, cil_dflt.image_format); 
fname2 = sprintf('DAS_dens_r_%d_db%d_s_exp_decay.%s', r, vm, cil_dflt.image_format); 

image1 = cil_scale_to_01(image1);
image2 = cil_scale_to_01(image2);
imwrite(im2uint8(image1), cil_dflt.cmap_matrix, fullfile(dest, fname1));
imwrite(im2uint8(image2), cil_dflt.cmap_matrix, fullfile(dest, fname2));

vm = 4;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);

sparsity3 = ones([1, nres]);
sparsity4 = 2.^(-(0:nres-1));

j0 = r - nres;
bv = [];
for i = 1:nres
    bv =[bv, 2^(j0+i)];
end
bh = bv;
a = bv(1:end) - [0, bv(1:end-1)];
b = bh(1:end) - [0, bh(1:end-1)];
max_level_size = a'*b;

density3 = cil_compute_density_DAS_fourier(N, sparsity3, vm);
density4 = cil_compute_density_DAS_fourier(N, sparsity4, vm);
density3 = density3./max_level_size;
density4 = density4./max_level_size;

image3 = cil_visualize_DAS_fourier_density(N, density3);
image4 = cil_visualize_DAS_fourier_density(N, density4);
fname3 = sprintf('DAS_dens_r_%d_db%d_s_const.%s', r, vm, cil_dflt.image_format); 
fname4 = sprintf('DAS_dens_r_%d_db%d_s_exp_decay.%s', r, vm, cil_dflt.image_format); 

image3 = cil_scale_to_01(image3);
image4 = cil_scale_to_01(image4);
imwrite(im2uint8(image3), cil_dflt.cmap_matrix, fullfile(dest, fname3));
imwrite(im2uint8(image4), cil_dflt.cmap_matrix, fullfile(dest, fname4));


