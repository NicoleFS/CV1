%% Corners person toy
im = rgb2gray(im2double(imread('person_toy/00000001.jpg')));
threshold = 0.11;

n = 3;
k = 5;
sigma = .5;
[H, r, c] = harris_corner_detector(im, threshold, n, k, sigma);

%% Corners ping pong
im = rgb2gray(im2double(imread('pingpong/0000.jpeg')));
threshold = 0.09;

n = 3;
k = 5;
sigma = .5;
[H, r, c] = harris_corner_detector(im, threshold, n, k, sigma);

%% Rotating
im = rgb2gray(im2double(imread('person_toy/00000001.jpg')));
threshold = 0.11;

for angle=0:33:180
   im_rot = imrotate(im, angle); 
   [H, r, c] = harris_corner_detector(im_rot(:, :, 1), threshold, n, k, sigma);
end