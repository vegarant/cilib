function cil_validate_sample_args(im, sigma, idx)
    
    N  = size(im,1);
    if (N ~= size(im,2))
       error('cilib:Invalid_size',...
             'The size of the image matrix must be square'); 
    end
     
    dim = round(log2(N));                  % Size of image is 2^dim × 2^dim
     
    if (2^dim ~= N) 
       error('cilib:Invalid_size', ...
             'The size of the image must be of the form 2^R × 2^R, for R ∈ ℕ');
    end
     
    if (sigma < 0)
        error('cilib:value_error', 'sigma must be nonnegative'); 
    end
     
    if (max(idx(:)) > N*N || min(idx(:)) < 1)
        error('cilib:value_error', 'idx exceeds matrix dimension');
    end
end
