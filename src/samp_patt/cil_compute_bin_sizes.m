% Computes the number of samples withing each sampling level.
%
% INPUT
% N      - Size of image is N x N
% shapef - Function handle shape(x,y,scale), telling whether or not the
%          coordinates x and y is contained in the scale. 
% scales - Array with integers in the interval [1,N] describing the sampling
%          level boundaries. 
%
% OUTPUT
% Array of length length(scales)+1, where the last element, describes the
% number of samples outside the final sampling level.
%
% Vegard Antun, 2017.
% 
function bins = cil_compute_bin_sizes(N, shapef, scales);
    
    n = length(scales);
    bins = zeros([1, n+1]);
    im_prev = false([N, N]);
    
    for k=1:n

        im_shape = cil_shape(shapef, N, scales(k));
        %% Remove what is in common with the previous level.
        current_level = xor(im_shape, im_prev);
        %idx  = [idx ; datasample(Y(current_level), round(p(k)*sum(sum(current_level))), 'replace', false)];
        im_prev = im_shape;
        
        bins(k) = sum(current_level(:));
    end
    bins(n+1) = sum(sum((xor(im_prev, true([N, N])))));
    
end
