function data_struct = cil_get_cont_fourier_wavelet_datai(N, M, idx, vm)
    
    mask = zeros(N,N);
    mask(idx) = 1;
    %mask_raw = zeros(M,M);
    %mask_raw(idx) = 1;
    %range = (N/2-M/2+1):(N/2+M/2);
    %mask(range, range) = mask_raw; 

    R = round(log2(M)); 
    eps = 1;
    S = 1;
    data_struct.mask = mask;
    data_struct.R = R;
    data_struct.eps = eps;
    data_struct.S = 1;
    data_struct.N = N;
    data_struct.M = M;
    data_struct.vm = vm;
    if vm==1  % the case of Haar wavelets
        ft_sca= haar_phi_ft(((M:-1:-M+1)./(2^R/eps))');
        data_struct.ft_sca = ft_sca;
    else     % the case of boundary corrected wavelets
        [ft_sca_L, ft_sca, ft_sca_R] = CDJV_Setup(vm, eps, S, R);
        data_struct.ft_sca_L = ft_sca_L;
        data_struct.ft_sca_R = ft_sca_R;
        data_struct.ft_sca = ft_sca;
    end
    
    
end
