% This scripts compute wavelet and TV reconstructions, with a power law
% sampling pattern, for alpha in the set 
% {0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00, 2.25, 2.50, 2.75, 3.00}
% and write the alpha which gives the best PSNR-value, the PSNR-value and the
% sampling percentage to a file, in a nicely formatted table.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

dest = 'plots';
% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end

vm = 4; % Number of vanishing moments.
wname = sprintf('db%d', vm);
noise_level = 0.01;
noise_level_nesta = 1e-5;
spgl1_iterations = 5000;

resolutions = [256, 512];
fname_core_images = {'dog3', 'brain1', 'peppers', 'kopp3'};
out_name_image    = {'Dog', 'Brain', 'Peppers', 'Kopp'};
sampling_fractions = (5:5:40)/100;
all_alpha = [0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00, 2.25, 2.50, 2.75, 3.00];
dummy_fname = fullfile(dest, 'tmp');


fname_wavelet = sprintf('table_wavelet.txt');
fname_tv = sprintf('table_TV.txt');

fID_wave = fopen(fullfile(dest, fname_wavelet), 'w');
fID_tv = fopen(fullfile(dest, fname_tv), 'w');

header = sprintf('\\toprule \nImage/Percentage');
for i = 1:length(sampling_fractions)
    srate = sampling_fractions(i);
    header = sprintf('%s & %g\\%% ', header, 100*srate);
end
header = sprintf('%s \\\\ \n\\midrule \n', header);

fwrite(fID_wave, header);
fwrite(fID_tv, header);


% Create a alpha × sampling percentage × resolution cell
nbr_alpha  = length(all_alpha);
nbr_srate  = length(sampling_fractions);
nbr_res    = length(resolutions);
nbr_images = length(fname_core_images);

all_sampling_patterns = cell(nbr_alpha, nbr_srate, nbr_res);
for i = 1:nbr_alpha
    for j = 1:nbr_srate
        for k = 1:nbr_res

            N = resolutions(k);
            srate = sampling_fractions(j);
            alpha = all_alpha(i);
            nbr_samples = round(N*N*srate);

            [idx, str_id] = cil_spf2_power_law(N, nbr_samples, alpha);

            all_sampling_patterns{i,j,k} = idx;

        end
    end
end


for im_nbr = 1:nbr_images

    out_name = out_name_image{im_nbr};

    for k = 1:nbr_res

        fname_core = fname_core_images{im_nbr};
        N = resolutions(k);

        fname_im = sprintf('%s_%d.png', fname_core, N);
        fname_im_full = fullfile(cil_dflt.data_path, 'test_images', fname_im);
        im = double(imread(fname_im_full));
        
        psnr_values_im_res_wave = zeros(nbr_alpha, nbr_srate);
        psnr_values_im_res_tv = zeros(nbr_alpha, nbr_srate);
        
        for j = 1:nbr_srate
            srate = sampling_fractions(j);
            for i = 1:nbr_alpha
                alpha = all_alpha(i);

                idx = all_sampling_patterns{i,j,k};

                % Compute wavelet reconstruction.
                fprintf('srate: %g, alpha: %g\n', 100*srate, alpha);

                [im_rec, z] = cil_sample_fourier_wavelet(im, noise_level, ...
                                                         idx, dummy_fname, vm, ...
                                                         'spgl1_verbosity', 0,...
                                                         'spgl1_iterations', spgl1_iterations);

                nres   = wmaxlev(N, wname);  % Maximum wavelet decomposition level
                S      = cil_get_wavedec2_s(round(log2(N)), nres);
                im_rec = waverec2(z, S, wname);

                im_rec = abs(im_rec);
                idx_rem = im_rec > 255;
                im_rec(idx_rem) = 255;

                [psnr_val, snr_val] = psnr(im_rec, im, 255);

                psnr_values_im_res_wave(i, j) = psnr_val;

                % Compute TV 

                im_scaled = (100/255)*im;
                [~, rec_scaled] = cil_sample_fourier_TV(im_scaled, noise_level_nesta, ...
                                                    idx, dummy_fname, ...
                                                    'nesta_verbose', 0);
                
                rec_tv = (255/100)*reshape(rec_scaled, [N, N]);

                rec_tv = abs(rec_tv);
                idx_rem = rec_tv > 255;
                rec_tv(idx_rem) = 255;

                [psnr_val, snr_val] = psnr(rec_tv, im, 255);

                psnr_values_im_res_tv(i, j) = psnr_val;

            end
        end

        str_line_wave = sprintf('%s ($%d \\times %d$) ', out_name_image{im_nbr}, N, N);
        str_line_tv   = sprintf('%s ($%d \\times %d$) ', out_name_image{im_nbr}, N, N);
        for j = 1:nbr_srate

            [psnr_max_wave, wave_argmax]  = max(psnr_values_im_res_wave(:, j));
            [psnr_max_tv, tv_argmax]      = max(psnr_values_im_res_tv(:, j));

            wave_alpha = all_alpha(wave_argmax);
            tv_alpha = all_alpha(tv_argmax);

            % Alpha line
%            for j = 1:nbr_srate
            str_line_wave = sprintf('%s & %4.2f', str_line_wave, wave_alpha); 
            str_line_tv = sprintf('%s & %4.2f', str_line_tv, tv_alpha); 
%            end
        end
        
        str_line_wave = sprintf('%s \\\\ \n ', str_line_wave);
        str_line_tv   = sprintf('%s \\\\ \n ', str_line_tv);

        for j = 1:nbr_srate

            [psnr_max_wave, wave_argmax]  = max(psnr_values_im_res_wave(:, j));
            [psnr_max_tv, tv_argmax]      = max(psnr_values_im_res_tv(:, j));


            % psnr  line
%            for j = 1:nbr_srate
            str_line_wave = sprintf('%s & %5.2f', str_line_wave, psnr_max_wave); 
            str_line_tv = sprintf('%s & %5.2f', str_line_tv, psnr_max_tv); 
%            end
        end


        str_line_wave = sprintf('%s \\\\ \n', str_line_wave);
        str_line_tv   = sprintf('%s \\\\ \n', str_line_tv);

        fwrite(fID_wave, str_line_wave);
        fwrite(fID_tv, str_line_tv);

    end
end

bottom = sprintf('\\bottomrule \n');
fwrite(fID_wave, bottom);
fwrite(fID_tv, bottom);

fclose(fID_wave);
fclose(fID_tv);

