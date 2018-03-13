function [f1, f2] = keypoint_matching(im1, im2)
% keypoint_maching Finds matching keypoint on the image pairs.
%
%[r, c] = keypoint_matching(im1, im2)
%   im1             First grey scale image
%   im2             Second grey scale image
%
% Output
%   [f1, f2]        Features of im1 that match with features of im2.

r = zeros(size(im1));
c = zeros(size(im2));

% Conver to single precision
I1 = single(im1);
I2 = single(im2);

% Show 50 randomly chosen sift features
% [f, d] = vl_sift(I1);
% perm = randperm(size(f, 2)) ;
% sel = perm(1:50) ;
% 
% figure(1);
% imshow(im1);
% hold on
% h = vl_plotframe(f(:,sel)) ;
% set(h,'color','y','linewidth',2);
% hold off

[f1, d1] = vl_sift(I1);
[f2, d2] = vl_sift(I2);
[matches, ~] = vl_ubcmatch(d1, d2);

f1 = f1(:, matches(:, 1));
f2 = f2(:, matches(:, 2));

end