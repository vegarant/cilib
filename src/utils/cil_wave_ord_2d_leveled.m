% The inverse map of the `cil_wave_ord_2d_image` function. It returns an array
% with the wavelet ordering used by Matlab
% 
% INPUT:
% x - Imput image, assumed to be N × N
% S - Structure matrix representing the wavelet coefficients.
%
% OUTPUT
% An array where the wavelet coefficients have the ordering used by Matlab.
%
% Vegard Antun, 2020.
function c = cil_wave_ord_2d_leveled(x, S);
    % [A, V ; H, D]
    
    % [A, H, V, D]
    c = zeros(1, prod(size(x)));
    % Extract A
    c(1:S(1,1)*S(1,2)) = reshape(x(1:S(1,1), 1:S(1,2)), 1, S(1,1)*S(1,2));
    
    c_idx = S(1,1)*S(1,2);
    for i = 2:size(S,1)-1;
        
        rl = S(i, 1);   % Row low
        rh = S(i+1, 1); % Row high
        cl = S(i, 2);   % Column low
        ch = S(i+1, 2); % Column high
        
        % Extract H
        size_H = (rh-rl)*( ch-cl); 
        c(c_idx + (1:size_H)) =  reshape( x( rl+1:rh, 1:cl ), 1, size_H);
        c_idx = c_idx + size_H; 
        
        % Extract V
        c(c_idx + (1:size_H)) =  reshape( x(  1:rl, cl+1:ch), 1, size_H);
        c_idx = c_idx + size_H; 
    
        % Extract D
        c(c_idx + (1:size_H)) =  reshape( x(  rl+1:rh, cl+1:ch), 1, size_H);
        c_idx = c_idx + size_H; 
    end
end

