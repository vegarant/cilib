% A vectorized norm function for getting the norm of multiple vectors
% in R^2 at once.
%
% INPUT
% x - x-coordinates or array of N x-coordinates
% y - y-coordinates or array of N y-coordinates
% p - Choice of norm. A natural number for the p-norm,
%     or +/- Inf for the supremum/infimum norm.
%
% OUTPUT
% An array of norm(-values) where element k is the norm of the 2D vector [x(k) y(k)]
%
% TODO: Should it take just a nx2 array instead?
% TODO: Handle incorrect input
%
% Kristian Monsen Haug 2017
function res = cil_map_norm(x, y, p)
    if (size(x, 2) ~= 1)
        x = x';
    end
    if (size(y, 2) ~= 1) 
        y = y';
    end
    if (p == 1)
        res = sum(abs([x y]), 2);
    elseif (p == 2)
        res = ((x).^2 + (y).^2).^0.5;
    elseif (p == Inf)
        res = max(abs([x, y]),[], 2);
    elseif (p == -Inf)
        res = min(abs([x, y]),[], 2);
    else
        res = ((x).^p + (y).^p).^(1/p);
    end
end
