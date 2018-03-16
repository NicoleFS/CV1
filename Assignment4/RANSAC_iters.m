function [iter] = RANSAC_iters(im1, im2, threshold, accur, p, r, max_iter)
% RANSAC Counts the number of iterations to get % inliers.
%
% [x_best, im_trans, corners_trans] = RANSAC(im1, im2, threshold, n, p, r)
%   im1             First grey scale image.
%   im2             Second grey scale image.
%   threshold       Thershold for filtering similar descriptors.
%   accur           Percentage of number of inliers.
%   p               Extract p features on each run to find best 
%                   transformation vector.
%   r               Radius to select inliers.
%   max_iter        Maximum number of iterations.
%
% Output
%   x_best          Best transformation vector: [m1 m2 m3 m4 t1 t2].
%   im_trans        Transformed image.
%   corners_trans   Transformed corners.

iter = 0;

if nargin < 3
    threshold = 1.5;
end
if nargin < 4
    accur = 0.9;
end
if nargin < 5
    p = 50;
end
if nargin < 6
    r = 10;
end
if nargin < 7
    max_iter = 100;
end

% Find keypoints
[f1, f2, ~] = keypoint_matching(im1, im2, threshold);

% n times find best transformation matrix
max_inl = -1;
while max_inl < (accur*p)
    iter = iter + 1;
    
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
        max_inl = inliers;
    end
    if iter >= max_iter
        fprintf('Exceeding the maximum number of iterations.\n');
        break;
    end
end
fprintf('number of inliers %i/%i\n', inliers, p)   

end