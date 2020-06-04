% This function does a continuous fourier-wavelet transform
% See the readme.md on how to set up the dependencies so to make it work
function z = cil_cont_fourier_wavelet_2d(x, mode, wave_data)
    
    mask = wave_data.mask;
    R = wave_data.R;
    eps = wave_data.eps;
    S = wave_data.S;
    N = wave_data.N;
    vm = wave_data.vm;

    if vm == 1
        if or( isfield(wave_data,'ft_sca_L'), isfield(wave_data,'ft_sca_R'))
            fprintf('WARNING: wave_data contain fields it should not contain\n');
            fprintf('         are you sure you provided the right data');
        end
    end
    
    if vm==1
        z = Haar_Op2_VecHandle(mode, x, S, eps, R, ...
                                                 wave_data.ft_sca, mask);
    else
        z = CDJV_Op2_VecHandle(mode, x, S, eps, R, vm, ...
           wave_data.ft_sca, wave_data.ft_sca_L, wave_data.ft_sca_R, mask);
    end

end
