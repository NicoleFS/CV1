function [ PSNR ] = myPSNR( orig_image, approx_image )

orig_im = im2double(imread(orig_image));
approx_im = im2double(imread(approx_image));

[sizex, sizey] = size(orig_im);

MSE = 1/(sizex * sizey) * sum(sum((orig_im - approx_im).^2));

PSNR = 20 * log10(max(max((orig_im)))/sqrt(MSE));

end

