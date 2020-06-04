% Script of plotting the relative error vs snr for the image and gradient of TV
% reconstruction.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.


dest = 'plots';
% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

N = 256;
X = phantom(N);
x = reshape(X, [N*N, 1]);

noise = 1e-5;
spgl1_iterations = 5000;                    % Maximum number of spgl1 iterations.
subsampling_rate = 0.25;                    % ∈ [0,1]
alpha = 1;                                  % Inverse square law sampling pattern

im_grad = abs(cil_gradient_isotropic(X));
max_im_grad = max(im_grad(:));

nbr_samples = round(subsampling_rate*N*N);
[idx1, str_id1] = cil_spf2_power_law(N, nbr_samples, alpha);
[idx2, str_id2] = cil_sp2_uniform(N, nbr_samples);

P = zeros([N,N]);
P(idx2) = 1;
P(N/2+1, N/2+1) = 1;
idx2 = find(P);

pattern = {idx1, idx2};
pattern_id = {str_id1, str_id2};

% Compute stability plot

SNR_values = 5:1:30;
n = length(SNR_values);
rel_err_acc_im_rec = zeros(n,1);
rel_err_acc_grad_im_rec = zeros(n,1);

pattern_rel_err_stab = cell(length(pattern), 4);
pattern_rel_err_rob = cell(length(pattern), 4);

for j = 1:length(pattern)
    pattern_rel_err_stab{j, 1} = pattern_id{j};
    pattern_rel_err_stab{j, 2} = pattern{j};
    pattern_rel_err_stab{j, 3} = zeros(n,1);
    pattern_rel_err_stab{j, 4} = zeros(n,1);

    pattern_rel_err_rob{j, 1} = pattern_id{j};
    pattern_rel_err_rob{j, 2} = pattern{j};
    pattern_rel_err_rob{j, 3} = zeros(n,1);
    pattern_rel_err_rob{j, 4} = zeros(n,1);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         Stability experiment                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for j = 1:length(pattern)
    idx = pattern{j};
    str_id = pattern_id{j};
    for i = 1:n
        snr = SNR_values(i);

        h = randn(N^2,1);
        h = h/norm(h);
        sigma = norm(x)*10^(-snr/20);
        h = sigma*h;
        xh = x+h;
        
        a = min(xh); b = max(xh);
        xsc = 100*(xh - a)/(b-a); % rescale x to [0,100] for NESTA

        % Fourier TV
        fname = 'TV_rec';

        fprintf('str_id: %s, SNR: %d\n', str_id, snr);
        [~, xhrec1] = cil_sample_fourier_TV(reshape(xsc, [N,N]), noise, idx, ...
                                            fullfile(dest, fname), ...
                                            'nesta_verbose', 0);

        xhrec1 = reshape(xhrec1, [N*N, 1]);
        xhrec = (b-a)*xhrec1/100+a; % undo NESTA rescaling

        pattern_rel_err_stab{j,3}(i) = norm(xh-xhrec)/norm(xh);

        imh = reshape(xh, [N,N]);
        imhrec = reshape(xhrec, [N,N]);
        [~, xh_grad] = cil_gradient_isotropic(imh);
        [~, xh_xhrec_grad] = cil_gradient_isotropic(imh - imhrec);
        pattern_rel_err_stab{j,4}(i) = norm(xh_xhrec_grad, 'fro') / norm(xh_grad, 'fro');
        
    end

end

delete(fullfile(dest, [fname, '.', cil_dflt.image_format]));
delete(fullfile(dest, [fname, '_samp.', cil_dflt.image_format]));

% Plot stability image
fig = figure('visible', disp_plots);
plot(SNR_values, pattern_rel_err_stab{1, 3}, '-', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);
hold('on');
plot(SNR_values, pattern_rel_err_stab{2, 3}, ':', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);

legend({'Variable density', 'Uniform'}, 'FontSize', cil_dflt.font_size);

