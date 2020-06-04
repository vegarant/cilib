clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

dest = './plots';
% create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end

r = 9;
N = 2^r;
subsampling_ratio = 0.14;
nbr_samples = round(subsampling_ratio*N*N);
epsilon = 0.6;

im = phantom(N);
vm = 1;
nres = wmaxlev(N, sprintf('db%d', vm));
sparsities = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
[idx1, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities, vm);
[idx2, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities, vm);
fname1 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DAS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);
fname2 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DIS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);


vm = 2;
nres = wmaxlev(N, sprintf('db%d', vm));
sparsities = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
[idx3, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities, vm);
[idx4, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities, vm);
fname3 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DAS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);
fname4 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DIS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);

vm = 4;
nres = wmaxlev(N, sprintf('db%d', vm));
sparsities = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
[idx5, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities, vm);
[idx6, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities, vm);
fname5 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DAS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);
fname6 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DIS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);

vm = 6;
nres = wmaxlev(N, sprintf('db%d', vm));
sparsities = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
[idx7, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities, vm);
[idx8, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities, vm);
fname7 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DAS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);
fname8 = sprintf('fig_13_5_N_%d_srate_%d_db%d_DIS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);


Z1 = zeros([N,N], 'uint8');
Z2 = zeros([N,N], 'uint8');
Z3 = zeros([N,N], 'uint8');
Z4 = zeros([N,N], 'uint8');
Z5 = zeros([N,N], 'uint8');
Z6 = zeros([N,N], 'uint8');
Z7 = zeros([N,N], 'uint8');
Z8 = zeros([N,N], 'uint8');

Z1(idx1) = uint8(255);
Z2(idx2) = uint8(255);
Z3(idx3) = uint8(255);
Z4(idx4) = uint8(255);
Z5(idx5) = uint8(255);
Z6(idx6) = uint8(255);
Z7(idx7) = uint8(255);
Z8(idx8) = uint8(255);

imwrite(Z1, fullfile(dest,fname1));
imwrite(Z2, fullfile(dest,fname2));
imwrite(Z3, fullfile(dest,fname3));
imwrite(Z4, fullfile(dest,fname4));
imwrite(Z5, fullfile(dest,fname5));
imwrite(Z6, fullfile(dest,fname6));
imwrite(Z7, fullfile(dest,fname7));
imwrite(Z8, fullfile(dest,fname8));


