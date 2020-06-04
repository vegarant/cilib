% Generate weights within each sparsity level of a 2d wavelet transform
% N is assumed to be N = 2^r for r ∈ ℕ and N is the length of a N×N signal.
%
% INPUT
% N - Lenght of a N×N signal
% sparsities - local sparsities 
% 
% OUTPUT
% weights - Vector of length N^2 assuming the matlab wavelet toolbox ordering  
%           of the wavelet coefficents. 
function weights = cil_generate_weights(N, sparsities)
    
    r = round(log2(N));
    l = length(sparsities);
    h = r-l;
    
    weights = ones(N*N, 1);
    s = sum(sparsities);
    a = 0;
    for k = 1:l
        b = 2^(h+k-1);
        weights(a+1:b,1) = s/sqrt(sparsities(k));
        a = b; 
    end
    
end
