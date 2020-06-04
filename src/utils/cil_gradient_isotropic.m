% Computes the isotropic gradient of an image. Note that the output image will
% be complex valued.
function [DX, DX_abs] = cil_gradient_isotropic(X)
    h = [-1,1];

    DX1 = imfilter(X,h', 'circular');
    DX2 = imfilter(X,h, 'circular');

    DX = DX1 + 1j*DX2;
    DX_abs = sqrt(abs(DX1).^2 + abs(DX2).^2);

end
