close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = 'photometrics_images/SphereGray5/';   % TODO: get the path of the script
% image_dir = 'photometrics_images/MonkeyGray/';   % TODO: get the path of the script
% image_dir = 'photometrics_images/yaleB02/';   % TODO: get the path of the script
%image_ext = '*.png';

[image_stack, scriptV] = load_syn_images(image_dir);
% [image_stack, scriptV] = load_face_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface(p, q, 'average');

%% Display
% show_results(albedo, normals, SE);
show_model(albedo, height_map);


%% Face
[image_stack, scriptV] = load_face_images('photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map = construct_surface( p, q, 'average');

% show_results(albedo, normals, SE);
show_model(albedo, height_map);

%% Do the same for color pictures
[image_stack1, scriptV] = load_syn_images('photometrics_images/SphereColor/', 1);
[image_stack2, scriptV] = load_syn_images('photometrics_images/SphereColor/', 2);
[image_stack3, scriptV] = load_syn_images('photometrics_images/SphereColor/', 3);
image_stack = (image_stack1 + image_stack2 + image_stack3)./3;


[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);
    
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

height_map = construct_surface( p, q, 'row');

show_results(albedo, normals, SE);
show_model(albedo, height_map);