function [idx, str_id] = cil_sp2_power_law(N, nbr_samples, alpha, center)
    str_id = 'power_law_2d';

    [X,Y] = meshgrid(1:N);
    X = X - center(1);
    Y = Y - center(2);
    P = 1./( 1 + X.^2 + Y.^2 ).^(alpha);
    P = P/sum(P(:));

    prob = reshape(P, [N^2, 1]);
    idx = datasample(1:N^2, nbr_samples,'Replace', false, 'Weights', prob);
    idx = sort(idx');
end 
