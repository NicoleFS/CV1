function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)

% read and convert image to doubles
im = im2double(imread(image));

% create filters for x- and y direction
gx = [1 0 -1; 2 0 -2; 1 0 -1];
gy = [1 2 1; 0 0 0; -1 -2 -1];

% calculate Gx and Gy
Gx = imfilter(im, gx);
Gy = imfilter(im, gy);

% calculate the magnitude of the gradients
im_magnitude = sqrt(Gx.^2 + Gy.^2);

% calculate direction of the gradients
im_direction = atan(Gy./Gx);

% show results
figure;
imshow(Gx);
title('Gradient in x-direction');
figure;
imshow(Gy);
title('Gradient in y-direction');
figure;
imshow(im_magnitude);
title('Magnitude of gradients');
figure;
imshow(im_direction);
title('Direction of gradients');

end

