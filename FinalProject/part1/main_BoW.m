%TO DO

% inladen map met images
% subset van de images pakken
% k-means

path = '/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/';
path_to_airplanes = strcat(path, 'airplanes_train/');
path_to_cars = strcat(path, 'cars_train/');
path_to_faces = strcat(path, 'faces_train/');
path_to_motorbikes = strcat(path, 'motorbikes_train/');

[imagefiles_airplanes, imagefiles_cars, imagefiles_faces, imagefiles_motorbikes] = load_images(path, 'train');

features = [];

for i = 1:25
    current_airplane_title = imagefiles_airplanes(i).name;
    %current_airplane_image = imread(current_airplane_title);
    
    current_car_title = imagefiles_cars(i).name;
    %current_car_image = imread(current_car_title);
    
    current_face_title = imagefiles_faces(i).name;
    %current_face_image = imread(current_face_title);
    
    current_motorbike_title = imagefiles_motorbikes(i).name;
    %current_motorbike_image = imread(current_motorbike_title);
    
    A = extract_features(strcat(path_to_airplanes, current_airplane_title), "gray", "normal");
    B = extract_features(strcat(path_to_cars, current_car_title), "gray", "normal");
    C = extract_features(strcat(path_to_faces, current_face_title), "gray", "normal");
    D = extract_features(strcat(path_to_motorbikes, current_motorbike_title), "gray", "normal");
    
    if i == 1
        features = A;
        features = cat(2, features, B, C, D);
    else
        features = cat(2, features, A, B, C, D);
    end
end


[centers, assignments] = vl_ikmeans(features, 400);



current_airplane_title = imagefiles_airplanes(51).name;
%current_airplane_image = imread(current_airplane_title);

current_airplane_features = extract_features(strcat(path_to_airplanes, current_airplane_title), "gray", "normal");

[airplane_assignment] = vl_ikmeanspush(current_airplane_features, centers);


    










%path_to_airplanes = '/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/';
%imagefiles_airplane = dir([path_to_airplanes '*.jpg']);

%path_to_cars = '/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/cars_train/';
%imagefiles_cars = dir([path_to_cars '*.jpg']);

%path_to_faces = '/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/faces_train/';
%imagefiles_faces = dir([path_to_faces '*.jpg']);

%path_to_motorbikes = '/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/motorbikes_train/';
%imagefiles_motorbikes = dir([path_to_motorbikes '*.jpg']);

%A = extract_features(strcat(path_to_airplanes, current_airplane_title), "gray", "normal");
%B = extract_features(strcat(path_to_cars, current_car_title), "gray", "normal");
%C = extract_features(strcat(path_to_faces, current_face_title), "gray", "normal");
%D = extract_features(strcat(path_to_motorbikes, current_motorbike_title), "gray", "normal");

%E = cat(2,A,B,C,D);
%B = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"gray","normal");

%C = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"RGB","dense");
%D = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"RGB","normal");

%E = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"rgb","dense");
%F = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"rgb","normal");

%G = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"opponent","dense");
%H = extract_features('/home/nicole/ArtificialIntelligence/CV1/Gitcode/CV1/FinalProject/Caltech4/ImageData/airplanes_train/img001.jpg',"opponent","normal");