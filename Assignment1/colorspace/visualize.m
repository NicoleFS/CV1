function visualize(input_image)

% Obtain amount of channels in image
[~, ~, size3] = size(input_image);

% If there are three channels
if size3 == 3
    % First image shown is the complete image
    subplot(2,2,1), imshow(input_image)
    size_img_matrix = size(input_image);
    
    % Plot each channel separately for the rest
    for i = 1:size_img_matrix(3)
        subplot(2,2,i+1), imshow(input_image(:,:,i))
    end
    
% If there are four channels
elseif size3 == 4
    % Plot each channel in a subplot
    for i = 1:size3
        subplot(2,2,i), imshow(input_image(:,:,i))
    end
end

end