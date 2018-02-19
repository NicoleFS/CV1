function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

output_image = zeros(size(input_image));

[R,G,B] = getColorChannels(input_image);

r = R./(R+B+G);
g = G./(R+B+G);
b = B./(R+B+G);

output_image(:,:,1) = r;
output_image(:,:,2) = g;
output_image(:,:,3) = b;

end

