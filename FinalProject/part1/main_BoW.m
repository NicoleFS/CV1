%% Parameters

% amount of images per category to compute centroids
images_kmeans = 100;

% amount of images per category to train SVM model on
images_train = 50;

% first image for testing per category
start_test_image = images_kmeans + images_train;

% amount of images per category for testing
images_testing = 50;


% amount of centroids for k-means
vocabulary_size = 400;


% colorspace and sift-type for feature extraction
color = "gray";
sift_type = "keypoint";

% path to imagefolder
path = '../Caltech4/ImageData/';


%% Feature extraction and k-means


% Get path to each image category folder and names
[path_air, path_car, path_face, path_motor, imagenames] = load_images(path, 'train');

%[path_to_airplanes, path_to_cars, path_to_faces, path_to_motorbikes, imagenames] = load_images(path, 'train');

%features = [];

%for i = 1:images_kmeans
    
%    image_title = imagenames(i).name;
    
%    A = extract_features(strcat(path_to_airplanes, image_title), "gray", "normal");
%    B = extract_features(strcat(path_to_cars, image_title), "gray", "normal");
%    C = extract_features(strcat(path_to_faces, image_title), "gray", "normal");
%    D = extract_features(strcat(path_to_motorbikes, image_title), "gray", "normal");
    
%    if i == 1
%        features = A;
%        features = cat(2, features, B, C, D);
%    else
%        features = cat(2, features, A, B, C, D);
%    end
%end

% Calculate features to do k-means on
features = obtain_features_kmeans(path_air, path_car, path_face, path_motor...
    , imagenames, images_kmeans, color, sift_type);

% Calculate centroids and assignments with k-means
[centers, assignments] = vl_ikmeans(features, vocabulary_size);
%% Creating training data and train SVMs

%labels
%labels_airplane = zeros(images_classify*4,1);
%labels_car = zeros(images_classify*4,1);
%labels_face = zeros(images_classify*4,1);
%labels_motorbike = zeros(images_classify*4,1);

%index_labels = 0;
%train_data = [];

% Extension of path to image folder of each category for training
paths_train = ["airplanes_train/", "cars_train/", "faces_train/", "motorbikes_train/"];

%for i = 1:length(paths)
    
%    current_path = strcat(path, char(paths(i)));
    
%    for j = images_kmeans+1:images_kmeans+images_classify
    
%        index_labels = index_labels + 1;
        
%        image_title = imagenames(j).name;
        
%        current_image = strcat(current_path, image_title);
        
%        if paths(i) == "airplanes_train/"
%            labels_airplane(index_labels) = 1;
%        elseif paths(i) == "cars_train/"
%            labels_car(index_labels) = 1;
%        elseif paths(i) == "faces_train/"
%            labels_face(index_labels) = 1;
%        elseif paths(i) == "motorbikes_train/"
%            labels_motorbike(index_labels) = 1;
%        end
        
%        image_features = extract_features(current_image, "gray", "normal");

        
%        [image_assignment] = vl_ikmeanspush(image_features, centers);

        
%        image_hist = hist(double(image_assignment), 400, 'Normalization', 'count');
%        train_data = [train_data ; image_hist];
    
%    end
    
%end


%train_data = sparse(train_data);

%trained models

%airplane_trained = train(labels_airplane, train_data);
%car_trained = train(labels_car, train_data);
%face_trained = train(labels_face, train_data);
%motorbike_trained = train(labels_motorbike, train_data);

% Compute labels for each category and training data for SVMs
[label_air_train, label_car_train, label_face_train, label_motor_train, traindata] = create_traindata(path...
    , paths_train, images_kmeans, images_train, imagenames, color, sift_type, centers, vocabulary_size);

% Train model per category using labels and training data
airplane_trained = train(label_air_train, traindata);
car_trained = train(label_car_train, traindata);
face_trained = train(label_face_train, traindata);
motorbike_trained = train(label_motor_train, traindata);

%% Create testdata and predict using trained SVMs

%labels_airplane_test = zeros(images_classify*4,1);
%labels_car_test = zeros(images_classify*4,1);
%labels_face_test = zeros(images_classify*4,1);
%labels_motorbike_test = zeros(images_classify*4,1);

%index_labels = 0;
%test_data = [];

% Extension of path to image folder of each category for testing
paths_test = ["airplanes_train/", "cars_train/", "faces_train/", "motorbikes_train/"];

%for i = 1:length(paths)
    
%    current_path = strcat(path, char(paths(i)));
    
%    for j = images_used+1:images_used+images_testing
    
%        index_labels = index_labels + 1;
        
%        image_title = imagenames(j).name;
        
%        current_image = strcat(current_path, image_title);
        
%        if paths(i) == "airplanes_train/"
%            labels_airplane_test(index_labels) = 1;
%        elseif paths(i) == "cars_train/"
%            labels_car_test(index_labels) = 1;
%        elseif paths(i) == "faces_train/"
%            labels_face_test(index_labels) = 1;
%        elseif paths(i) == "motorbikes_train/"
%            labels_motorbike_test(index_labels) = 1;
%        end
        
%        image_features = extract_features(current_image, "gray", "keypoint");

        
%        [image_assignment] = vl_ikmeanspush(image_features, centers);

%        image_hist = hist(double(image_assignment), 400, 'Normalization', 'count');
%        test_data = [test_data ; image_hist];
    
%    end
    
%end

%test_data = sparse(test_data);



%[prediction_airplane, accuracy_airplane, confidence_airplane] = predict(labels_airplane_test, test_data, airplane_trained);
%[prediction_car, accuracy_car, confidence_car] = predict(labels_car_test, test_data, car_trained);
%[prediction_face, accuracy_face, confidence_face] = predict(labels_face_test, test_data, face_trained);
%[prediction_motorbike, accuracy_motorbike, confidence_motorbike] = predict(labels_motorbike_test, test_data, motorbike_trained);


% Compute labels for each category and testing data for SVMs
[labels_air_test, labels_car_test, labels_face_test, labels_motor_test, testdata] = create_testdata(path, paths_test...
    , start_test_image, images_testing, imagenames, color, sift_type, centers, vocabulary_size); 

% Predict using the labels, testing data and trained model per category
[prediction_airplane, accuracy_airplane, confidence_airplane] = predict(labels_air_test, testdata, airplane_trained);
[prediction_car, accuracy_car, confidence_car] = predict(labels_car_test, testdata, car_trained);
[prediction_face, accuracy_face, confidence_face] = predict(labels_face_test, testdata, face_trained);
[prediction_motorbike, accuracy_motorbike, confidence_motorbike] = predict(labels_motor_test, testdata, motorbike_trained);







    










