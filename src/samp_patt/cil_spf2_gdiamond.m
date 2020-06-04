function [idx, str_id] = cil_spf2_gdiamond(N, nbr_samples, a, r0, nbr_levels)

    r = 1;
    p_norm = 1;

    [idx, str_id] = cil_spf2_exp(N, nbr_samples, a, r0, nbr_levels, r, p_norm); 

end
