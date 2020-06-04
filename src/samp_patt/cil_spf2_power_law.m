function [idx, str_id] = cil_spf2_power_law(N, nbr_samples, alpha)
    str_id = sprintf('fpower_law_%g', alpha);
    [idx, ~] = cil_sp2_power_law(N, nbr_samples, alpha, [N/2, N/2]);
end
