function z = cil_op_wavelet_2d(x, mode, N, nres, wname)
    if (~isvector(x))
        error('Input is not a vector');
    end
    
    R = round(log2(N));
    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end
    S = cil_get_wavedec2_s(R, nres); 
    
    if (mode == 1)

        x = reshape(x, [N,N]);
        [z1,S] = wavedec2(real(x), nres, wname);
        [z2,S] = wavedec2(imag(x), nres, wname);
        z = z1' + 1j*z2';

    else % Transpose
        
        z1 = waverec2(real(x), S, wname);
        z2 = waverec2(imag(x), S, wname);
        z = z1+1j*z2;
        z = z(:);

    end

end

