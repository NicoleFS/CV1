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

%%

[f1, f2] = keypoint_matching(im1, im2);
