clear('all'); close('all');
dwtmode('per', 'nodisp');

r = 9;
N = 2^r;
subsampling_ratio = 0.14;
nbr_samples = round(subsampling_ratio*N*N);

vm = 1;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);
alpha = 8;

a = 0.5;
b = 0.3;
%idx = cil_spf2_spiral(N,nbr_samples, a,b);
%alpha = 1 ;

im = phantom(N);
nres = wmaxlev(N, wname);

epsilon = 0.6;

vm1 = 1;
vm2 = 2;
vm3 = 4;
vm4 = 6;


%sValues    = cil_calculate_sparsities(im, nres, vm);
%[idx1, str_id] = cil_spf2_DAS_randy(N, nbr_samples, sValues, vm);
sparsities1 = cil_compute_sparsity_of_image(im, vm1, nres, epsilon);
[idx1, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities1, vm1);
[idx2, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities1, vm1);
sparsities2 = cil_compute_sparsity_of_image(im, vm2, nres, epsilon);
[idx3, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities2, vm2);
[idx4, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities2, vm2);
sparsities3 = cil_compute_sparsity_of_image(im, vm3, nres, epsilon);
[idx5, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities3, vm3);
[idx6, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities3, vm3);
sparsities4 = cil_compute_sparsity_of_image(im, vm4, nres, epsilon);
[idx7, str_id] = cil_spf2_DAS(N, nbr_samples, sparsities4, vm4);
[idx8, str_id] = cil_spf2_DIS(N, nbr_samples, sparsities4, vm4);



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
Z5 = zeros([N,N]);
Z6 = zeros([N,N]);
Z7 = zeros([N,N]);
Z8 = zeros([N,N]);

Z1(idx1) = 1;
Z2(idx2) = 1;
Z3(idx3) = 1;
Z4(idx4) = 1;
Z5(idx5) = 1;
Z6(idx6) = 1;
Z7(idx7) = 1;
Z8(idx8) = 1;

%title1 = sprintf('epsilon = %g', epsilon1);
title1 = sprintf('DAS, vm: %d', vm1);
title2 = sprintf('DIS, vm: %d', vm1);
title3 = sprintf('DAS, vm: %d', vm2);
title4 = sprintf('DIS, vm: %d', vm2);
title5 = sprintf('DAS, vm: %d', vm3);
title6 = sprintf('DIS, vm: %d', vm3);
title7 = sprintf('DAS, vm: %d', vm4);
title8 = sprintf('DIS, vm: %d', vm4);

fig = figure('Visible', 'on');
subplot(241); imagesc(Z1); colormap('gray'); title(title1); %axis('equal'); 
subplot(245); imagesc(Z2); colormap('gray'); title(title2); %axis('equal'); 
subplot(242); imagesc(Z3); colormap('gray'); title(title3); %axis('equal'); 
subplot(246); imagesc(Z4); colormap('gray'); title(title4); %axis('equal'); 
subplot(243); imagesc(Z5); colormap('gray'); title(title5); %axis('equal'); 
subplot(247); imagesc(Z6); colormap('gray'); title(title6); %axis('equal'); 
subplot(244); imagesc(Z7); colormap('gray'); title(title7); %axis('equal'); 
subplot(248); imagesc(Z8); colormap('gray'); title(title8); %axis('equal'); 

fname = sprintf('plots/Patt_four_DAS_N_%d_srate_%02d', N, round(100*subsampling_ratio));
saveas(fig, fname, 'png')


