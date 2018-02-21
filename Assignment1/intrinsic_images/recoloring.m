close all
clear all
clc

% load images
ball = im2double(imread('ball.png'));
ball_ref = im2double(imread('ball_reflectance.png'));
ball_shad = im2double(imread('ball_shading.png'));

% find unique colors
% rgb = {'Red';'Green';'Blue'};
r = ball_ref(:, :, 1)*255;
r = r(:);
g = ball_ref(:, :, 2)*255;
g = g(:);
b = ball_ref(:, :, 3)*255;
b = b(:);
t = table(r, g, b);
% unique color
unique(t)

%% Recoloring to green

[h, w, n] = size(ball_ref);
ball_ref_green = zeros(h, w, n);
% find pixels which need to be recolored
colored = ball_ref > 0.1;
colored = mean(colored, 3);
% recolor
ball_ref_green(:, :, 2) = colored;
% construct new image
ball_reconstruct_green = ball_ref_green .* ball_shad;

% do same for magenta
ball_ref_magneta = zeros(h, w, n);
ball_ref_magneta(:, :, 1) = colored;
ball_ref_magneta(:, :, 3) = colored;
ball_reconstruct_magneta = ball_ref_magneta .* ball_shad;

% plot results
figure;
subplot(1, 3, 1);
imshow(ball);
title('Initial image');
 
subplot(1, 3, 2);
imshow(ball_reconstruct_green);
title('Green');

subplot(1, 3, 3);
imshow(ball_reconstruct_magneta);
title('Magneta');