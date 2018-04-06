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

[sizex,sizey,sizez] = size(input_im);

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
        
        gray_im = single(rgb2gray(input_im));
        
    elseif sizez == 1
        
        gray_im = single(input_im);
        new_im = zeros(sizex, sizey, 3);
        for i=1:3
            new_im(:,:,i) = input_im;
        end
        input_im = new_im;
    end
        
    if settings.color_scheme == "RGB"            
        input_im = single(input_im);
    elseif settings.color_scheme == "rgb"
        input_im = single(rgb2normedrgb(im2double(input_im)));
    elseif settings.color_scheme == "opponent"
        input_im = single(rgb2opponent(input_im));
    end
        
    if settings.sift_type == "dense"
        [~, temp_descriptors1] = vl_dsift(input_im(:,:,1), 'step', 10);
        [~, temp_descriptors2] = vl_dsift(input_im(:,:,2), 'step', 10);
        [~, temp_descriptors3] = vl_dsift(input_im(:,:,3), 'step', 10);
        descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
        %[~, descriptors] = vl_phow(input_im, 'step', 10, 'color','rgb'); 
            
    elseif settings.sift_type == "keypoint"
            
        [temp_frames, ~] = vl_sift(gray_im);
        [~, temp_descriptors1] = vl_sift(input_im(:,:,1), 'frames', temp_frames);
        [~, temp_descriptors2] = vl_sift(input_im(:,:,2), 'frames', temp_frames);
        [~, temp_descriptors3] = vl_sift(input_im(:,:,3), 'frames', temp_frames);
        descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
    end
        
        
end

end
    
