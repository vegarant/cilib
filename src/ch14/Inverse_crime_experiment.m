% Experiment designed to show the inverse crime. 
% Computes discrete and continuous Fourier measurements and reconstruct 
% images from both the continuous and discrete measurements using the Haar 
% wavelet. The (normalised) difference image is then written to file to show
% how the inverse crime effects the results. 

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.
dwtmode('per', 'nodisp');

dest = 'plots';
% create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

K = 128; % Cross section point
vm    = 1;                         % Number of vanishing moments
noise = 0.0001;                       % Minimize ||Ax-b||_2 subject to ||x||_1 ≤ noise
alpha = 1;                         % Power law decay parameter
spgl1_iterations = 5000;            % max number of spgl1 iterations
spgl1_verbosity = 1;
fname_core = 'phantom_brain';
sampling_rates = (10:60)/100;
im_max_val = 255;
disp_plots = 'off';

N1 = 256;  % Resolution of the discrete image
N2 = 4096; % Size of image, for which we are going to compute the discrete 
           % measurements
%M = N1/2   % Number of continuous wavelet coefficents we want to recover

% Set and get wavelet paramters
wname = sprintf('db%d', vm);
nres = wmaxlev(N1, wname)-1;
S = cil_get_wavedec2_s(round(log2(N1)), nres);

% Set spgl1 options
spgl1_opts = spgSetParms('verbosity', spgl1_verbosity, 'iterations', spgl1_iterations);

% Load the images
fname1 = fullfile(cil_dflt.data_path, 'test_images', ...
                  sprintf('%s_%d.png', fname_core, N1));
fname2 = fullfile(cil_dflt.data_path, 'test_images', ...
                  sprintf('%s_%d.png', fname_core, N2));

im1 = double(imread(fname1));
im2 = double(imread(fname2));


% Create "continous" samples 
Z = fftshift(fft2(im2))/(N2/N1)^2;
range = (N2/2-N1/2+1):(N2/2+N1/2);
cont_k_space = Z(range,range)/N1;
%range2 = (N2/2-N1+1):(N2/2+N1);
%cont_k_space2 = 2*N1*Z(range2,range2);

disc_k_space = fftshift(fft2(im1))/N1;
    
n = length(sampling_rates);

fname = 'psnr_values.txt';
fid = fopen(fullfile(dest, fname), 'w');

for i = 1:n

    srate = sampling_rates(i);
    nbr_samples = round(srate*N1*N1);
    idx = cil_spf2_power_law(N1, nbr_samples, alpha);

    fprintf('Sampling rate: %d\n', round(100*srate));

    % Take measurements
    y_disc = disc_k_space(idx);
    y_cont = cont_k_space(idx);

    opA = @(x, mode) cil_op_fourier_wavelet_2d(x, mode, N1, idx, nres, wname);
    wcoeff_disc = spg_bp(opA, y_disc, spgl1_opts);

    wcoeff_cont = spg_bp(opA, y_cont, spgl1_opts);

    im_rec_disc  = waverec2(wcoeff_disc, S, wname);
    im_rec_disc1 = abs(im_rec_disc);
    idx_to_large = im_rec_disc1 > 255;
    im_rec_disc1(idx_to_large) = 255;   
    psnr_disc = psnr(abs(im_rec_disc), im1, 255)


    im_rec_cont  = waverec2(wcoeff_cont, S, wname);
    im_rec_cont1 = abs(im_rec_cont);
    idx_to_large = im_rec_cont1 > 255;
    im_rec_cont1(idx_to_large) = 255;
    psnr_cont = psnr(abs(im_rec_cont), im1, 255)

    fprintf(fid, 'N: %d, prec: %d, psnr_invcrime: %5.2f, psnr_nocrime: %5.2f\n', N1, round(100*srate), psnr_disc, psnr_cont);


    diff_disc = abs(im_rec_disc - im1);
    diff_cont = abs(im_rec_cont - im1);
    
    max_val1 = max(max(diff_cont(:)));
    max_val2 = max(max(diff_disc(:)));
    maxerr = max(max_val1, max_val2);

    fname_disc = sprintf('recon_invcrime_N%d_perc%d.%s', N1, round(100*srate), cil_dflt.image_format);
    fname_cont = sprintf('recon_nocrime_N%d_perc%d.%s', N1, round(100*srate), cil_dflt.image_format);

    imwrite(im2uint8(1-(diff_disc/maxerr)), fullfile(dest, fname_disc));
    imwrite(im2uint8(1-(diff_cont/maxerr)), fullfile(dest, fname_cont));

    %%% Crosss-section plots

    fig = figure('visible', disp_plots);
    plot(im_rec_disc(K,:),'LineWidth', cil_dflt.line_width);
    hold('on');
    plot(im_rec_cont(K,:),'LineWidth', cil_dflt.line_width);
    hold('off')
    xlim([1,N1]);
    ylim([-20,160]);
    legend({'Inverse crime','No inverse crime'},'Location','North');
    ax = gca;
    ax.FontSize  = cil_dflt.font_size;
    ax.LineWidth = cil_dflt.line_width;

    fname = sprintf('crosssec_recon_N_%d_m_%d', N1, round(100*srate));
    saveas(fig,fullfile(dest, fname), cil_dflt.plot_format);

