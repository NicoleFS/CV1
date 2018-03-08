function lucas_kanade(input_image1, input_image2)


% check if image is RGB, if so convert to grayscale
if length(size(imread(input_image1))) == 3
    input_im1 = rgb2gray(im2double(imread(input_image1)));
    input_im2 = rgb2gray(im2double(imread(input_image2)));
else
    input_im1 = im2double(imread(input_image1));
    input_im2 = im2double(imread(input_image2));
end

% get sizes of grayscale image
[sizex, sizey] = size(input_im1);

% size to where the image can be split into 15x15 windows
sizex_temp = sizex - rem(sizex, 15);
sizey_temp = sizey - rem(sizey, 15);

% Create empty matrices and vectors to store information
A = zeros(15*15, 2);
b = zeros(15*15,1);
Vx = [];
Vy = [];

%[Ix Iy] = imgradientxy(input_im1);

% Calculate gradients
G = fspecial('gauss', [15, 15], 1);
[Gx, Gy] = imgradientxy(G);
Ix = imfilter(input_im1, Gx, 'replicate', 'conv');
Iy = imfilter(input_im1, Gy, 'replicate', 'conv');

% Store centrepoints for each window
centrepoints_x = [];
centrepoints_y = [];

% Create 15x15 windows and do calculations
for i = 1:15:sizex_temp
    for j = 1:15:sizey_temp
        
        % Calculate window per image
        window_1 = input_im1(i:i+14, j:j+14);
        window_2 = input_im2(i:i+14, j:j+14);
        
        % Get gradient values for this window
        window_Ix = Ix(i:i+14, j:j+14);
        window_Iy = Iy(i:i+14, j:j+14);
        
        % Calculate centrepoint of window
        centrepoint_x = i+7;
        centrepoint_y = j+7;
        
        % Store centrepoints
        centrepoints_x = [centrepoints_x centrepoint_x];
        centrepoints_y = [centrepoints_y centrepoint_y];
        
        % Store gradients
        A(:,1) = window_Ix(:);
        A(:,2) = window_Iy(:);  
        
        % Transpose of A
        A_t = transpose(A);
        
        % Calculate b
        B = window_1-window_2;
        b = B(:);
        
        % Calculate optical flow
        v = inv(A_t*A)*A_t*b;
        Vx = [Vx v(1,1)];
        Vy = [Vy v(2,1)];
        
    end
end

figure;
imshow(input_image1);
hold on;
q = quiver(centrepoints_y, centrepoints_x, Vx, Vy);
q.Color = 'red';

end