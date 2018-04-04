%TO DO       
%

% inladen map met images
% subset van de images pakken
% k-means


images_kmeans = 50;
images_classify = 50;

path = '../Caltech4/ImageData/';

[path_to_airplanes, path_to_cars, path_to_faces, path_to_motorbikes, imagenames] = load_images(path, 'train');

features = [];

for i = 1:images_kmeans
    
    image_title = imagenames(i).name;
    
    A = extract_features(strcat(path_to_airplanes, image_title), "gray", "normal");
    B = extract_features(strcat(path_to_cars, image_title), "gray", "normal");
    C = extract_features(strcat(path_to_faces, image_title), "gray", "normal");
    D = extract_features(strcat(path_to_motorbikes, image_title), "gray", "normal");
    
    if i == 1
        features = A;
        features = cat(2, features, B, C, D);
    else
        features = cat(2, features, A, B, C, D);
    end
end


[centers, assignments] = vl_ikmeans(features, 400);

%%

%labels
labels_airplane = zeros(images_classify*4,1);
labels_car = zeros(images_classify*4,1);
labels_face = zeros(images_classify*4,1);
labels_motorbike = zeros(images_classify*4,1);

index_labels = 0;
train_data = [];

paths = ["airplanes_train/", "cars_train/", "faces_train/", "motorbikes_train/"];

for i = 1:length(paths)
    
    current_path = strcat(path, char(paths(i)));
    
    for j = images_kmeans+1:images_kmeans+images_classify
    
        index_labels = index_labels + 1;
        
        image_title = imagenames(j).name;
        
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
        
        image_features = extract_features(current_image, "gray", "normal");

        
        [image_assignment] = vl_ikmeanspush(image_features, centers);

        
        image_hist = hist(double(image_assignment), 400, 'Normalization', 'count');
        train_data = [train_data ; image_hist];
    
    end
    
end


train_data = sparse(train_data);

%trained models

airplane_trained = train(labels_airplane, train_data);
car_trained = train(labels_car, train_data);
face_trained = train(labels_face, train_data);
motorbike_trained = train(labels_motorbike, train_data);

%%

labels_airplane_test = zeros(images_classify*4,1);
labels_car_test = zeros(images_classify*4,1);
labels_face_test = zeros(images_classify*4,1);
labels_motorbike_test = zeros(images_classify*4,1);

index_labels = 0;
test_data = [];

images_used = images_kmeans + images_classify;
images_testing = 50;


paths = ["airplanes_train/", "cars_train/", "faces_train/", "motorbikes_train/"];

for i = 1:length(paths)
    
    current_path = strcat(path, char(paths(i)));
    
    for j = images_used+1:images_used+images_testing
    
        index_labels = index_labels + 1;
        
        image_title = imagenames(j).name;
        
        current_image = strcat(current_path, image_title);
        
        if paths(i) == "airplanes_train/"
            labels_airplane_test(index_labels) = 1;
        elseif paths(i) == "cars_train/"
            labels_car_test(index_labels) = 1;
        elseif paths(i) == "faces_train/"
            labels_face_test(index_labels) = 1;
        elseif paths(i) == "motorbikes_train/"
            labels_motorbike_test(index_labels) = 1;
        end
        
        image_features = extract_features(current_image, "gray", "normal");

        [image_assignment] = vl_ikmeanspush(image_features, centers);

        image_hist = hist(double(image_assignment), 400, 'Normalization', 'count');
        test_data = [test_data ; image_hist];
    
    end
    
end

test_data = sparse(test_data);

[prediction_airplane, accuracy_airplane, confidence_airplane] = predict(labels_airplane_test, test_data, airplane_trained);
[prediction_car, accuracy_car, confidence_car] = predict(labels_car_test, test_data, car_trained);
[prediction_face, accuracy_face, confidence_face] = predict(labels_face_test, test_data, face_trained);
[prediction_motorbike, accuracy_motorbike, confidence_motorbike] = predict(labels_motorbike_test, test_data, motorbike_trained);


%% Mean average precision

meanAP(confidence_airplane, labels_airplane_test, direction)
meanAP(confidence_car, labels_car_test, direction)
meanAP(confidence_face, labels_face_test, direction)
meanAP(confidence_motorbike, labels_motorbike_test, direction)

%%
function [ap] = meanAP(confidence, labels)
    ap = 0;
    n = 50;
    order = sortrows([confidence, labels], 'descend');
    correct = 0;
    for i=1:size(order, 1)
        correct = correct + order(i, 2);
        ap = ap + order(i,2)*correct/i;
    end
    ap = ap/n;
end


