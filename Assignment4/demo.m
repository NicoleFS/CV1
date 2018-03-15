clc
clear all
close all

% Load VLfeat
vlfeat_root_dir = 'vlfeat-0.9.21';
run(strcat(vlfeat_root_dir, '/toolbox/vl_setup'));
vl_version verbose

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

%% Key point matching

threshold = 2;
[f1, f2, scores] = keypoint_matching(im1, im2, threshold);

% Plot images with lines connecting similar keypoints
figure(3); 
imshow(cat(2, im1, im2));

p = 50;  % Select 50 points to avoid clutter
perm = randperm(size(f1, 2));
sel = perm(1:p);
xa = f1(1, sel);
xb = f2(1, sel) + size(im1, 2);
ya = f1(2, sel);
yb = f2(2, sel);

hold on;
h = line([xa ; xb], [ya ; yb]);
set(h,'linewidth', 1, 'color', 'y');

vl_plotframe(f1(:, sel));
f2_shift = zeros(4, size(f1, 2));
f2_shift(1,:) = f2(1,:) + size(im1,2);
f2_shift(2,:) = f2(2,:);
f2_shift(3,:) = f2(3,:);
f2_shift(4,:) = f2(4,:);
vl_plotframe(f2_shift(:, sel));

% Plot scores to qualitatively validate threshold
% text(((xa+xb)/2), ((ya+yb)/2-10), (num2str(scores(sel).')), 'FontSize',10);
axis image off;
hold off;

%% Ransac
% Image 1 to image 2

threshold = 2;
n = 10;
p = 50;
[x, im_trans] = RANSAC(im1, im2, threshold, n, p);

figure;
subplot(121);
imshow(mat2gray(im_trans));
title('Transformed image');

subplot(122);
imshow(im2);
title('Transformed to this image');

%% Image 2 to image 1

threshold = 2;
n = 10;
p = 50;
[x, im_trans] = RANSAC(im2, im1, threshold, n, p);

figure;
subplot(121);
imshow(mat2gray(im_trans));
title('Transformed image');

subplot(122);
imshow(im1);
title('Transformed to this image');

%%
% Plot images with lines connecting similar keypoints using the
% tranformation function
figure(3); 
imshow(cat(2, im1, im2));

perm = randperm(size(f1, 2));
sel = perm(1:50); % Select 50 points to avoid clutter
xa = f1(1, sel);
ya = f1(2, sel);

x_trans = [x(1) x(2); x(3) x(4)] * [xa; ya] + x(5:6);
xb = x_trans(1, :) + size(im1, 2);
yb = x_trans(2, :);

hold on;
h = line([xa ; xb], [ya ; yb]);
set(h,'linewidth', 1, 'color', 'y');

vl_plotframe(f1(:, sel));
f2_shift = zeros(4, p);
f2_shift(1,:) = xb;
f2_shift(2,:) = yb;
f2_shift(3,:) = f1(3,sel);
f2_shift(4,:) = f1(4,sel);
vl_plotframe(f2_shift);

% Plot scores to qualitatively validate threshold
% text(((xa+xb)/2), ((ya+yb)/2-10), (num2str(scores(sel).')), 'FontSize',10);
axis image off;
hold off;

%% Left and right stichting
left = rgb2gray(imread('left.jpg'));
right = rgb2gray(imread('right.jpg'));

figure;
subplot(121);
imshow(im2double(left));
title('left');

subplot(122);
imshow(im2double(right));
title('right');

%% Transform left to right

threshold = 2;
n = 10;
p = 50;
[x, right_trans] = RANSAC(right, left, threshold, n, p);

figure;
subplot(121);
imshow(mat2gray(right_trans));
title('Transformed image');

subplot(122);
imshow(left);
title('Transformed to this image');

%%

[height, width] = size(right);
corners = [1 1 width width; 1 height 1 height];
corners_trans = round([x(1) x(2); x(3) x(4)] * corners + x(5:6));
min_corners = min(corners_trans, [], 2) - 2;  % minus two for rounding error

[height, width] = size(left);
corners = [1 1 width width; 1 height 1 height];
corners_trans = round([x(1) x(2); x(3) x(4)] \ (corners - min_corners - x(5:6)));
min_corners = min(corners_trans, [], 2) - 2;  % minus two for rounding error
max_corners = max(corners_trans, [], 2);
size_trans = max_corners - min_corners;       % [width, height]
im_stich_l = zeros(size_trans(2), size_trans(1));
im_stich_r = zeros(size_trans(2), size_trans(1));

shift_l = -min(min_corners, zeros(2, 1));
im_stich_l(shift_l(2)+1:shift_l(2)+height, shift_l(1)+1:shift_l(1)+width) = left;

figure;
subplot(121);
imshow(left);
title('left');

subplot(122);
imshow(mat2gray(im_stich_l));
title('stich left');