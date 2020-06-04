function [idx, str_id] = cil_spf2_exp(N, nbr_samples, a, r0, nbr_levels, r, p_norm)
    str_id = sprintf('f_exp%d', p_norm);
    
    c = [N/2-1,N/2-1]; % Center frequency

    sh_ball = cil_shape_ball(c, r, p_norm);
    idx = cil_sp2_exp(N, nbr_samples, sh_ball, a, r0, nbr_levels);

end