end

fclose(fid)






























%n = length(sampling_rates);
%
%
%%for i = 1:n
%i = 1
%srate = sampling_rates(i);
%nbr_samples = round(srate*N1*N1);
%idx = cil_spf2_power_law(N1, nbr_samples, alpha);
%
%op_disc = @(x, mode) cil_op_fourier_wavelet_2d(x, mode, N1, idx, nres, wname);
%wave_data = cil_get_cont_fourier_wavelet_data(N1, M, idx, vm);
%op_cont = @(x, mode) cil_op_cont_fourier_wavelet_2d(x, mode, wave_data);
%
%b_cont = cont_k_space(idx); 
%b_disc = disc_k_space(idx); 
%b_cont_mask = wave_data.mask.*cont_k_space;
%
%
%%w_disc_disc = spg_bpdn(op_disc, b_disc, noise, opts); 
%%w_disc_cont = spg_bpdn(op_disc, b_cont, noise, opts);
%%w_cont_cont1 = spg_bpdn(op_cont, b_cont_mask(:), noise, opts);
%
%
%R = round(log2(M));
%h = @(x,y) sin(5*pi*x).*cos(3*pi*y) + (x>0.3).*(x<0.58).*(y>0.15).*(y<0.5);
%omega_main = Samples(eps, M, 'sin(5*pi*x)*cos(3*pi*y)', 0, 1, 0, 1 ) + Samples(eps, M, '1', 0.3, 0.58, 0.15, 0.5);
%
%slen = 1.5/2^R;
%g = @(x,y) (y>0.3).*(y<0.5).*(x>0.5).*(x<0.5+slen)+...
%    (y>0.3).*(y<0.5).*(x>0.5+2*slen).*(x<0.5+3*slen)...
%    +(y>0.3).*(y<0.5).*(x>0.5+4*slen).*(x<0.5+5*slen)...
%    +(y>0.3).*(y<0.5).*(x>0.5+6*slen).*(x<0.5+7*slen);
%omega_details = Samples(eps, M, '1', 0.5, 0.5+slen, 0.3, 0.5)+...
%    Samples(eps, M, '1', 0.5+2*slen, 0.5+3*slen, 0.3, 0.5)+...
%    Samples(eps, M, '1', 0.5+4*slen, 0.5+5*slen, 0.3, 0.5)+...
%    Samples(eps, M, '1', 0.5+6*slen, 0.5+7*slen, 0.3, 0.5);
%
%omega_full = omega_main + omega_details; 
%omega = wave_data.mask.*omega_full;
%w_cont_cont1 = spg_bpdn(op_cont, omega(:), noise, opts);
%
%w_cont_cont = reshape(w_cont_cont1,M,M);
%
%wcoeff = w_cont_cont;
%filter = [1 1] ./ sqrt(2);
%sc = IWT2_PO(real(wcoeff),0,filter)+1i* IWT2_PO(imag(wcoeff),0,filter);
%sc = abs(sc); 
%%if vm==1 
%%    im_rec_cc = get2DHaarReconstruction(w_cont_cont, round(log2(N1)), wave_data.R);    
%%else
%%    im_rec_cc = get2DReconstruction(w_cont_cont, vm, round(log2(N1)), wave_data.R);
%%end
%
%%S = cil_get_wavedec2_s(round(log2(N1)), nres);
%%
%%im_rec_dd  = waverec2(w_disc_disc, s, wname);
%%im_rec_dd = abs(im_rec_dd);
%%im_rec_dd = cil_clip_values(im_rec_dd, 0, im_max_val);    
%%im_rec_dd_psnr = psnr(im_rec_dd, im1, im_max_val);
%%fprintf('srate: %g, PSNR rec_dd: %g\n', srate, im_rec_dd_psnr); 
%%
%%im_rec_dc  = waverec2(w_disc_cont, S, wname);
%%im_rec_dc = abs(im_rec_dc);
%%im_rec_dc = cil_clip_values(im_rec_dc, 0, im_max_val);    
%%im_rec_dc_psnr = psnr(im_rec_dc, im1, im_max_val);
%%fprintf('srate: %g, PSNR rec_dc: %g\n', srate, im_rec_dc_psnr); 
% 
%%end





















%% Save a version of the image which have a blue line painted across. 
%fig = figure('visible', disp_plots);
%imshow(im1,[0 255]);
%hold('on')
%plot([1 256],[K K],'LineWidth', cil_dflt.line_width);
%hold('off')
%saveas(fig,fullfile(dest, sprintf('phantom_brain_%d_line',N1)), cil_dflt.plot_format);
%
%intersection = im1(K,:);
%
%fig = figure('visible', disp_plots);
%plot(1:N1, intersection, ...
%     'linewidth', cil_dflt.line_width);
%%set(gca, 'FontSize', cil_dflt.font_size);
%xlim([1,N1]);
%ylim([-20,160]);
%legend('Ground truth', 'location', 'North', 'Fontsize', cil_dflt.font_size);
%saveas(fig,fullfile(dest, sprintf('phantom_brain_%d_line_only',N1)), cil_dflt.plot_format);

