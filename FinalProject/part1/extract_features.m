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
        [~, descriptors] = vl_dsift(image, 10);
    elseif type_of_sift == "normal"
        [~, descriptors] = vl_sift(image);
    end

elseif color_scheme == "RGB"
    if sizez == 3
        temp_im = single(rgb2gray(input_im));
        input_im = single(input_im);
        if type_of_sift == "dense"
            [~, descriptors] = vl_phow(input_im, 'step', 10, 'color','rgb');            
        elseif type_of_sift == "normal"
            [temp_frames, ~] = vl_sift(temp_im);
            [~, temp_descriptors1] = vl_sift(input_im(:,:,1), 'frames', temp_frames);
            [~, temp_descriptors2] = vl_sift(input_im(:,:,2), 'frames', temp_frames);
            [~, temp_descriptors3] = vl_sift(input_im(:,:,3), 'frames', temp_frames);
            descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
        end
        
    end    
        
    
elseif color_scheme == "rgb"
    if sizez == 3
        temp_im = single(rgb2gray(input_im));
        input_im = single(rgb2normedrgb(input_im));
        if type_of_sift == "dense"
            [~, descriptors] = vl_phow(input_im, 'step', 10, 'color', 'rgb');
        elseif type_of_sift == "normal"
            [temp_frames, ~] = vl_sift(temp_im);
            [~, temp_descriptors1] = vl_sift(input_im(:,:,1), 'frames', temp_frames);
            [~, temp_descriptors2] = vl_sift(input_im(:,:,2), 'frames', temp_frames);
            [~, temp_descriptors3] = vl_sift(input_im(:,:,3), 'frames', temp_frames);
            descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
        end
        
    end
    
elseif color_scheme == "opponent"
    if sizez == 3
        temp_im = single(rgb2gray(input_im));
        input_im = single(rgb2opponent(input_im));
        if type_of_sift == "dense"
            [~, descriptors] = vl_phow(input_im, 'step', 10, 'color', 'opponent');
        elseif type_of_sift == "normal"
            [temp_frames, ~] = vl_sift(temp_im);
            [~, temp_descriptors1] = vl_sift(input_im(:,:,1), 'frames', temp_frames);
            [~, temp_descriptors2] = vl_sift(input_im(:,:,2), 'frames', temp_frames);
            [~, temp_descriptors3] = vl_sift(input_im(:,:,3), 'frames', temp_frames);
            descriptors = cat(1, temp_descriptors1, temp_descriptors2, temp_descriptors3);
        end
        
    end
            
    
end

end