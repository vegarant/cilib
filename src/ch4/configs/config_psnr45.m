
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

subsampling_rates = linspace(0.02, 0.40, 25);

% exp circle 
a = 1;
r0 = 2;
nbr_levels = 50; 
f1 = @(N, nbr_samples) spf2_gcircle(N, nbr_samples, a, r0, nbr_levels);
str_id1 = sprintf('exp, l_%d, a: %d, r0: %d, r:%d', 2, a, r0, nbr_levels);
color_id1 = {cil_dflt.blue, '-'};

% 2level
p_norm = 2;
r_factor = 4;

f2 = @(N, nbr_samples) spf2_2level(N, nbr_samples, p_norm, r_factor);
str_id2 = sprintf('2level, l_%d,  m/%d,', p_norm, r_factor);
color_id2 = {cil_dflt.green, '-'};


samp_patt_handles = {f1, f2};
str_identifier    = {str_id1, str_id2};
color_handles = {color_id1, color_id2};



