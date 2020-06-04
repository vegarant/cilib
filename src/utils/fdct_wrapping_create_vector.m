% Reshapes the cell-array `C` to a vector of length `n`.
function y = fdct_wrapping_create_vector(C, n)

    y = zeros([n, 1]);

    s = 1;
    for i = 1:length(C)
        for j = 1:length(C{i})
            k = prod( size(C{i}{j}) );
            y(s:s+k-1) = reshape(C{i}{j}, [k, 1]);
            s = s + k; 
        end
    end
end

