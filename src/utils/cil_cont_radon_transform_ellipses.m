% Compute the continuous Radon transform of ellipses
% 
% This function computes the Radon transform of ellipses which have a constant 
% intensity value. For an excellent presentation of these formulas and how
% to derive them, we recommend having a look T.G. Feeman's book,
% "The Mathematics of Medical Imaging: A Beginner’s Guide", second edition,
% Springer, 2015.
%
% INPUT: 
% t - The ray bins one would like to sample, usually an array with values in
%     the range [-1, 1], or slightly outside. 
% theta -  Angles (in degrees) one would like to obtain the sinogram for.
% E - A n × 6 matrix, where each of the n rows, contains the parameters 
%     used to define an ellipsis uniquely. The columns of E contains the
%     following parameters:
%     E(i, 1) - A : Additive intensity value of the ellipse
%     E(i, 2) - a : Length of the horizontal semiaxis of the ellipse
%     E(i, 3) - b : Length of the vertical semiaxis of the ellipse
%     E(i, 4) - x0 : x-coordinate of the center of the ellipse
%     E(i, 5) - y0 : y-coordinate of the center of the ellipse
%     E(i, 6) - phi : Angle (in degrees) between the horizontal semiaxis of 
%                     the ellipse and the x-axis of the image
%     For more information on these parameters see matlabs documentation for 
%     the `phantom` function.
%
% OUTPUT:
% Returns the sum of the sinograms of all the ellipses specified in E.
%
% Advice for choosing t: To be consistent with matlabs' implementation
% of the Radon transform, one can call the [`I, xp] = radon(image, theta)`.
% Then xp represent the radial coordinates corresponding to each row of the
% image. The values of xp are usually `-t_max:t_max`, for some t_max. How
% Matlab chooses t_max, is unknown, but a guess which works reasonably well
% for N×N images are `t_max = floor(N/sqrt(2)) + 2`. One can then set 
% `t = (-t_max:t_max)/(N/sqrt(2))`, in which case some of the t-values
% might lie slightly outside [-1,1].  
function I = cil_cont_radon_transform_ellipses(t, theta, E);
    n = size(E, 1);    
    t = t*sqrt(2);
    I = 0;
    for i = 1:n  
        I_new = sinogram_ellipse(t, theta, E(i,1), E(i,2), E(i,3), E(i,4), E(i,5), E(i,6));
        I = I + I_new;
    end
    
end

% Creates a sinogram of an ellipsis  
%
% INPUT:
% t - The ray bins one would like to sample, usually an array with values in
%     the range [-1, 1], or slightly outside. 
% theta - Angles (in degrees) one would like to obtain the sinogram for.
% A   - Ellevation of ellipsis 
% a     - Length of the horisontal semi-axis
% b     - Length of the vertical semi-axis
% x0    - Center of ellipsis in horisontal direction 
% y0    - Center of ellipsis in vertical direction 
% phi    - Rotation of ellipsis (in degrees)
%
% OUTPUT:
% I - Sinogram with shape length(t)×length(theta)
%
function I = sinogram_ellipse(t, theta, A, a, b, x0, y0, phi)
    
    %t_max = 2*round( (N*sqrt(2))/2 )+5;
    %t = linspace(-t_max/2+1,t_max/2, t_max)';

    %s = sqrt(x0^2 + y0^2);
    ga = atan2(y0, x0);

    theta = theta*pi/180;
    phi = phi*pi/180;

    n = length(theta);
    m = length(t);

    I = zeros(m, n);

    for i = 1:n
        th = theta(i);
        t_hat = t - x0*cos(th) - y0*sin(th); 
        th_hat = th-phi;
        bd_val = a*a*cos(th_hat)*cos(th_hat) + b*b*sin(th_hat)*sin(th_hat);
        I(:,i) = (2*A*a*b/bd_val)*sqrt(bd_val - (t_hat).^2)...
                        .* (abs(t_hat) <= sqrt(bd_val));
    end

end




