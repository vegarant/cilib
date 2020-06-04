% Creates a multi-level sampling pattern by using a general scalable
% shape function as the boundaries between the levels in addition to
% the full square. Each level will correspond to a scaling of the
% shape.
% 
% NOTE: When the number of levels and the size (N) are large, the function 
%       is rather slow.
%
% INPUT
% N - The size of one edge of the square.
% shapef - The shape to use.
% scales - an array containing the scales to use.
% levles - number of samples within each level
%
% OUTPUT:
% Sampling pattern, given in an linear ordering. That is indices in the range
% 1,2, ..., N*N.
%
% Kristian Monsen Haug 2017
function idx = cil_sp_from_shape(N, shapef, scales, levels)

    Y = reshape(1:N^2, [N, N]);
    idx = [];
    im_prev = zeros([N, N]);

    %% Sample each level defined by the shape
    for k=1:length(levels)-1

        im_shape = cil_shape(shapef, N, scales(k));
        %% Remove what is in common with the previous level.
        current_level = xor(im_shape, im_prev);
        idx  = [idx ; datasample(Y(current_level), levels(k), 'replace', false)];
        im_prev = im_shape;
    end

    %% Sample the full square
    full_square = Y(xor(im_prev, ones([N, N])));
    full_square_samples = datasample(full_square, levels(end), 'replace', false);
    idx = [idx ; full_square_samples];

end
