function [ imOut ] = denoise( image, kernel_type, varargin)

close all

im = imread(image);

switch kernel_type
    case 'box'
        imOut = imboxfilt(im, varargin{1});
    case 'median'
        imOut = medfilt2(im, [varargin{1} varargin{1}]);
    case 'gaussian'
        imOut = imfilter(im, gauss2D(varargin{1}, varargin{2}));
       
end
end
