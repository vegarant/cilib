% Creates the shape of a ring. It's purpose is mainly to demonstrate
% the possibility to combine shapes
%
% INPUT
% c - An 2-tuple describing the x and y coordinates of the centre.
% inner_r - The radius of the inner ball.
% outer_r - The radius of the outer ball.
% p - The type of norm to use. Can be any type supported by cil_map_norm.
%
% OUTPUT
% A function that takes x and y coordinates, along with a scale, and returns
% an array where element k is 1 if the distance from c of [x(k) y(k)] is
% only inside the larger ball, but not the smaller, and 0 otherwise.
%
% Kristian Monsen Haug 2017
function f = cil_shape_ring(center, inner_r, outer_r, p)
    inner = cil_shape_ball(center, inner_r, p);
    outer = cil_shape_ball(center, outer_r, p);
    f = @(x, y, scale) (outer(x, y, scale) & ~inner(x, y, scale));
end
