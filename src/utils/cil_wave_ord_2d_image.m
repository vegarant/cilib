% Create a image with all the wavelet coefficents in the different levels
% grouped togheter. The algorithm assumes the dwtmode is 'per'.
%
%  +-----------------------------------+
%  |  |    |        |                  |
%  |--+    |        |                  |
%  |       |        |                  |
%  |-------+        |                  |
%  |                |                  |
%  |                |                  | 
%  |                |                  | 
%  |----------------+                  |   
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  |                                   |
%  +-----------------------------------+
%
% IMPROVE: Future version should not include the wavelet name parameter
%
% INPUT
% The input is the same as the output from wavedec2
% c     - Wavelet coefficents
% s     - Structure matrix representing the wavelet coefficients.
% wname - Name of the wavelet used
%
% OUTPUT
% An image with the wavelet coefficients.
%
% Edvard Aksnes, 2017
% 
function coefs = cil_wave_ord_2d_image(c,s,wname)
    % Recover N by noting that s is a N+2 by 2 matrix
    [sy,sx] = size(s);
    N = sy - 2;
    
    % Extract the low resolution approximation
    coefs = appcoef2(c,s,wname);
    for k = N:-1:1
        % Extract the detail coefficients 
        [H V D] = detcoef2('a',c,s,k);
        % Group the coefficients together 
        coefs = [coefs, V; H, D];
    end
end

