image_dir = 'photometrics_images/SphereGray25/';   % TODO: get the path of the script
[image_stack, scriptV] = load_syn_images(image_dir);

% for i=1:5:21
%     [albedo, normals] = estimate_alb_nrm(image_stack(:, :, i:i+4), scriptV(i:i+4, :));
%     figure;
%     imshow(albedo)    
% end
% [albedo, normals] = estimate_alb_nrm(image_stack, scriptV);
% figure;
% imshow(albedo)    

[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);
figure;
imshow(albedo);