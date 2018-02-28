function [ imOut ] = denoise( image, kernel_type, varargin)
%This function provides the user with the denoised version of the provided
%image. If a box of median filter has to be applied, enter the size of the
%filter after kernel_type. If a Gaussian filter has to be applied, first
%enter the sigma value and then the filter size as variables after
%kernel_type.

% read image
im = imread(image);

% according to kernel type variable, choose correct kernel
switch kernel_type
    case 'box'
        % apply box filter
        imOut = imboxfilt(im, varargin{1});
    case 'median'
        % apply median filter
        imOut = medfilt2(im, [varargin{1} varargin{1}]);
    case 'gaussian'
        % apply gaussian filter
        imOut = imfilter(im, gauss2D(varargin{1}, varargin{2}));
       
end
end
