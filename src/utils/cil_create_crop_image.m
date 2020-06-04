% Crop four images, insert text in them and returns a concatecated image.
%
% The function read the four image names found in the cell array `fnames`,
% extract the pixels `image(idx_v, idx_h)` from each of the images and 
% inset the text found in the cell array `text`. The images are then 
% concatenated together in the following order 
%
%    +-------+-------+
%    |       |       |
%    |   1   |   2   |
%    |       |       |
%    +-------+-------+
%    |       |       |
%    |  3    |   4   |
%    |       |       |
%    +-------+-------+
%
% INPUT
% fnames - Tilenames to be read, stacked as cell array {'fname1', ..., 'fname1'}.
%          The filenames are assumed to point at images which are grayscale
% text   - The text we plot in the images, stacked as a cell array.
% idx_v  - Indices along the first axes.
% idx_h  - Indices along the second axes.
% font_size - Font size.
% pixel_boarder - Number of pixels used as boarder between the images.
%                 (Optional, default is 6). 
%
% OUTPUT
% The concatenated images as shown in the figure above, including the text.  
%
function im = cil_create_crop_image(fnames, text, idx_v, idx_h, font_size, pixel_boarder);
    if nargin < 6
        pixel_boarder = 6;
    end
    
    bd = pixel_boarder;
 
    fname1 = fnames{1};
    fname2 = fnames{2};
    fname3 = fnames{3};
    fname4 = fnames{4};
    
    im1 = imread(fname1);
    im2 = imread(fname2);
    im3 = imread(fname3);
    im4 = imread(fname4);
    
    lv = length(idx_v);
    lh = length(idx_h);
    
    im_out = zeros([2*lv+bd, 2*lh+bd], 'uint8');
    im_out(1:lv, 1:lh)     = im1(idx_v, idx_h);
    im_out(lv+1:lv+bd, :) = uint8(255);
    im_out(:,lh+1:lh+bd) = uint8(255);
    im_out(1:lv, lh+bd+1:end) = im2(idx_v, idx_h);
    im_out(lv+bd+1:end, 1:lh) = im3(idx_v, idx_h);
    im_out(lv+bd+1:end, lh+bd+1:end) = im4(idx_v, idx_h);
     
    im1_crop = im1(idx_v,idx_h);
    im2_crop = im2(idx_v,idx_h);
    im3_crop = im3(idx_v,idx_h);
    im4_crop = im4(idx_v,idx_h);
    
    RGB1 = insertText(im1_crop, [lv,lh], ...
                     text{1}, ...
                     'BoxColor', 'white', 'BoxOpacity',0.7, ...
                     'TextColor','black', ... 
                     'FontSize', font_size,...
                     'AnchorPoint', 'RightBottom');
    
    RGB2 = insertText(im2_crop, [lv,lh], ...
                     text{2}, ...
                     'BoxColor', 'white', 'BoxOpacity',0.7, ...
                     'TextColor','black', ... 
                     'FontSize', font_size,...
                     'AnchorPoint', 'RightBottom');
    
    RGB3 = insertText(im3_crop, [lv,lh], ...
                     text{3}, ...
                     'BoxColor', 'white', 'BoxOpacity',0.7, ...
                     'TextColor','black', ... 
                     'FontSize', font_size,...
                     'AnchorPoint', 'RightBottom');
    
    RGB4 = insertText(im4_crop, [lv,lh], ...
                     text{4}, ...
                     'BoxColor', 'white', 'BoxOpacity',0.7, ...
                     'TextColor','black', ... 
                     'FontSize', font_size,...
                     'AnchorPoint', 'RightBottom');
    
    Y1 = rgb2gray(RGB1);
    Y2 = rgb2gray(RGB2);
    Y3 = rgb2gray(RGB3);
    Y4 = rgb2gray(RGB4);
    
    im_out = zeros([2*lv+bd, 2*lh+bd], 'uint8');
    im_out(1:lv, 1:lh)     = Y1;
    im_out(1:lv, lh+bd+1:end) = Y2;
    im_out(lv+bd+1:end, 1:lh) = Y3;
    im_out(lv+bd+1:end, lh+bd+1:end) = Y4;
    im_out(lv+1:lv+bd, :) = uint8(255);
    im_out(:,lh+1:lh+bd) = uint8(255);

    im = im_out;

end

