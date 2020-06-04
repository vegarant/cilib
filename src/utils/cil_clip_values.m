% Remove all values of X which lies outside the interval [a, b] in the sense
% that values less than a will be set to a and values greater than b will be sat
% to b.
function Y = cil_clip_values(X, a, b)
    idx_a = X < a;
    idx_b = X > b;
    X(idx_a) = a;
    X(idx_b) = b;
    Y = X;
end
