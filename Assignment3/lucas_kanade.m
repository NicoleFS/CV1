function [Vx, Vy, r, c] = lucas_kanade(im1, im2, r, c)
% lucas_kanade Applies lucas kanade algorithm to track motion
%
% [Vx, Vy, r, c] = lucas_kanade(im1, im2, r, c)
%   ARGUMENTS
%       im1             The first image.
%       im2             The second image.
%       r (optional)    Rows of interest points.
%       c (optional)    Colums of interest points.
%   
%   OUTPUT
%       [Vx, Vy, r, c]  Motion in x, motion in y, rows interest points, 
%                       column interest points

size_w = 15;    % window size
k = 5;          % Gauss kernel size
sigma = 0.5;    % Gauss sigma

if nargin < 3
    % get sizes of grayscale image
    [sizex, sizey] = size(im1);

    % Create empty matrices and vectors to store information
    size_V = floor(sizex/size_w)*floor(sizey/size_w);
    
    % Store rows and column of centerpoints for each window
    r = zeros(1, size_V);
    c = zeros(1, size_V);
    
    % size to where the image can be split into 15x15 windows
    sizex_temp = sizex - rem(sizex, size_w);
    sizey_temp = sizey - rem(sizey, size_w);    
    
    window = true;
else
    size_V = length(r);
    window = false;
end

Vx = zeros(1, size_V);
Vy = zeros(1, size_V);

% Calculate gradients
G = fspecial('gauss', [k, k], sigma);
[Gx, Gy] = imgradientxy(G);
Ix = imfilter(im1, Gx, 'replicate', 'conv');
Iy = imfilter(im1, Gy, 'replicate', 'conv');

index = 1;
if window
    % Create 15x15 windows and do calculations
    for i = 1:size_w:sizex_temp
        for j = 1:size_w:sizey_temp

            % Store centrepoints
            r(index) = i+floor(size_w/2);
            c(index) = j+floor(size_w/2);
            
            % Get gradient values for this window
            window_Ix = Ix(i:i+size_w-1, j:j+size_w-1);
            window_Iy = Iy(i:i+size_w-1, j:j+size_w-1);

            % Store gradients
            A = [window_Ix(:) window_Iy(:)];

            % Calculate window per image
            window_1 = im1(i:i+size_w-1, j:j+size_w-1);
            window_2 = im2(i:i+size_w-1, j:j+size_w-1);

            % Calculate b
            B = window_1-window_2;
            b = B(:);

            % Calculate optical flow
            v = A\b;

            Vx(index) = v(1,1);
            Vy(index) = v(2,1);
            index = index + 1;
        end
    end
else
   for i=1:size_V
        shift = floor(size_w/2);

        % Get gradient values for this window
        window_Ix = Ix(r(i)-shift:r(i)+shift-1, c(i)-shift:c(i)+shift-1);
        window_Iy = Iy(r(i)-shift:r(i)+shift-1, c(i)-shift:c(i)+shift-1);

        % Store gradients
        A = [window_Ix(:) window_Iy(:)];

        % Calculate window per image
        window_1 = im1(r(i)-shift:r(i)+shift-1, c(i)-shift:c(i)+shift-1);
        window_2 = im2(r(i)-shift:r(i)+shift-1, c(i)-shift:c(i)+shift-1);

        % Calculate b
        B = window_1-window_2;
        b = B(:);

        % Calculate optical flow
        v = A\b;

        Vx(i) = v(1,1);
        Vy(i) = v(2,1);
   end
end
    
figure;
imshow(im1);
hold on;
q = quiver(c, r, Vx, Vy);
q.Color = 'red';

end