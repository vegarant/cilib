% Converts a complex valued image to a RGB image, where the colours depends on 
% phase and amplitude of the complex numbers. 
%
% INPUT:
% image - Complex valued N×M image
%
% OUTPUT:
% X - RGB image with unsigned 8-bit integers, where the colours depend on the phase
% and amplitude of the complex numbers. 
%
% This code is inspired by code from Iacopo Mochi, Lawrence Berkeley National Laboratory
%
% Vegard Antun, 2020.
function X = cil_rgb_complex_image(image)

    im = imag(image);
    re = real(image);
    phase = atan2(im, re);

    amp = abs(image);

    max_amp = max(amp(:));
    if max_amp == 0
        max_amp = 1;
    end 
    amp = amp/max_amp; % Scale to [0,1]

    X = zeros(size(image,1), size(image,2), 3);

    % Set the colours in the three channels
    X(:,:,1)=0.5*(sin(phase)+1).*amp;
    X(:,:,2)=0.5*(sin(phase+pi/2)+1).*amp;
    X(:,:,3)=0.5*(-sin(phase)+1).*amp;

    X = uint8(255*X);
end

