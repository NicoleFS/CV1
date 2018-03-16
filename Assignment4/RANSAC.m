function [x_best, im_trans, corners_trans] = RANSAC(im1, im2, threshold, n, p, r)
% RANSAC transforms image1 to image 2.
%
% [x_best, im_trans, corners_trans] = RANSAC(im1, im2, threshold, n, p, r)
%   im1             First grey scale image.
%   im2             Second grey scale image.
%   threshold       Thershold for filtering similar descriptors.
%   n               Try n times to find best tansformation vector.
%   p               Extract p features on each run to find best 
%                   transformation vector.
%   r               Radius to select inliers.
%
% Output
%   x_best          Best transformation vector: [m1 m2 m3 m4 t1 t2].
%   im_trans        Transformed image.
%   corners_trans   Transformed corners.

x_best = zeros(6, 1);

if nargin < 3
    threshold = 1.5;
end
if nargin < 4
    n = 10;
end
if nargin < 5
    p = 50;
end
if nargin < 6
    r = 10;
end

% Find keypoints
[f1, f2, ~] = keypoint_matching(im1, im2, threshold);

% n times find best transformation matrix
max_inl = -1;
for i=1:n
    % Randomly select p features
    perm = randperm(size(f1, 2));
    sel = perm(1:p);
    xa = f1(1, sel);
    xb = f2(1, sel);
    ya = f1(2, sel);
    yb = f2(2, sel);

    % compute transformation vector x
    A_top = [xa; ya; zeros(1, p); zeros(1, p); ones(1, p); zeros(1, p)];
    A_bot = [zeros(1, p); zeros(1, p); xa; ya; zeros(1, p); ones(1, p)];
    A = cat(2, A_top, A_bot);
    b = cat(2, xb, yb);
    x = pinv(A.') * b.';
    
    % Compute x transposed from image 1 to image 2
    x_trans = [x(1) x(2); x(3) x(4)] * [xa; ya] + x(5:6);
    % Calculate dists between the transposed point and the actual points
    dists = sum((x_trans-cat(1, xb, yb)).^2, 1).^.5;
    % number of inliers
    inliers = sum(dists < r);    
    
    % Keep track off best transformation vector, based on number of
    % inliers.
    if inliers > max_inl
        x_best = x;
        max_inl = inliers;
    end
end
fprintf('Number of inliers %i/%i\n', inliers, p)

% Transform the image
% Define the transformed image
[height, width] = size(im1);
corners = [1 1 width width; 1 height 1 height];
corners_trans = [x(1) x(2); x(3) x(4)] * corners + x(5:6);
min_corners = floor(min(corners_trans, [], 2));
max_corners = ceil(max(corners_trans, [], 2));
size_trans = max_corners - min_corners;       % [width, height]
im_trans = zeros(size_trans(2), size_trans(1));

% Matrix with all pixels of transformed image
% [ 1 1 1 ... width    width    width
% %   1 2 3 ... height-2 height-1 height]
pixels_trans = combvec(1:size_trans(1), 1:size_trans(2));

% convert trans_pixels back to pixels of image 1
pixels = round([x(1) x(2); x(3) x(4)] \ (pixels_trans + min_corners - x(5:6)));
% Ignore pixels which are outside the image
cols = (pixels(1, :) > 0 & pixels(2, :) > 0 & pixels(1, :) <= width & pixels(2, :) <= height);
pixels = pixels(:, cols);
pixels_trans = pixels_trans(:, cols);
% Create index of the x,y coordinates
idx = sub2ind(size(im1), pixels(2,:), pixels(1, :));
idx_trans = sub2ind(size(im_trans), pixels_trans(2,:), pixels_trans(1, :));

% transformed image
im_trans(idx_trans) = mat2gray(im1(idx));    

end