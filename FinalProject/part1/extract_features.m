function [descriptors] = extract_features(input_image, color_scheme, type_of_sift)


input_im = imread(input_image);

[~,~,sizez] = size(input_im);

if color_scheme == "gray"
    if sizez == 3
        image = single(rgb2gray(input_im));
    else
        image = single(input_im);
    end
    
    if type_of_sift == "dense"
        [frames, descriptors] = vl_dsift(image, 10);
    elseif type_of_sift == "normal"
        [frames, descriptors] = vl_sift(image);
    end

elseif color_scheme == "RGB"
    if sizez == 3
        if type_of_sift == "dense"
            [temp_frames1, temp_descriptors1] = vl_dsift(input_im(:,:,1), 10);
            [temp_frames2, temp_descriptors2] = vl_dsift(input_im(:,:,2), 10);
            [temp_frames3, temp_descriptors3] = vl_dsift(input_im(:,:,3), 10);
        elseif type_of_sift == "normal"
            [temp_frames1, temp_descriptors1] = vl_sift(input_im(:,:,1), 10);
            [temp_frames2, temp_descriptors2] = vl_sift(input_im(:,:,2), 10);
            [temp_frames3, temp_descriptors3] = vl_sift(input_im(:,:,3), 10);
        
    
elseif color_scheme == "rgb"
    if sizez == 3
        if type_of_sift == "dense"
            [temp_frames1, temp_descriptors1] = vl_dsift(input_im(:,:,1), 10);
            [temp_frames2, temp_descriptors2] = vl_dsift(input_im(:,:,2), 10);
            [temp_frames3, temp_descriptors3] = vl_dsift(input_im(:,:,3), 10);
        elseif type_of_sift == "normal"
            [temp_frames1, temp_descriptors1] = vl_sift(input_im(:,:,1), 10);
            [temp_frames2, temp_descriptors2] = vl_sift(input_im(:,:,2), 10);
            [temp_frames3, temp_descriptors3] = vl_sift(input_im(:,:,3), 10);
        end
    end
    
elseif color_scheme == "opponent"
    if sizez == 3
        if type_of_sift == "dense"
            [temp_frames1, temp_descriptors1] = vl_dsift(input_im(:,:,1), 10);
            [temp_frames2, temp_descriptors2] = vl_dsift(input_im(:,:,2), 10);
            [temp_frames3, temp_descriptors3] = vl_dsift(input_im(:,:,3), 10);
        elseif type_of_sift == "normal"
            [temp_frames1, temp_descriptors1] = vl_sift(input_im(:,:,1), 10);
            [temp_frames2, temp_descriptors2] = vl_sift(input_im(:,:,2), 10);
            [temp_frames3, temp_descriptors3] = vl_sift(input_im(:,:,3), 10);
        end
    end
            
    
end


%if type_of_sift == "dense"
%    [frames, descriptors] = vl_dsift(image, 10);
%elseif type_of_sift == "normal"
%    [frames, descriptors] = vl_sift(image);
%end



end