im = rgb2gray(im2double(imread('pingpong/0000.jpeg')));
im = rgb2gray(im2double(imread('person_toy/00000001.jpg')));
% TODO: not just use first channel of the image

threshold = 0.09;
n = 3;
k = 5;
sigma = .5;
[H, r, c] = harris_corner_detector(im, threshold, n, k, sigma);

for angle=0:15:100
   im_rot = imrotate(im, angle); 
   [H, r, c] = harris_corner_detector(im_rot(:, :, 1), threshold, n, k, sigma);
end