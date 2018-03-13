%% The boats
im1 = imread('boat1.pgm');
im2 = imread('boat2.pgm');

figure;
subplot(121);
imshow(im2double(im1));
title('boat1');

subplot(122);
imshow(im2double(im2));
title('boat2');

%%
