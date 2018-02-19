function visualize(input_image)

image_values = input_image;
[~, ~, size3] = size(input_image);

if size3 == 3
    subplot(2,2,1), imshow(input_image)
    size_img_matrix = size(image_values);
    for i = 1:size_img_matrix(3)
        subplot(2,2,i+1), imshow(image_values(:,:,i))
    end
elseif size3 == 4
    for i = 1:size3
        subplot(2,2,i), imshow(image_values(:,:,i))
    end
end

end