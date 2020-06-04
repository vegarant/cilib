function [idx, str_id] = cil_sph2_power_law(N, nbr_samples, alpha)
    str_id = sprintf('hpower_law_%g', alpha);
    [idx, ~] = cil_sp2_power_law(N, nbr_samples, alpha, [1, 1]);
end
