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
subsampling_ratio = 0.13;
nbr_samples = round(subsampling_ratio*N*N);

vm = 1;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);

epsilon = .9;
im = phantom(N);
sparsities = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
[idx1, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities, vm);
[idx2, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities, vm);
fname1 = sprintf('fig_13_3_N_%d_srate_%d_db%d_DAS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);
fname2 = sprintf('fig_13_3_N_%d_srate_%d_db%d_DIS.%s', N,...
         round(100*subsampling_ratio), vm, cil_dflt.image_format);

Z1 = zeros([N,N], 'uint8');
Z2 = zeros([N,N], 'uint8');

Z1(idx1) = uint8(255);
Z2(idx2) = uint8(255);

imwrite(Z1, fullfile(dest,fname1));
imwrite(Z2, fullfile(dest,fname2));

