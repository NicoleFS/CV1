function [ PSNR ] = myPSNR( orig_image, approx_image )

% read and convert images to doubles
orig_im = im2double(imread(orig_image));
approx_im = im2double(imread(approx_image));

% get size of images
[sizex, sizey] = size(orig_im);

% calculate MSE according to the formula in the assignment
MSE = 1/(sizex * sizey) * sum(sum((orig_im - approx_im).^2));

% calculate PSNR according to the formula in the assignment
PSNR = 20 * log10(max(max((orig_im)))/sqrt(MSE));

end

