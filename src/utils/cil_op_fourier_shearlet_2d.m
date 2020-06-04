

function y = cil_op_fourier_shearlet_2d(x, mode, N, idx, shearlet_system, device)

    if (nargin > 5)
        use_gpu = 1;
    else
        use_gpu = 0;
    end

    if (~isvector(x))
        error('Input is not a vector');
    end

    R = round(log2(N));

    if (abs(2^R - N) > 0.5) 
        error('Input length is not equal 2^R for some R ∈ ℕ');
    end

    dim3 = length(shearlet_system.RMS);


    if (use_gpu)
        x = gpuArray(x);
    %    wait(device);
    end

    if (mode == 1)
        
        x = reshape(x, [N, N, dim3]);
        z = SLshearrec2D(x, shearlet_system);
        z = fftshift(fft2(z))/N;
        y = z(idx);

    else % Transpose
        if use_gpu
            z = gpuArray(zeros([N, N]));
        else 
            z = zeros([N, N]);
        end
        z(idx) = x;
        z = ifft2(ifftshift(z))*N;
        z = SLsheardec2D(z, shearlet_system);
        y = reshape(z, [N*N*dim3, 1]);
    end
    if (use_gpu)
        y = double(gather(y));
    %    wait(device);
    end
end
