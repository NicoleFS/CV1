close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')

% Select dir containing the images, uncomment the right directory
image_dir = 'photometrics_images/SphereGray5/';   
% image_dir = 'photometrics_images/SphereGray25/';  
% image_dir = 'photometrics_images/MonkeyGray/';
% %image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
% enable or disable shadow trick
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
% chose 'column', 'row' or 'average' integration
height_map = construct_surface(p, q, 'average');

%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map); 

%% Face
[image_stack, scriptV] = load_face_images('photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
% don't use shadow trick
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface(p, q, 'average');

show_results(albedo, normals, SE);
show_model(albedo, height_map);

%% Do the same for color pictures

% load the three color chanels
[image_stack1, ~] = load_syn_images('photometrics_images/SphereColor/', 1);
[image_stack2, ~] = load_syn_images('photometrics_images/SphereColor/', 2);
[image_stack3, scriptV] = load_syn_images('photometrics_images/SphereColor/', 3);

% % uncomment to load monkey images
% [image_stack1, ~] = load_syn_images('photometrics_images/MonkeyColor/', 1);
% [image_stack2, ~] = load_syn_images('photometrics_images/MonkeyColor/', 2);
% image_stack2(isnan(image_stack2)) = 0;
% [image_stack3, scriptV] = load_syn_images('photometrics_images/MonkeyColor/', 3);

% estimate albedo and normals for each channel
shadow_trick = true;
[albedo1, normals1] = estimate_alb_nrm(image_stack1, scriptV, shadow_trick);
[albedo2, normals2] = estimate_alb_nrm(image_stack2, scriptV, shadow_trick);
[albedo3, normals3] = estimate_alb_nrm(image_stack3, scriptV, shadow_trick);
  
% cat albedo's
albedo = cat(3, albedo1, albedo2, albedo3);
% combine normals
normals = normals1 + normals2 + normals3;
% make sure normals have unit length
normals = normals ./ vecnorm(normals, 2, 3);

disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

height_map = construct_surface(p, q, 'average');
show_results(albedo, normals, SE);
show_model(albedo, height_map);