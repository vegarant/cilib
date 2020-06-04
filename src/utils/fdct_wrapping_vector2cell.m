% Rehapes the vector x to a cell-array so that we can apply the inverse
% curvelet transform. 
function C = fdct_wrapping_vector2cell(x, curvelet_system) 
    
    C = cell(size(curvelet_system));
    s = 1;
    for i = 1:length(curvelet_system);
        C{i} = cell(size(curvelet_system{i}));
        for j = 1:length(curvelet_system{i})
            k = prod(curvelet_system{i}{j});
            C{i}{j} = reshape(x(s:s+k-1), curvelet_system{i}{j});
            s = s + k;
        end
    end
end

