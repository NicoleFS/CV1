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

% TODO update plots with bilinear rotate
for angle=0:33:180
   im_rot = imrotate(im, angle, 'bilinear'); 
   [H, r, c] = harris_corner_detector(im_rot(:, :, 1), threshold, n, k, sigma);
end

%% Lucas canade
im1 = rgb2gray(im2double(imread('sphere1.ppm')));
im2 = rgb2gray(im2double(imread('sphere2.ppm')));

center_points = 8:15:200;
r = [];
c = [];
for i=1:length(center_points)
    for j=1:length(center_points)
       r = [r center_points(i)];
       c = [c center_points(j)];
    end
end

% [Vx, Vy, r, c] = lucas_kanade(im1, im2);
[Vx, Vy, ~, ~] = lucas_kanade(im1, im2, r, c);