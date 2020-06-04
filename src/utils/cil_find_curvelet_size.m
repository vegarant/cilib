% The curvelet transform return a cell-array with all its coefficents, in 
% order to obtain a fast inverse curvelet transform, we need to know the size of
% this in advance. This funtion return a cell array `C` containg all relevant 
% sizes and the total length `n` of the output vector.
function [C, n] = cil_find_curvelet_size(X, is_real)
    Y = fdct_wrapping(X, is_real);
    C = cell(size(Y));
    n = 1;
    for i = 1:length(Y)
        for j = 1:length(Y{i})
            n = n + prod(size(Y{i}{j}));
            C{i}{j} = size(Y{i}{j});
        end
    end
end

