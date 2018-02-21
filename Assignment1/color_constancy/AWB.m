function AWB(input_image)

awb = im2double(input_image);


avg_red = mean(mean(awb(:, :, 1)));
avg_green = mean(mean(awb(:, :, 2)));
avg_blue = mean(mean(awb(:, :, 3)));

awb_new = zeros(size(input_image));
awb_new(:, :, 1) = awb(:, :, 1) + (0.5-avg_red);
awb_new(:, :, 2) = awb(:, :, 2) + (0.5-avg_green);
awb_new(:, :, 3) = awb(:, :, 3) + (0.5-avg_blue);


subplot(1,2,1), imshow(input_image);
subplot(1,2,2), imshow(awb_new);
end
