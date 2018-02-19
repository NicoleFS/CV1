awb = im2double(imread('awb.jpg'));
figure;
imshow(awb);

avg_red = mean(mean(awb(:, :, 1)));
avg_green = mean(mean(awb(:, :, 2)));
avg_blue = mean(mean(awb(:, :, 3)));

awb_new = zeros(320, 256, 3);
awb_new(:, :, 1) = awb(:, :, 1) + (0.5-avg_red);
awb_new(:, :, 2) = awb(:, :, 2) + (0.5-avg_green);
awb_new(:, :, 3) = awb(:, :, 3) + (0.5-avg_blue);

figure;
imshow(awb_new);
