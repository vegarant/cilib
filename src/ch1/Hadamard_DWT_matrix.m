% Plot the absolute value of various matrices at log scale.
% - Hadamard matrix * DCT matrix
% - Hadamard matrix * inverse DWT Haar matrix
% - Hadamard matrix * inverse DWT DB4 matrix
% In all cases we plot the matrices for each of the three different ordering of the 
% Hadamard matrix.
% Vegard Antun 2016

clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end
disp_plots = 'off';
dwtmode('per', 'nodisp');

% Parameters
nu = 8; % 2^nu = signal size
hadamard_order = {'sequency', 'dyadic', 'hadamard'};
% Dependent parameters
N = 2^(nu);

% Compute the DCT matrix
Phi_dct = dctmtx(N); 

% Compute the Haar matrix
Phi_haar = zeros(N);
I = eye(N);
S = cil_get_wavedec_s(nu, wmaxlev(N,'Haar')-1);
for i=1:N
    Phi_haar(:,i) = waverec(I(:,i), S, 'Haar');
end

wname = 'db4';

Phi_db4 = zeros(N);
I = eye(N);
S = cil_get_wavedec_s(nu, wmaxlev(N, wname));
for i=1:N
    Phi_db4(:,i) = waverec(I(:,i), S, wname);
end


N = 2^nu;
n_max_value  = -nu;

for i = 1:length(hadamard_order)
    % Compute Hadamard matrix
    H = sqrt(N)*fwht(eye(N), N, hadamard_order{i});
    
    % Plot H*Phi for DCT matrix
    HPhi = H*Phi_dct;
    HPhi_abs = abs(HPhi);    
    im = max(log2(HPhi_abs), n_max_value);
    im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]
    
    fname = fullfile(dest, sprintf('Hadamard_DCT_matrix_%s.%s',...
                                    hadamard_order{i}, cil_dflt.image_format));
    imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);
    
    % Plot H*Phi for Haar wavelets
    HPhi = H*Phi_haar;
    
    HPhi_abs = abs(HPhi);    
    im = max(log2(HPhi_abs), n_max_value);
    im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]
    
    fname = fullfile(dest, sprintf('Hadamard_haar_matrix_%s.%s',...
                                    hadamard_order{i}, cil_dflt.image_format));
    imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);
    
    % Plot H*Phi for DB4 wavelets
    HPhi = H*Phi_db4;
    HPhi_abs = abs(HPhi);    
    im = max(log2(HPhi_abs), n_max_value);
    im = (im - n_max_value)/(-n_max_value); % Scale to [0,1]
    
    fname = fullfile(dest, sprintf('Hadamard_%s_matrix_%s.%s', wname,...
                                    hadamard_order{i}, cil_dflt.image_format));
    
    imwrite(im2uint8(im), cil_dflt.cmap_matrix,fname);
    
end 



