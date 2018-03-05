im = imread('pingpong/0000.jpeg');
% TODO: not just use first channel of the image

threshold = 243;
n = 3;
k = 11;
sigma = 1;
[H, r, c] = harris_corner_detector(im(:, :, 1), threshold, n, k, sigma);

for angle=0:15:100
   im_rot = imrotate(im, angle); 
   [H, r, c] = harris_corner_detector(im_rot(:, :, 1), threshold, n, k, sigma);
end