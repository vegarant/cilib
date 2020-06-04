% Creates an NxN matrix where the elements belonging to the edge or
% interior of the given shape are set to 1, and 0 otherwise.
%
% INPUT
% shapef - A function that takes a list of x-coordinates, y-coordinates,
%          and a scale parameter, and returns an array where element k
%          is 1 if [x(k) y(k)] belongs to the shape, and 0 otherwise.
% N      - The size. The function will return an NxN-matrix. The
%          coordinate system will be the cartesian product
%          {1,..,N}x{1,..,N}.
% scale  - How much the shape should be scaled. e.g if shapef is a
%          circle with radius r, we will get circle with radius 2*r.
%
% OUTPUT
% An NxN-matrix where element (i, j) will be one if  [i j] belongs t
% the shape.
%
%
% Kristian Monsen Haug 2017
function im = cil_shape(shapef, N, scale)
    im = false([N, N]);
                                % create coordinate system
    ax = 1:N;
    [x, y] = meshgrid(ax, ax);
    x = x(:);
    y = y(:);

    inshape = shapef(x, y, scale);
    idx = sub2ind([N, N], x(inshape), y(inshape));
    im(idx) = 1;

                  % convert to logicals so it can be used for masking.
    %im = logical(im);
end
