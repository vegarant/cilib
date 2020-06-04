
dwtmode('per', 'nodisp');

r = 9;
vm = 4;
N = 2^r;
j0 = computeJ0(vm);
nres = r - j0;

im_dir = 'MR';
im_name_core = 'phantom_brain'; % 'brain1'; %'phantom_brain';
noise_level = 0.1;
%nres = wmaxlev(N, sprintf('db%d', vm));

subsampling_rates = linspace(0.02, 0.4, 25);

% exp circle 
a = 1;
r0 = 2;
nbr_levels = 50; 
f1 = @(N, nbr_samples) spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
str_id1 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 2, a, r0, nbr_levels);
color_id1 = {cil_dflt.blue, '-'};

a = 2;
r0 = 2;
nbr_levels = 50; 
f2 = @(N, nbr_samples) spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
str_id2 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 2, a, r0, nbr_levels);
color_id2 = {cil_dflt.blue, '--'};


% exp diamod
a = 1;
r0 = 2;
nbr_levels = 50; 
f3 = @(N, nbr_samples) spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels);
str_id3 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 1, a, r0, nbr_levels);
color_id3 = {cil_dflt.magenta, '-'};

a = 2;
r0 = 2;
nbr_levels = 50; 
f4 = @(N, nbr_samples) spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels);
str_id4 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 1, a, r0, nbr_levels);
color_id4 = {cil_dflt.magenta, '--'};



samp_patt_handles = {f1, f2, f3, f4};
str_identifier    = {str_id1, str_id2, str_id3, str_id4};
color_handles = {color_id1, color_id2, color_id3, color_id4};



