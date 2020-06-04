% This script computes a TV minimizer of the SL phantom using discrete and continuous 
% Radon measurements. This script require that you have access to the right
% Radon matrices. These can be downloaded from cilib_data or generated using
% the script `src/misc/Generate_radon_matrix.m`. It is also necessary to install 
% the ShearletReweighting dependency. 

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% Create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

dwtmode('per', 'nodisp');

views = 50;

% The two different resolutions we consider
N1 = 128;
N2 = 512;
% E is a matrix describing the properties of the ellipses in the
% phantom image
[P1, E] = phantom(N1);
P2 = phantom(N2);

% Angles we would like to image
theta = 180*linspace(0,1-1/views, views);

% xp1 and xp2 contains the values of the ray-bins we are trying to image
[I1, xp1] = radon(P1, theta);
[I2, xp2] = radon(P2, theta);

% Size of sinograms
size_sino1 = size(I1);
size_sino2 = size(I2);

% Scale the ray bin values so that they lie in the interval [-1, 1] 
% Compute the t-values of the ray bins.
t1 = xp1'/(N1/sqrt(2));
t2 = xp2'/(N2/sqrt(2));

s1 = length(t1);
s2 = length(t2);

% Compute indices of the two discretization one would like to sample
idx_t1 = 2:s1-1;
idx_t2 = 1:4:s2;

% Ensure that the two sampling modalities sample the same bins
tt1 = t1(idx_t1);
tt2 = t2(idx_t2);

% Check that the t-values are the same
norm(tt1-tt2);

% Compute the continuous radon transform of the ellipses specified in E, along
% the ray bins specified by tt1 
I = cil_cont_radon_transform_ellipses(tt1, theta, E);

% Load the two different radon matrices
src = cil_dflt.data_path;
fname_matrix = sprintf('radonMatrix2N%d_ang%d.mat', N1, views);
fname_matrix = fullfile(src, 'radon_matrices', fname_matrix);
load(fname_matrix) % Matrix is named 'A'
A1 = A;
I1 = A1*P1(:);
I1 = reshape(I1, size_sino1);
% Scale the sinogram to have the right magnitude
I1_cont = ( max(I1(:))/max(I(:)) )*I;

fname_matrix = sprintf('radonMatrix2N%d_ang%d.mat', N2, views);
fname_matrix = fullfile(src, 'radon_matrices', fname_matrix);
load(fname_matrix) % Matrix is named 'A'
A2 = A;
clear('A');
I2 = A2*P2(:);
I2 = reshape(I2, size_sino2);
% Scale the sinogram to have the right magnitude
I2_cont = ( max(I2(:))/max(I(:)) )*I;

I1_simple = I1(idx_t1, :);
I2_simple = I2(idx_t2, :);


B1.times = @(x) cil_op_cont_radon_2d(x(:), 1, A1, idx_t1, size_sino1);
B1.adj   = @(x) cil_op_cont_radon_2d(x(:), 0, A1, idx_t1, size_sino1);
B1.mask  = NaN;
m1 = [N1, N1];

B2.times = @(x) cil_op_cont_radon_2d(x(:), 1, A2, idx_t2, size_sino2);
B2.adj   = @(x) cil_op_cont_radon_2d(x(:), 0, A2, idx_t2, size_sino2);
B2.mask  = NaN;
m2 = [N2, N2];

D1 = getWaveletOperator(m1, 2, 1);
D2 = getWaveletOperator(m2, 2, 1);
% set parameters
alpha       = 1e-3;
beta        = 5e-1;
mu1         = 1e1;
mu2         = [];
lambda      = [];
adaptive    = [];
maxIter     = 100;
Normalize   = false;
doPlot      = false;
doTrack     = false;
doReport    = true;


%% solve

