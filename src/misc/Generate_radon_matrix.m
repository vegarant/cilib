% Generates the algebraic discritization of the radon transform and store it 
% as a matrix. Modify the values of `N` and `nbr_angles` according to which 
% matrix you would like to generate. If you don't want equidistant angles 
% do also modify `theta`. 
%
% Code inspired by code from Jackie Ma, see https://github.com/jky-ma/ShearletReweighting
%
% Vegard Antun, 2020.

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

N = 256;
nbr_angles = 50;

theta = linspace(0, 180*(1-1/nbr_angles), nbr_angles);

N2 = N*N;
f = @(x) radon(x, theta);


Gx = [];
Gi = [];
Gj = [];

tic;
X = zeros([N,N]);
for ii = 1:N2
    X(ii) = 1;
    Y = f(X);
    y = Y(:);
    X(ii) = 0;

    [i,j,x] = find(y); % row, col, val; (i, 1, x);
    n = length(x);
    Gi = [Gi; i];
    Gj = [Gj; ii*ones(n,1)];
    Gx = [Gx; x];
    cil_progressbar(ii,N2); 
end
toc;
A = sparse(Gi, Gj, Gx, length(y), N2);


%% get direction for results
dest = cil_dflt.data_path;
fname = sprintf('radonMatrix2N%d_ang%d.mat', N, nbr_angles);

save(fullfile(dest, 'radon_matrices', fname),'A');

