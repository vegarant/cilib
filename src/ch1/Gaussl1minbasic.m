% Basic recovery of an s-sparse vector from random Gaussian measurements
% 
% Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

s = 6; % sparsity
m = 25; % number of measurements
N = 64; % signal size

A = randn(m,N); % Gaussian random matrix

for i = 1:8
    % Generate random s-sparse vector
    x = zeros(N,1);
    x(1:s) = randn(s,1); 
    x = x(randperm(N)); 
    
    y = A*x; % compute measurements
    
    % Compute solution of the l1 minimization problem
    eps1 = 1e-6;
    eps2 = 1e-8;
    iterations = 1000;
    opts = spgSetParms('verbosity',0,'iterations',iterations,'optTol',eps1,'bpTol',eps2); % specify spgl1 parameters
    
    xhat = spg_bp(A,y,opts);
    
    fprintf('||x-\\hat{x}||_2 = %g\n', norm(x-xhat, 2)); % compute the error
    
    % Plot x and xhat
    fig = figure('Visible', disp_plots);
    
    t = xhat;
    %t(abs(xhat)) = NaN;
    stem(t, 'Marker', 'o',...
               'Color', 'red', ...
               'MarkerEdgeColor', 'red', ...
               'MarkerFaceColor', 'red', ...
               'MarkerSize',4);
    hold('on');
    t = x;
    t(x==0) = NaN;
    
    stem(t,...
          'MarkerSize',cil_dflt.marker_size,...
          'MarkerEdgeColor', cil_dflt.marker_edge_color, ...
          'Color', cil_dflt.color, ...
          'MarkerSize',cil_dflt.marker_size, ...
          'LineWidth',cil_dflt.line_width);
    hold('off');
    
    xlim([1,N+1]);
    ymax = max(abs(x))*1.1;
    ylim([-ymax,ymax]);
    set(gca, 'FontSize', cil_dflt.font_size);
    
    legend('Recovered coefficients','Exact coefficients','Location','Northwest');
    
    fname = fullfile(dest, sprintf('Gaussl1recovery_%d', i));
    saveas(fig, fname, cil_dflt.plot_format);
end
