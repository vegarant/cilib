% Creates a multi-level sampling pattern with center frequency [1,1], 
% and a p_norm-ball as the the sampling level shape. 
% 
% INPUT
% N           - Size of image is N x N
% nbr_samples - Number of samples
% 0 < m < 1   - Faction of N we would like to fully sample.
% nbr_levels  - Number of sampling levels
% r           - Radius of the l_p balls TODO document this better. 
% p_norm      - (sum |x|^p)^(1/p) where p = p_norm.
% 
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
% 
% Vegard Antun, 2017.
function [idx, str_id] = cil_sph2_exp(N, nbr_samples, a, r0, nbr_levels, r, p_norm)
    str_id = sprintf('h_exp%g', p_norm);
    str_id = strrep(str_id, '.', '_'); % remove '.' sign
    c = [0,0]; % Center frequency

    sh_ball = cil_shape_ball(c, r, p_norm);
    idx = cil_sp2_exp(N, nbr_samples, sh_ball, a, r0, nbr_levels);

end
