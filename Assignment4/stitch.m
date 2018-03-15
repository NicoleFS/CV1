function [im_stitch] = stitch(im1, im2, threshold, n, p)
% stitch Stitches the images together
%
%[r, c] = stitch(im1, im2, threshold, n, p)
%   im1             Left grey scale image
%   im2             Right grey scale image
%   threshold       Thershold for filtering similar descriptors.
%   n               Run RANSAC algorithm n times.
%   p               Extract p features on each run to find transformation 
%                   matrix.
%
% Output
%   [im_stitch]     The stitched image.

if nargin < 3
    threshold = 1.5;
end
if nargin < 4
    n = 10;
end
if nargin < 5
    p = 50;
end

[~, im2_trans, corners_trans] = RANSAC(im2, im1, threshold, n, p);

% Get the extent of the stiched image
[height, width] = size(im1);
max_corners = ceil(max(corners_trans, [], 2));
height = max(height, max_corners(2));
width = max(width, max_corners(1));

% To be filled filled for left and right image
im_stitch_l = zeros(height, width);
im_stitch_r = zeros(height, width);

% Shift
shift = floor(min(corners_trans, [], 2));

% Shift left image
[height, width] = size(im1);
shift_l = -min(shift, [0; 0]);
im_stitch_l(1+shift_l(2):height+shift_l(2), 1+shift_l(1):width+shift_l(1)) = mat2gray(im1);

% Shift right image
[height, width] = size(im2_trans); 
shift_r = max(shift, [0; 0]);
im_stitch_r(1+shift_r(2):height+shift_r(2), 1+shift_r(1):width+shift_r(1)) = im2_trans;

% Stitch the image together
im_stitch = max(im_stitch_l, im_stitch_r);

% Take the average where the images overlap
mean_stitch = (im_stitch_l + im_stitch_r)/2.;
select = (im_stitch_l > 0 & im_stitch_r > 0);
im_stitch(select) = mean_stitch(select);

end