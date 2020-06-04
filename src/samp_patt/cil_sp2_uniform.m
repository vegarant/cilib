% cil_spf2_uniform samples M samples uniformly at random from an N × N image
% 
% INPUT
% N - Image size i.e. N × N
% nbr_samples - Number of samples
%
% OUTPUT:
% idx   - Sampling pattern, given in an linear ordering. That is indices in the range
%         1,2, ..., N*N.
% str_id - String identifyer, describing which type of sampling pattern this is.  
%
function [idx, str_id] = cil_sp2_uniform(N, nbr_samples)
    str_id = 'uniform';
    idx = datasample(1:N^2, nbr_samples,'Replace',false);
    idx = idx';
end

