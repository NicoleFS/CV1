function visualize(input_image)

image_values = input_image;

subplot(2,2,1), imshow(input_image)
size_img_matrix = size(image_values);

for i = 1:size_img_matrix(3)
    subplot(2,2,i+1), imshow(image_values(:,:,i))
end

end