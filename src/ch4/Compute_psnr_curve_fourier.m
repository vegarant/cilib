% This script is used to compute the raw data for a PSNR values vs sampling rate plot.
% It performs a series of Fourier sampling and wavelet reconstruction experiments with 
% different sampling strategies and different sampling rates. It computes the PSNR-values
% of the reconstructed images and store the PSNR-values in a data folder.
%
% The script reads a file called 'COUNT.txt'. This is a file contain a single integer
% called the `runID`. This integer will be used to identfy this run. When the 
% script have extracted the integer in the 'COUNT.txt' file it replaces the integer
% with in the file with `runID + 1`, so that the next time you run this script you
% get a new runID. All data associated with this run will be stored in
% 'psnr_data/run{runID}'.
%
% This script is not supposed to be modified, and all variables related to the 
% different sampling strategies and other parameters have therefore been moved 
% to a 'config_psnr.m' file. This file will be copied and placed in the 
% 'psnr_data/run{runID}' directory, and it is this copy which will be used by this 
% script. Copying the 'config_psnr.m' file makes it easy to check what parameters
% generated the specific data.
%
% To generate the acutal plots from the data, use the file 
% `Read_psnr_values_and_create_plot.m` with the right `runID`.
% 
% List of dependent files
% * COUNT.txt - Contains the `runID`.
% * psnr_config.m - Setup of the experiement.
% * Read_psnr_values_and_create_plot.m - Reads the data and create the plot.
%
% Vegard Antun, 2019

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

% create destination for the plots
dest = 'plots/';
dest_data = 'psnr_data';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
if (exist(dest_data) ~= 7) 
    mkdir(dest_data);
end

r_id = cil_read_counter('./COUNT.txt');
fname = sprintf('run%03d', r_id);
dest_data_full = fullfile(dest_data, fname);
 
if (exist(dest_data_full) ~= 7) 
    mkdir(dest_data_full);
end

fprintf('--------------- runner id: %d ----------------\n', r_id);

% Load config -- Read the file, copy it to run directory and run the copy of the
% file. By running the copy, you can safely modify the config_psnr.m file after
% you have started this script. 

config_name = fullfile(dest_data_full, 'config_psnr.m');
copyfile('config_psnr.m', config_name);
run(config_name);

wname = sprintf('db%d', vm);
image_name = fullfile(im_dir, sprintf('%s_%d.png', im_name_core, N) );
im_uint8 = imread(fullfile(cil_dflt.data_path, image_name));
im = double(im_uint8);

nbr_of_patterns = length( samp_patt_handles );
nbr_of_srates = length( subsampling_rates );

% For each sampling pattern
for i_patt = 1:nbr_of_patterns;
    f = samp_patt_handles{i_patt}; % f is function handle to sampling pattern
                                   % f(N, number_of_samples)
    psnr_arr = zeros([nbr_of_srates, 1]); % vectors to store psnr values
    snr_arr  = zeros([nbr_of_srates, 1]);
    % For each sampling rate
    for j = 1:nbr_of_srates    

        nbr_samples = round(N*N*subsampling_rates(j));
        [idx, str_id] = f(N, nbr_samples);
        
        % Check that pattern is vaild
        Patt = zeros([N,N]);
        Patt(idx) = 1;

        if sum(Patt(:)) ~= nbr_samples
            fprintf('Warning: patt: %s, did only produce %d samples, requested %d\n', ...
                    str_id, sum(Patt(:)), nbr_samples);
        end

        fname = fullfile(dest, 'not_relevant');

        cil_progressbar(j, nbr_of_srates); % Print a progress bar (ideal for terminals, not for matlab GUI)

        % Perform compressive sensing experiment, turn off spgl1 printing
        [im_rec, z] = cil_sample_fourier_wavelet(im, noise_level, idx, fname, ...
                                                 vm, 'spgl1_verbosity', 0);

        % `im_rec` is a postprocessed image ideal for printing to file
        % `z` is the raw wavelet coefficents. For PSNR computations, we postprocess 
        % the image in a slightly different way. Now we therefore, compute the 
        % inverse DWT of `z`  
        nres   = wmaxlev(N, wname);  % Maximum wavelet decomposition level
        S      = cil_get_wavedec2_s(round(log2(N)), nres);
        im_rec = waverec2(z, S, wname);

        im_rec = abs(im_rec);
        idx_rem = im_rec > 255;
        im_rec(idx_rem) = 255;

        [psnr_val, snr_val] = psnr(im_rec, im, 255);

        psnr_arr(j) = psnr_val;
        snr_arr(j)  = snr_val;

    end

    % Store PSNR data
    fname_data_psnr = sprintf('psnr_%d.mat', i_patt);
    fname_data_snr  = sprintf('snr_%d.mat', i_patt);

    save(fullfile(dest_data_full, fname_data_psnr), 'psnr_arr', 'subsampling_rates');
    save(fullfile(dest_data_full, fname_data_snr),  'snr_arr', 'subsampling_rates');

end

