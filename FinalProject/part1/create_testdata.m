function [labels_airplane, labels_car, labels_face, labels_motorbike, test_data] = create_testdata(path...
    , paths, last_image, no_of_test_images, imagefiles, color_scheme, type_of_sift, kmeans_centers, vocab_size)

labels_airplane = zeros(no_of_test_images*4,1);
labels_car = zeros(no_of_test_images*4,1);
labels_face = zeros(no_of_test_images*4,1);
labels_motorbike = zeros(no_of_test_images*4,1);

index_labels = 0;
test_data = [];

for i = 1:length(paths)
    
    current_path = strcat(path, char(paths(i)));
    
    for j = last_image+1:last_image+no_of_test_images
    
        index_labels = index_labels + 1;
        
        image_title = imagefiles(j).name;
        
        current_image = strcat(current_path, image_title);
        
        if paths(i) == "airplanes_train/"
            labels_airplane(index_labels) = 1;
        elseif paths(i) == "cars_train/"
            labels_car(index_labels) = 1;
        elseif paths(i) == "faces_train/"
            labels_face(index_labels) = 1;
        elseif paths(i) == "motorbikes_train/"
            labels_motorbike(index_labels) = 1;
        end
        
        image_features = extract_features(current_image, color_scheme, type_of_sift);

        
        [image_assignment] = vl_ikmeanspush(image_features, kmeans_centers);

        image_hist = hist(double(image_assignment), vocab_size, 'Normalization', 'count');
        test_data = [test_data ; image_hist];
    
    end
    
end

test_data = sparse(test_data);

end