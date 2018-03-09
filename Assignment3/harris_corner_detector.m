function [H, r, c] = harris_corner_detector(im, threshold, n, kernel_size, sigma, plot_results)    
%harris_corner_detector Applies harris corner detector algorithm to
%image.
%   [H, r, c] = harris_corner_detector(im, threshold, n, kernel_size, sigma, plot_results)
%   finds corners in image
%   - ARGUMENTS
%     im                The image.
%     thershold         Thershold for the cornerness value.
%     n                 Neighborhood in which maximum is found.
%     kernel_size       Kernel size of the Gaussian.
%     sigma             Standard deviation of Gaussian kernel.
%     plot_results      (optional) Boolean, plot results or not.
%   
%   - OUTPUT
%     [H, r, c]         Cornerness of pixel, row of corner, column of
%                       corner.

if nargin < 6
   plot_results = true;
end
    
% https://stackoverflow.com/questions/23980080/derivative-of-gaussian-filter-in-matlab
% Derivative of gaus
G = fspecial('gauss', [kernel_size kernel_size], sigma);
[Gx, Gy] = imgradientxy(G);  

% Filter the Gauss over the image for Ix and Iy
bound_option = 'replicate';
Ix = imfilter(im, Gx, bound_option, 'conv');
Iy = imfilter(im, Gy, bound_option, 'conv');

% Get the A, B, C values for matrix Q
A = imfilter(Ix .* Ix, G, bound_option, 'conv');
B = imfilter(Ix .* Iy, G, bound_option, 'conv');
C = imfilter(Iy .* Iy, G, bound_option, 'conv');

% Calculate cornernes
H = (A.*C-B.*B) - 0.04*(A+C).^2;

% https://nl.mathworks.com/help/images/ref/ordfilt2.html?requestedDomain=true
% Find maxmimum cornerness points which are above the threshold
H_max = ordfilt2(H, n*n, ones(n, n));
corners = (H_max == H & H_max > threshold);
[r, c] = find(corners == 1);

if plot_results
    figure;
    subplot(131), imshow(mat2gray(Ix));
    title('Derivative x-direction');

    subplot(132), imshow(mat2gray(Iy));
    title('Derivative y-direction');

    subplot(133), imshow(im);
    hold on
    plot(c, r, 'go');
    title('Image with corners');
    hold off
end
   
end