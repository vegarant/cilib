% Creates the shape of a ball with a given centre and radius in R^2
% with an appropriate norm.
%
% INPUT
% c      - An 2-tuple describing the x and y coordinates of the centre 
%          of the ball.
% r      - The radius of the circle
% p_norm - The type of norm to use. Can be any type supported by cil_map_norm
%
% OUTPUT
% A function that takes x and y coordinates, along with a scale, and returns
% an array where element k is 1 if the distance from c of [x(k) y(k)] is
% less than r*scale, and 0 otherwise.
%
% Kristian Monsen Haug 2017
function f = cil_shape_ball(c, r, p_norm)
    f = @(x, y, scale) (cil_map_norm(x-c(1), y-c(2), p_norm) <= r*scale);
end
