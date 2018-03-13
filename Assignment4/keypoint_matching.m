function [r, c] = keypoint_matching(im1, im2)
% keypoint_maching Finds matching keypoint on the image pairs.
%
%[r, c] = keypoint_matching(im1, im2)
%   im1             First grey scale image
%   im2             Second grey scale image
%
% Output
%   [r, c]          Rows and columns of the keypoints.

% Conver to single precision
im1 = single(im1);
im2 = single(im2);

[f,d] = vl_sift(I);

end