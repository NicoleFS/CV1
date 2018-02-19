function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space

output_image = zeros(size(input_image));

[R,G,B] = getColorChannels(input_image);

O_1 = (R - G)./(sqrt(2));
O_2 = (R + B - 2.*B)./(sqrt(6));
O_3 = (R + G + B)./(sqrt(3));

output_image(:,:,1) = O_1;
output_image(:,:,2) = O_2;
output_image(:,:,3) = O_3;

end

