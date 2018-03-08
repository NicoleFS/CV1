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

[Vx, Vy, r, c] = lucas_kanade(im1, im2);

%% Now use rows and columns as input instead of moving window
% Should give the same result as the one above
[Vx, Vy, ~, ~] = lucas_kanade(im1, im2, r, c);

%% Video pingpong
threshold = 0.09;
n = 3;
k = 5;
sigma = .5;
for i=1:52
    im1_f = sprintf('pingpong/000%.0f.jpeg', i-1);
    im2_f = sprintf('pingpong/000%.0f.jpeg', i);
    if i == 10
        im1_f = sprintf('pingpong/000%.0f.jpeg', i-1);
        im2_f = sprintf('pingpong/00%.0f.jpeg', i);
    elseif i > 10
        im1_f = sprintf('pingpong/00%.0f.jpeg', i-1);
        im2_f = sprintf('pingpong/00%.0f.jpeg', i);
    end
    
    im1 = rgb2gray(im2double(imread(im1_f)));
    im2 = rgb2gray(im2double(imread(im2_f)));
    
    [H, r, c] = harris_corner_detector(im1, threshold, n, k, sigma, false);
    [Vx, Vy, ~, ~] = lucas_kanade(im1, im2, r, c);
    pause(0.5);
end

%% Video person toy
close all
threshold = 0.011;
n = 3;
k = 5;
sigma = .5;
for i=2:104
    im1_f = sprintf('person_toy/0000000%.0f.jpg', i-1);
    im2_f = sprintf('person_toy/0000000%.0f.jpg', i);
    if i == 10
        im1_f = sprintf('person_toy/0000000%.0f.jpg', i-1);
        im2_f = sprintf('person_toy/000000%.0f.jpg', i);
    elseif i > 10
        im1_f = sprintf('person_toy/000000%.0f.jpg', i-1);
        im2_f = sprintf('person_toy/000000%.0f.jpg', i);
    end
    
    im1 = rgb2gray(im2double(imread(im1_f)));
    im2 = rgb2gray(im2double(imread(im2_f)));
    
    [H, r, c] = harris_corner_detector(im1, threshold, n, k, sigma, false);
    [Vx, Vy, ~, ~] = lucas_kanade(im1, im2, r, c);
    pause(0.5);
end