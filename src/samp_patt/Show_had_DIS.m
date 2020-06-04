clear('all'); close('all');
dwtmode('per', 'nodisp');

r = 10;
N = 2^r;
subsampling_ratio = 0.05;
nbr_samples = round(subsampling_ratio*N*N);

vm = 4;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);
alpha = 1;

a = 0.5;
b = 0.3;
%idx = cil_spf2_spiral(N,nbr_samples, a,b);
%alpha = 1 ;

im = phantom(N);
nres = wmaxlev(N, wname);


sValues    = cil_calculate_sparsities(im, nres, vm);
[idx1, str_id] = cil_sph2_DIS_randy(N, nbr_samples, sValues);
epsilon2 = .1;
sparsities2 = cil_compute_sparsity_of_image(im, vm, nres, epsilon2);
[idx2, str_id] = cil_sph2_DIS(N, nbr_samples, sparsities2);
epsilon3 = .5;
sparsities3 = cil_compute_sparsity_of_image(im, vm, nres, epsilon3);
[idx3, str_id] = cil_sph2_DIS(N, nbr_samples, sparsities3);
epsilon4 = 1;
sparsities4 = cil_compute_sparsity_of_image(im, vm, nres, epsilon4);
[idx4, str_id] = cil_sph2_DIS(N, nbr_samples, sparsities4);
sparsities2
sparsities3
sparsities4

%Z = zeros([N,N]);
%Z(idx) = 1;
%
%imagesc(Z); colormap('gray');

%r_factor = 2;
%p_norm = inf;
%
%[idx1, str_id1] = sph2_power_law(N, nbr_samples, 0.5);
%[idx2, str_id2] = sph2_power_law(N, nbr_samples, 1);
%[idx3, str_id3] = sph2_power_law(N, nbr_samples, 1.5);
%[idx4, str_id4] = sph2_power_law(N, nbr_samples, 2);
%
Z1 = zeros([N,N]);
Z2 = zeros([N,N]);
Z3 = zeros([N,N]);
Z4 = zeros([N,N]);

Z1(idx1) = 1;
Z2(idx2) = 1;
Z3(idx3) = 1;
Z4(idx4) = 1;

%title1 = sprintf('epsilon = %g', epsilon1);
title1 = 'DIS Randy';
title2 = sprintf('epsilon = %g', epsilon2);
title3 = sprintf('epsilon = %g', epsilon3);
title4 = sprintf('epsilon = %g', epsilon4);

fig = figure('Visible', 'off');
subplot(221); imagesc(Z1); colormap('gray'); title(title1); %axis('equal'); 
subplot(222); imagesc(Z2); colormap('gray'); title(title2); %axis('equal'); 
subplot(223); imagesc(Z3); colormap('gray'); title(title3); %axis('equal'); 
subplot(224); imagesc(Z4); colormap('gray'); title(title4); %axis('equal'); 

fname = sprintf('plots/Patt_had_DIS_N_%d_srate_%02d', N, round(100*subsampling_ratio));

saveas(fig, fname, 'png')

