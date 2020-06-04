function [idx, str_id] = cil_spf2_gcircle(N, nbr_samples, a, r0, nbr_levels)

    r = 1/sqrt(2);
    p_norm = 2;

    [idx, str_id] = cil_spf2_exp(N, nbr_samples, a, r0, nbr_levels, r, p_norm); 

end
