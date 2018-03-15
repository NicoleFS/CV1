function [f1, f2, scores] = keypoint_matching(im1, im2, threshold)
% keypoint_maching Finds matching keypoint on the image pairs.
%
% [r, c] = keypoint_matching(im1, im2, threshold)
%   im1             First grey scale image
%   im2             Second grey scale image
%   threshold       Thershold for filtering similar descriptors.
%
% Output
%   f1              SIFT eatures in im1.
%   f2              Matching SIFT features in im2.

if nargin < 3
    threshold = 1.5;
end

% Conver to single precision
I1 = single(im1);
I2 = single(im2);

% Get sift features
[f1, d1] = vl_sift(I1);
[f2, d2] = vl_sift(I2);

% Find matches
[matches, scores] = vl_ubcmatch(d1, d2, threshold);

% Select matches
f1 = f1(:, matches(1, :));
f2 = f2(:, matches(2, :));

end