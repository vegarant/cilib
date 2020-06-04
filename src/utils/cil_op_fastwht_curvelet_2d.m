function y = cil_op_fastwht_curvelet_2d(x, mode, N, idx, curvelet_system, n, is_real);

    if (~isvector(x))
        error('Input is not a vector');
    end

    R = round(log2(N));

    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end

    if (mode == 1)

        C = fdct_wrapping_vector2cell(x, curvelet_system);
        z = ifdct_wrapping(C, is_real, N,N);
        z = cil_op_fastwht_2d(z);
        y = z(idx);

    else % Transpose

        z = zeros([N, N]);
        z(idx) = x;
        z = cil_op_fastwht_2d(z);
        C = fdct_wrapping(z, is_real, 2);
        y = fdct_wrapping_create_vector(C, n);

    end
    
end






