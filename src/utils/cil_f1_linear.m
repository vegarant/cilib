% Create a linear order of the Fourier coefficients.
%
% This function order the Fourier coefficients according to frequency. Hence
% the order becomes {0, -1, 1, -2, 2, -3, ... }. It is assumed that the
% original order of `U` is {0,1,2, ... ,-3, -2, -1}.  This is the default order
% whenever one call the `fft` function.
%
% INPUT
% U - Vector or matrix whose rows will be shifted. Make sure any vector is column vector.
% 
% OUTPUT
% A matrix of vector where the rows have been permuted.
%
function Y = cil_f1_linear(U)
    N = size(U,1);
    Y = zeros(size(U));
    Y(1:2:N,:) = U(1:N/2,:);
    Y(2:2:N,:) = U(N:-1:N/2+1,:);
end
