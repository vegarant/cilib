% Plot the absolute value of various matrices at log scale.
% - Bernoulli matrix * DCT matrix
% - Bernoulli matrix * inverse DWT Haar matrix
% - Bernoulli matrix * inverse DWT DB4 matrix
% Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

path_to_this_file = mfilename('fullpath');
path_to_this_file = path_to_this_file(1:end-length(mfilename)-1);
dest = fullfile(path_to_this_file, 'plots');

% Create destination for the plots
if (exist(dest) ~= 7) 
    mkdir(dest);
end

disp_plots = 'off';
dwtmode('per', 'nodisp');

% Parameters
nu = 8; % 2^nu = signal size

% Dependent parameters
N = 2^(nu);
m = 2^(nu-1);

% compute A
A = 2*randi(2,m,N) - 3*ones(m,N); 

%%%%%%%%%%%%%%%%%%%%%%%%%% Compute Phi for DCT basis %%%%%%%%%%%%%%%%%%%%%%%%%%
Phi = dctmtx(N);
APhi = A*Phi;

APhi_abs = abs(APhi);
N = 2^nu;
n_max_value  = -nu;
im = max(log2(APhi_abs), n_max_value);
im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]

fname = fullfile(dest, sprintf('Bernoulli_DCT_matrix.%s', cil_dflt.image_format));
imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);

%%%%%%%%%%%%%%%%%%%%%%%%% Compute Phi for Haar basis %%%%%%%%%%%%%%%%%%%%%%%%%%
Phi = zeros(N);
I = eye(N);
S = cil_get_wavedec_s(nu, wmaxlev(N,'Haar')-1);
for i=1:N
    Phi(:,i) = waverec(I(:,i), S, 'Haar');
end

APhi = A*Phi;
APhi_abs = abs(APhi);
im = max(log2(APhi_abs), n_max_value);
im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]

fname = fullfile(dest, sprintf('Bernoulli_haar_matrix.%s', cil_dflt.image_format));
imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);

%%%%%%%%%%%%%%%%%%%%%%%%%% Compute Phi for DB6 basis %%%%%%%%%%%%%%%%%%%%%%%%%%%
Phi = zeros(N);
I = eye(N);

wname = 'db4';
S = cil_get_wavedec_s(nu, wmaxlev(N,wname));
for i=1:N
    Phi(:,i) = waverec(I(:,i), S, wname );
end

APhi = A*Phi;
APhi_abs = abs(APhi);
im = max(log2(APhi_abs), n_max_value);
im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]

fname = fullfile(dest, sprintf('Bernoulli_%s_matrix.%s',wname, cil_dflt.image_format));
imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);