out1   = TVOnlysolver(I1_cont(:), m1, B1, D1, alpha, beta, mu1, mu2, ...
                       'lambda', lambda, ...
                       'adaptive', adaptive, ...
                       'doReport', doReport,...
                       'Normalize', Normalize, ...
                       'maxIter', maxIter, ...
                       'doPlot', doPlot, ...
                       'doTrack', doTrack);

out2   = TVOnlysolver(I2_cont(:), m2, B2, D2, alpha, beta, mu1, mu2, ...
                       'lambda', lambda, ...
                       'adaptive', adaptive, ...
                       'doReport', doReport,...
                       'Normalize', Normalize, ...
                       'maxIter', maxIter, ...
                       'doPlot', doPlot, ...
                       'doTrack', doTrack);

out3   = TVOnlysolver(I1_simple(:), m1, B1, D1, alpha, beta, mu1, mu2, ...
                       'lambda', lambda, ...
                       'adaptive', adaptive, ...
                       'doReport', doReport,...
                       'Normalize', Normalize, ...
                       'maxIter', maxIter, ...
                       'doPlot', doPlot, ...
                       'doTrack', doTrack);

%Vout4   = TVOnlysolver(I2_simple(:), m2, B2, D2, alpha, beta, mu1, mu2, ...
%                       'lambda', lambda, ...
%                       'adaptive', adaptive, ...
%                       'doReport', doReport,...
%                       'Normalize', Normalize, ...
%                       'maxIter', maxIter, ...
%                       'doPlot', doPlot, ...
%                       'doTrack', doTrack);


im_rec1  = out1.rec;
im_rec1_cp = im_rec1;
idx_low1  = im_rec1 < 0;
idx_high1 = im_rec1 > 1;
im_rec1(idx_low1)  = 0;
im_rec1(idx_high1) = 1;

im_rec3  = out3.rec;
im_rec3_cp = im_rec3;
idx_low3  = im_rec3 < 0;
idx_high3 = im_rec3 > 1;
im_rec3(idx_low3)  = 0;
im_rec3(idx_high3) = 1;


im_rec2  = out2.rec;
im_rec2_cp = im_rec2;
idx_low2  = im_rec2 < 0;
idx_high2 = im_rec2 > 1;
im_rec2(idx_low2)  = 0;
im_rec2(idx_high2) = 1;

%im_rec4  = out4.rec;
%im_rec4_cp = im_rec4;
%idx_low4  = im_rec4 < 0;
%idx_high4 = im_rec4 > 1;
%im_rec4(idx_low4)  = 0;
%im_rec4(idx_high4) = 1;



fname1 = sprintf('rad_TV_cont_N_%d_views_%d_itr_%d', N1, views, maxIter);
fname2 = sprintf('rad_TV_cont_N_%d_views_%d_itr_%d', N2, views, maxIter);
fname3 = sprintf('rad_TV_disc_N_%d_views_%d_itr_%d', N1, views, maxIter);
%fname4 = sprintf('rad_TV_disc_N_%d_views_%d_itr_%d', N2, views, maxIter);

imwrite(im2uint8(cil_scale_to_01(im_rec1_cp)), fullfile(dest,[fname1, '_raw.png']));
imwrite(im2uint8(cil_scale_to_01(im_rec2_cp)), fullfile(dest,[fname2, '_raw.png']));
imwrite(im2uint8(cil_scale_to_01(im_rec3_cp)), fullfile(dest,[fname3, '_raw.png']));
%imwrite(im2uint8(cil_scale_to_01(im_rec4_cp)), fullfile(dest,[fname4, '_raw.png']));
imwrite(im2uint8(cil_scale_to_01(im_rec1)), fullfile(dest,[fname1, '_post.png']));
imwrite(im2uint8(cil_scale_to_01(im_rec2)), fullfile(dest,[fname2, '_post.png']));
imwrite(im2uint8(cil_scale_to_01(im_rec3)), fullfile(dest,[fname3, '_post.png']));
%imwrite(im2uint8(cil_scale_to_01(im_rec4)), fullfile(dest,[fname4, '_post.png']));


