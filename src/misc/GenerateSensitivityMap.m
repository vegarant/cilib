%% GenerateSensitivityMap.m
%
% Generates a set of 2D sensitivity maps that are simulated with the
% Biot-Savart law. The coils are cicular, with centers which are
% equidistant to the origin, and their axis are uniformly distributed radiuses.
%
% INPUTS:	* field of view in meters (can be 2x1 vector)
%           * resolution (pixel size) in meters (can be 2x1 vector)
%           * number of coils or vector of the desired angles (in radians)
%           * radius of coils in meters
%           * distance from the coils centers to the origin in meters
%
% OUTPUT:  	* 3D vector of complex-valued sensitivity maps.
%
% Copyright, Matthieu Guerquin-Kern, 2012

% This code is copied from http://bigwww.epfl.ch/algorithms/mri-reconstruction/
% Vegard Antun, 2020

function S = GenerateSensitivityMap( FOV, varargin)

%% Default parameters
if nargin==0
    FOV=.24;
end
numvarargs = length(varargin);
if numvarargs > 4
    error('GenerateSensitivityMap:TooManyInputs', ...
        'requires at most 5 inputs');
end
optargs = {FOV/128 1 .04 .15};
optargs(1:numvarargs) = varargin;
[res Nc R D] = optargs{:};
if any(FOV<=res)
    error('GenerateSensitivityMap:Resolution','the field of view must be wider than the resolution');
end
if numel(res)==1
    res = res*[1,1];
end
if numel(FOV)==1
    FOV = FOV*[1,1];
end

%% Computation of coil sensitivites

x = 0:res(1):FOV(1)-res(1);
x = x-x(ceil((end+1)/2));

y = 0:res(2):FOV(2)-res(2);
y = y-y(ceil((end+1)/2));

if numel(Nc)==1
    dalpha = 2*pi/Nc;
    alpha = 0:dalpha:2*pi-dalpha;
else
    alpha = Nc;
    Nc = numel(alpha);
end
S = zeros(numel(x),numel(y),Nc);
Nangles = 60;
dtheta = 2*pi/Nangles;
theta = -pi:dtheta:pi-dtheta;
[Y,X,T] = ndgrid(x,y,theta);
m = zeros(1,Nc);
for i = 1:Nc
    x = X*cos(alpha(i)) - Y*sin(alpha(i));
    y = X*sin(alpha(i)) + Y*cos(alpha(i));
    s = exp(1i*alpha(i)) * ( -R+y.*cos(T) - 1j*(D-x).*cos(T) ) ./ ( (D-x).^2 + y.^2 + R^2 - 2*R*y.*cos(T) ).^(3/2);
    S(:,:,i) = dtheta*sum(s,3);
end

%% Normalization
S = S/max(abs(S(:)));
