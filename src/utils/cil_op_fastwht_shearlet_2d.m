function y = cil_op_fastwht_shearlet_2d(x, mode, N, idx, shearlet_system)

    if (~isvector(x))
        error('Input is not a vector');
    end

    R = round(log2(N));

    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end

    dim3 = length(shearlet_system.RMS);

    if (mode == 1)
        
        x = reshape(x, [N, N, dim3]);
        z = SLshearrec2D(x, shearlet_system);
        z = cil_op_fastwht_2d(z);
        y = z(idx);

    else % Transpose

        z = zeros([N, N]);
        z(idx) = x;
        z = cil_op_fastwht_2d(z);
        z = SLsheardec2D(z, shearlet_system);
        y = reshape(z, [N*N*dim3, 1]);
    end

end

