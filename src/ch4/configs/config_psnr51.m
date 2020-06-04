
dwtmode('per', 'nodisp');

vm = 4;
r = 9; 
N = 2^r;

im_dir = 'natural_images';
im_name_core = 'dog3';
noise_level = 0.1;
nres = wmaxlev(N, sprintf('db%d', vm));

subsampling_rates = linspace(0.02, 0.4, 25);


vm = 4;
wname = sprintf('db%d', vm);
nres = wmaxlev(N, wname);

a = 1;
r0 = 2;
nbr_levels = 50;
f1 = @(N, nbr_samples) sph2_gcircle(N, nbr_samples, a, r0, nbr_levels);
str_id1 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 2, a, r0, nbr_levels);
color_id1 = {cil_dflt.blue, '-'};

a = 2;
r0 = 2;
nbr_levels = 50;
f2 = @(N, nbr_samples) sph2_gcircle(N, nbr_samples, a, r0, nbr_levels);
str_id2 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 2, a, r0, nbr_levels);
color_id2 = {cil_dflt.blue, '--'};

a = 1;
r0 = 2;
nbr_levels = 50;
radius = 2;
p_norm = 0.5;
f3 = @(N, nbr_samples) sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm);
str_id3 = sprintf('exp, l_%g, a: %d, r0: %d, r:%d, rad: %G',p_norm, a, r0, nbr_levels, radius);
color_id3 = {cil_dflt.brown, '-'};

a = 2;
r0 = 2;
nbr_levels = 50;
radius = 2;
p_norm = 0.5;
f4 = @(N, nbr_samples) sph2_exp(N, nbr_samples, a, r0, nbr_levels, radius, p_norm);
str_id4 = sprintf('exp, l_%g, a: %d, r0: %d, r:%d, rad: %G',p_norm, a, r0, nbr_levels, radius);
color_id4 = {cil_dflt.brown, '--'};

im = phantom(N);
epsilon = 1;
sparsity = cil_compute_sparsity_of_image(im, vm, nres, epsilon);
f5 = @(N, nbr_samples) sph2_DAS(N, nbr_samples, sparsity);
str_id5 = sprintf('DAS, epsilon: %g', epsilon);
color_id5 = {cil_dflt.yellow, '-'};


f6 = @(N, nbr_samples) sph2_DIS(N, nbr_samples, sparsity);
str_id6 = sprintf('DIS, epsilon: %g', epsilon);
color_id6 = {cil_dflt.red, '-'};




samp_patt_handles = {f1, f2, f3, f4, f5, f6};
str_identifier = {str_id1, str_id2, str_id3, str_id4, str_id5, str_id6};
color_handles = {color_id1, color_id2, color_id3, color_id4, color_id5, color_id6};




