function [descriptors] = obtain_features_kmeans(path_to_airplanes...
    , path_to_cars, path_to_faces, path_to_motorbikes, imagefiles...
    , amount_of_images, color_scheme, type_of_sift)

for i = 1:amount_of_images
    
    image_title = imagefiles(i).name;
    
    A = extract_features(strcat(path_to_airplanes, image_title), color_scheme, type_of_sift);
    B = extract_features(strcat(path_to_cars, image_title), color_scheme, type_of_sift);
    C = extract_features(strcat(path_to_faces, image_title), color_scheme, type_of_sift);
    D = extract_features(strcat(path_to_motorbikes, image_title), color_scheme, type_of_sift);
    
    if i == 1
        descriptors = A;
        descriptors = cat(2, descriptors, B, C, D);
    else
        descriptors = cat(2, descriptors, A, B, C, D);
    end
end

end