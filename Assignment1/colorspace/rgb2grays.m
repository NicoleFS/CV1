function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods

% Obtain dimensions of input image 
[size1, size2, size3] = size(input_image);

% Create empty matrix to store each method in separate channels
output_image = zeros(size1,size2,size3+1);

% Obtain separate RGB channels
[R,G,B] = getColorChannels(input_image);
[x_RGB, y_RGB] = size(R);

% ligtness method
out_lightness = zeros(size(R));

% For each pixel
for i = 1:x_RGB
    for j = 1:y_RGB
        % Calculate lightness method
        vals = [R(i,j), G(i,j), B(i,j)];
        grays = (max(vals)+min(vals))/2;
        out_lightness(i,j) = grays;
    end
end

output_image(:,:,1) = out_lightness;

% average method
out_avg = (R+B+G)./3;
output_image(:,:,2) = out_avg;


% luminosity method
out_luminosity = 0.21.*R + 0.72 .* G + 0.07 .* B;
output_image(:,:,3) = out_luminosity;


% built-in MATLAB function 
out_matlab = rgb2gray(input_image);
output_image(:,:,4) = out_matlab;
 
end

