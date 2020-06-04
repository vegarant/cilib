% Reverse the linear ordering produced by the cil_f1_linear function.
%
% INPUT
% U - Vector or matrix whose rows will be shifted. Make sure any vector is column vector.
% 
% OUTPUT
% A matrix of vector where the rows have been permuted.
%
function Y = cil_f1_linear_inv(U)
    N = size(U,1);
    Y = zeros(size(U));
    Y(1:N/2, :)    = U(1:2:N,:);
    Y(N:-1:N/2+1,:) = U(2:2:N,:);
end
