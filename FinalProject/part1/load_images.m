function [airplanes, cars, faces, motorbikes] = load_images(path, type)

if type == 'train'
    path_to_airplanes = strcat(path, 'airplanes_train/');
    path_to_cars = strcat(path, 'cars_train/');
    path_to_faces = strcat(path, 'faces_train/');
    path_to_motorbikes = strcat(path, 'motorbikes_train/');
end

airplanes = dir([path_to_airplanes '*.jpg']);
cars = dir([path_to_cars '*.jpg']);
faces = dir([path_to_faces '*.jpg']);
motorbikes = dir([path_to_motorbikes '*.jpg']);

end