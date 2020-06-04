clear('all') ; close('all');
load('cilib_defaults.mat') % load font size, line width, etc.

% create destination for the plots
dest = 'plots';
if (exist(dest) ~= 7) 
    mkdir(dest);
end

N = 256; % resolution
nbr_coils = 4;   % Number of coils 

% Read image
fname = sprintf('phantom_brain_%d.png', N);
X = double(imread(fullfile(cil_dflt.data_path, 'test_images', fname)))/255;

% Construct coil sensitivites
FOV = 0.256; % FOV width
mxsize = N*[1 1];
pixelsize = FOV./mxsize;

coil_sens = GenerateSensitivityMap( FOV, pixelsize, nbr_coils, .09, .18);

% Compute coil images and measurements

image_sens = zeros(size(coil_sens));

for c = 1:nbr_coils
    fname1 = sprintf('sense_coil_%d.%s', c, cil_dflt.image_format);
    fname2 = sprintf('sense_image_%d.%s', c, cil_dflt.image_format);

    C = coil_sens(:, :, c);
    XC = X.*C; % construct coil image

    C_rgb = cil_rgb_complex_image(C);
    XC_rgb = cil_rgb_complex_image(XC);

    imwrite(C_rgb, fullfile(dest,fname1));
    imwrite(XC_rgb, fullfile(dest,fname2));

end

