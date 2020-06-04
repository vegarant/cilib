% Computes the M(s, k_1, k_2) for the sparsity `s`, and returns 
% matrix with the values of M for all values of k_1 and k_2
function density = cil_compute_density_DAS_fourier(N, sparsity, vm)
    r = round(log2(N));
    nres_p_1 = numel(sparsity); % nres + 1 = Number of sampling levels
    J_0 = r - nres_p_1;

    m_mat = zeros([nres_p_1, nres_p_1]);

    qValues = [0, 0.339, 0.636, 0.913, 1.177, 1.432, 1.682, 1.927, 2.168, 2.406];
    q = qValues(vm);    

    m_mat = zeros([nres_p_1, nres_p_1]);

    for k1=1:nres_p_1
        for k2=k1:nres_p_1
            m = 0;
            for l=1:k1
                m = m + sparsity(l)*2^( -(2*q+1)*(k1-l) - (2*q+1)*(k2-l)  );
            end

            for l=k1+1:k2
                m = m + sparsity(l)*2^(-(l-k1)-(2*q+1)*(k2-l));
            end

            for l=k2+1:nres_p_1
                m = m + sparsity(l)*2^(-(l-k1)-(2*vm+1)*(l-k2));
            end
            m_mat(k1,k2) = m;
            m_mat(k2,k1) = m;
        end
    end
    % Multiply an extra factor 2 in the first layers to compencate for the 
    % fact that the two first sparsity layes have the same size
    m_mat(1:end, 1) = 2*m_mat(1:end, 1);
    m_mat(1, 1:end) = 2*m_mat(1, 1:end);

    density = m_mat;

end

