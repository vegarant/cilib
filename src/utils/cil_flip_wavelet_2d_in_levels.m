% For each wavelet scale, flip the wavelet entries 
%
% It is assumed that dwtmode is per
%
% INPUT
% c - wavelet coefficients, obtained using wavedec2
% S - wavelet structure obtained from wavedec2
%
% OUTPUT
% c_flipped - the wavelet coefficients where each wavelet scale have been
%             flipped
function c_flipped = cil_flip_wavelet_2d_in_levels(c, S)
    c_flipped = zeros(size(c));
    
    % Flip low scale approximation
    s = S(1,1)*S(1,2);
    c_flipped(1:s) = flip(c(1:s));

    n = size(S,1);
    for i = 1:n-2
        % Flip each of the detail layers
        s1 = S(i+1,1)*S(i+1,2);
        idx = 1:s1;
        for k = 1:3;
            c_flipped(s+idx) = flip(c(s+idx));
            s = s + s1;
        end
    end
end


