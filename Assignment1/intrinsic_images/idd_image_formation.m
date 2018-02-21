close all
clear all
clc

% load all images
ball = im2double(imread('ball.png'));
ball_ref = im2double(imread('ball_reflectance.png'));
ball_shad = im2double(imread('ball_shading.png'));

% reconstruct images
ball_reconstruct = ball_ref .* ball_shad;

% creat plots
figure;
subplot(2, 2, 1);
imshow(ball);
title('Initial image');

subplot(2, 2, 2);
imshow(ball_ref);
title('Reflectance');

subplot(2, 2, 3);
imshow(ball_shad);
title('Shading');

subplot(2, 2, 4);
imshow(ball_reconstruct);
title('Reconstructed image');



