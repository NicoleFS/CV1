function AWB(name_of_image)
% uses the gray-world assumption to color correct an image.
% call function, for instance for the awb.jpg image:
% AWB('awb.jpg')

% Read image and transform to doubles
input_image = imread(name_of_image);
awb = im2double(input_image);

% Get average value for each channel
avg_red = mean(mean(awb(:, :, 1)));
avg_green = mean(mean(awb(:, :, 2)));
avg_blue = mean(mean(awb(:, :, 3)));

% Create matrix to store corrected image in
awb_new = zeros(size(input_image));

% Change RGB values in such a way that the average is achromatic
awb_new(:, :, 1) = awb(:, :, 1) + (0.5-avg_red);
awb_new(:, :, 2) = awb(:, :, 2) + (0.5-avg_green);
awb_new(:, :, 3) = awb(:, :, 3) + (0.5-avg_blue);

% Show original and corrected image in one figure
subplot(1,2,1), imshow(input_image);
subplot(1,2,2), imshow(awb_new);
end
