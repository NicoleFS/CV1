function [descriptors] = extract_features(input_image, color_scheme, type_of_sift)


input_im = imread(input_image);

[sizex,sizey,sizez] = size(input_im);

if color_scheme == "gray"
    if sizez == 3
        image = single(rgb2gray(input_im));
    else
        image = single(input_im);
    end
    
    if type_of_sift == "dense"
        [~, descriptors] = vl_dsift(image, 'step', 10);
    elseif type_of_sift == "keypoint"
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
        
    if color_scheme == "RGB"            
        input_im = single(input_im);
    elseif color_scheme == "rgb"
        input_im = single(rgb2normedrgb(input_im));
    elseif color_scheme == "opponent"
        input_im = single(rgb2opponent(input_im));
    end
        
    if type_of_sift == "dense"
            
        [~, temp_descriptors1] = vl_dsift(input_im(:,:,1), 'step', 10);
        [~, temp_descriptors2] = vl_dsift(input_im(:,:,2), 'step', 10);
        [~, temp_descriptors3] = vl_dsift(input_im(:,:,3), 'step', 10);
            
        descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
        %[~, descriptors] = vl_phow(input_im, 'step', 10, 'color','rgb'); 
            
    elseif type_of_sift == "keypoint"
            
        [temp_frames, ~] = vl_sift(gray_im);
        [~, temp_descriptors1] = vl_sift(input_im(:,:,1), 'frames', temp_frames);
        [~, temp_descriptors2] = vl_sift(input_im(:,:,2), 'frames', temp_frames);
        [~, temp_descriptors3] = vl_sift(input_im(:,:,3), 'frames', temp_frames);
        descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
    end
        
        
end

end
    
