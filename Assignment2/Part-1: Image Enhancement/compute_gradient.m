function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)

im = im2double(imread(image));


gx = [1 0 -1; 2 0 -2; 1 0 -1];
gy = [1 2 1; 0 0 0; -1 -2 -1];

Gx = imfilter(im, gx);
Gy = imfilter(im, gy);

im_magnitude = sqrt(Gx.^2 + Gy.^2);

im_direction = atan(Gy./Gx);

figure;
imshow(Gx);
figure;
imshow(Gy);
figure;
imshow(im_magnitude);
figure;
imshow(im_direction);

end

