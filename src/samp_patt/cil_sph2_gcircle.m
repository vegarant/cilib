function [idx, str_id] = cil_sph2_gcircle(N, nbr_samples, a, r0, nbr_levels)
    r = sqrt(2);
    p_norm = 2;
    [idx, str_id] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, r, p_norm);
end

