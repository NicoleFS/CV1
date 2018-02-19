ball = im2double(imread('ball.png'));
ball_ref = im2double(imread('ball_reflectance.png'));
ball_shad = im2double(imread('ball_shading.png'));

ball_reconstruct = ball_ref .* ball_shad;

figure;
subplot(2, 2, 1);
imshow(ball);
title('ball');

subplot(2, 2, 2);
imshow(ball_ref);
title('ball reflectance');

subplot(2, 2, 3);
imshow(ball_shad);
title('ball shading');

subplot(2, 2, 4);
imshow(ball_reconstruct);
title('ball reconstructed');


