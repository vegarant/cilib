function [idx, str_id] = cil_sph2_gsquare(N, nbr_samples, a, r0, nbr_levels)
    r = 1;
    p_norm = inf;
    [idx, str_id] = cil_sph2_exp(N, nbr_samples, a,r0, nbr_levels, r, p_norm);
end

