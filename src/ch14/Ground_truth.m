% This script adds a horizontal blue line in the phantom brain image and 
% plots an intersection of the phantom brain image.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dest = 'plots';
% create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';

N = 256;  % Resolution of the discrete image
K = N/2;   % Cross section point
fname_core = 'phantom_brain';
im_max_val = 255;

% Load the images
fname1 = fullfile(cil_dflt.data_path, 'test_images', ...
                  sprintf('%s_%d.png', fname_core, N));

im = imread(fname1);
im_copy = im;
im(im_copy == 255) = 254; 

im(K, :) = 255;

light_blue = [0 0.4470 0.7410];
%[91, 207, 244] / 255;
%[0.5843, 0.8157, 0.9882]
cmap = gray(N);
cmap(end, :) = light_blue;

im(K-1:K+1, 1:N) = 255;

fname = sprintf('%s_with_line.png', fname_core);
imwrite(im, cmap, fullfile(dest,fname));


intersection = im_copy(K,:);
fig = figure('visible', disp_plots);
plot(1:N, intersection, ...
     'linewidth', cil_dflt.line_width);
set(gca, 'FontSize', cil_dflt.font_size);
set(gca,'LooseInset',get(gca,'TightInset'));
xlim([1,N]);
ylim([-20,160]);
legend('Ground truth', 'location', 'North', 'Fontsize', cil_dflt.font_size);
saveas(fig,fullfile(dest, sprintf('phantom_brain_%d_line_only', N)), cil_dflt.plot_format);



