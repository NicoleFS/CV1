function [descriptors] = extract_features(input_image, settings)
% Extracts SIFT features of image.
%
% [descriptors] = extract_features(input_image, settings)
%   input_image     Path to input image
%   settings        Settings of the sift, color scheme and sift type.
%
% Output
%   descriptor      Sift features.

input_im = imread(char(input_image));

[~,~,sizez] = size(input_im);

if settings.color_scheme == "gray"
    if sizez == 3
        image = single(rgb2gray(input_im));
    else
        image = single(input_im);
    end
    
    if settings.sift_type == "dense"
        [~, descriptors] = vl_dsift(image, 'step', 10);
    elseif settings.sift_type == "keypoint"
        [~, descriptors] = vl_sift(image);
    end

else
    if sizez == 3
        
        temp_im = single(rgb2gray(input_im));
        
        if settings.color_scheme == "RGB"            
            input_im = single(input_im);
        elseif settings.color_scheme == "rgb"
            input_im = single(rgb2normedrgb(input_im));
        elseif settings.color_scheme == "opponent"
            input_im = single(rgb2opponent(input_im));
        end
        
        if settings.sift_type == "dense"
            
            [~, descriptors] = vl_phow(input_im, 'step', 10, 'color','rgb'); 
            
        elseif settings.sift_type == "keypoint"
            
            [temp_frames, ~] = vl_sift(temp_im);
            [~, temp_descriptors1] = vl_sift(input_im(:,:,1), 'frames', temp_frames);
            [~, temp_descriptors2] = vl_sift(input_im(:,:,2), 'frames', temp_frames);
            [~, temp_descriptors3] = vl_sift(input_im(:,:,3), 'frames', temp_frames);
            descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
        end
    else
        descriptors = [];
    end 
end

end
    
