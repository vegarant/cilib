% Let the length of x be N. Let M = {1, ..., N} and let M_{L} ⊂ M with 
% |M_{L}| = L and |x_i| > |x_j| for all i ∈ M_{L} and j ∈ M \ M_{L}. 
% For eps ∈ [0,1] this function computes 
%          min{ L ∈ {1,...,N} : ||x_{M_{L}}||_2 ≥ eps*||x||_2 }
%
% INPUT
% x   - vector or matrix.
% eps - scalar in the interval [0,1].
%
% OUTPUT
% Minium number of entries in x needed to satisfy the ineqality above.
%
% Vegard Antun, 2018.
%
function L = local_sparsity(x, eps) 
    x = x(:);   % vectroize x
    N = length(x); 
    x = sort(abs(x),'descend');
    
    norm_x = norm(x, 2);
    
    s = 0;
    sq_sum = 0;
    while (sqrt(sq_sum) <= eps*norm_x & s < N) 
        sq_sum = sq_sum + x(s+1)*x(s+1);
        s = s + 1;
    end
    L = s;
end