xlabel('SNR', 'FontSize', cil_dflt.font_size)
ylabel('Relative error', 'FontSize', cil_dflt.font_size)
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('plot_N_%d_srate_%d_stab_image', N, 100*subsampling_rate);
saveas(fig,fullfile(dest, fname), cil_dflt.plot_format);


% Plot stability image
fig = figure('visible', disp_plots);
plot(SNR_values, pattern_rel_err_stab{1, 4}, '-', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);
hold('on');
plot(SNR_values, pattern_rel_err_stab{2, 4}, ':', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);

legend({'Variable density', 'Uniform'}, 'FontSize', cil_dflt.font_size);

xlabel('SNR', 'FontSize', cil_dflt.font_size)
ylabel('Relative error', 'FontSize', cil_dflt.font_size)
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('plot_N_%d_srate_%d_stab_grad', N, 100*subsampling_rate);
saveas(fig,fullfile(dest, fname), cil_dflt.plot_format);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                         Robustness experiment                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:length(pattern)
    idx = pattern{j};
    str_id = pattern_id{j};
    A  = @(x) cil_op_fourier_2d(x, 1, N, idx); 
    for i = 1:n
        snr = SNR_values(i);

        a = min(x); b = max(x);
        xsc = 100*(x - a)/(b-a); % rescale x to [0,100] for NESTA

        y = A(xsc);
        eta = randn(size(y));
        eta = eta/norm(eta);
        sigma = norm(y)*10^(-snr/20);
        m_noise = sigma*eta;
        
        % Fourier TV
        fname = 'TV_rec';
        fprintf('SNR: %d\n', snr);
        [~, xhrec1] = cil_sample_fourier_TV(reshape(xsc, [N,N]), noise, idx, ...
                                            fullfile(dest, fname), ...
                                            'measurement_noise', m_noise, ...
                                            'nesta_verbose', 0);
        
        xhrec1 = reshape(xhrec1, [N*N, 1]);
        xhrec = (b-a)*xhrec1/100+a; % undo NESTA rescaling

        pattern_rel_err_rob{j,3}(i) = norm(x-xhrec)/norm(x);

        im = reshape(x, [N,N]);
        imhrec = reshape(xhrec, [N,N]);
        xh_grad = abs(cil_gradient_isotropic(im));
        xh_xhrec_grad = abs(cil_gradient_isotropic(im - imhrec));
        pattern_rel_err_rob{j,4}(i) = norm(xh_xhrec_grad, 'fro') / norm(xh_grad, 'fro');

    end

end


delete(fullfile(dest, [fname, '.', cil_dflt.image_format]));
delete(fullfile(dest, [fname, '_samp.', cil_dflt.image_format]));


% Plot stability image
fig = figure('visible', disp_plots);
plot(SNR_values, pattern_rel_err_rob{1, 3}, '-', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);
hold('on');
plot(SNR_values, pattern_rel_err_rob{2, 3}, ':', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);

legend({'Variable density', 'Uniform'}, 'FontSize', cil_dflt.font_size);

xlabel('SNR', 'FontSize', cil_dflt.font_size)
ylabel('Relative error', 'FontSize', cil_dflt.font_size)
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('plot_N_%d_srate_%d_rob_image', N, 100*subsampling_rate);
saveas(fig,fullfile(dest, fname), cil_dflt.plot_format);


% Plot stability image
fig = figure('visible', disp_plots);
plot(SNR_values, pattern_rel_err_rob{1, 4}, '-', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);
hold('on');
plot(SNR_values, pattern_rel_err_rob{2, 4}, ':', ...
                                            'linewidth', cil_dflt.line_width,...
                                            'color', cil_dflt.black);

legend({'Variable density', 'Uniform'}, 'FontSize', cil_dflt.font_size);

xlabel('SNR', 'FontSize', cil_dflt.font_size)
ylabel('Relative error', 'FontSize', cil_dflt.font_size)
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
fname = sprintf('plot_N_%d_srate_%d_rob_grad', N, 100*subsampling_rate);
saveas(fig,fullfile(dest, fname), cil_dflt.plot_format);






