% For a N×N image, it samples `nbr_samples` according to the coherence density. 
% The coherence structure is competed for the change of basis matrix between 
% Walsh functions and Dauberchies wavelets with more than two vanishing moments.
% Note that the densities will be different for the Haar wavelet. 
%
% INPUT:
% N - Size of sampling pattern (N×N).
% nbr_samples - Total number of samples  
% sparsity - vector with local sparsities in each level. The first level is the
%            coarsest scale
%
% OUTPUT
% idx - linear indices of the chosen samples
% str_id - String identifyer, describing which type of sampling pattern this is.  
function [idx, str_id] = cil_sph2_DAS(N, nbr_samples, sparsity)
    str_id = 'DAS';

    r = round(log2(N));
    nres = numel(sparsity);
    J0 = r - nres;

    bv = [];
    for i = 1:nres
        bv =[bv, 2^(J0+i)];
    end
    bh = bv;

    density = compute_density(N, sparsity);
    idx = cil_sph2_multi(nbr_samples, density, bv, bh);

end

% Computes the densities for a given wavelet.
%
% INPUT:
% r - Number of levels. Sampling levels will be M = [2^(J_0+1), ..., 2^(J_0+r)].
% J_0 - Minimum wavelet decomposition level
% vm  - Number of vanishing moments
%
% OUTPUT:
% density - Density matrix.
function density = compute_density(N, sparsity)
    
    r = round(log2(N));
    nres = numel(sparsity);
    J_0 = r - nres;
    
    m_mat = zeros([nres, nres]);
    
    for k1=1:nres
        for k2=1:nres
            m = 0;
            if ( k1 > 1 & k2 > 1)
    
                for l = 1:nres
                    m = m + sparsity(l)*2^( -abs(l-k1) - abs(l-k2) );
                end
    
            elseif (k1 == 1 & k2 > 1)
    
                for l = 1:nres
                    m = m + 4*sparsity(l)*2^( -l - abs(l-k2) );
                end
    
            elseif (k1 > 1 & k2 == 1)
            
                for l = 1:nres
                    m = m + 4*sparsity(l)*2^( -l - abs(l-k1) );
                end
            
            elseif (k1 == 1 & k2 == 1)
    
                for l = 1:nres
                    m = m + 16*sparsity(l)*2^( -2*l);
                end
            
            else
                disp('Something in my logic is wrong')
            end
            m_mat(k1,k2) = m;
        end
    end
    
    density = m_mat/sum(m_mat(:));
end
