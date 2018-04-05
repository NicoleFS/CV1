function [features] = obtain_features_kmeans(imdb, settings)
% Obtains the SIFT features to be used by kmeans.
%
% [features] = obtain_features_kmeans(imdb, settings)
%   imdb            Structures with all the information of the images.
%   settings        Settings of the sift, color scheme and sift type.
%
% Output
%   features        All features

features = [];
for c = 1:numel(imdb.meta.classes)
    % Paths to training images for each class
    paths = imdb.images.paths((imdb.images.labels == c & imdb.images.set == 1));
    % Per class get features for image_kmeans images
    for i = 1:settings.images_kmeans
        % Extracts SIFT features for this image
        im_features = extract_features(paths(i), settings);  
        features = [features im_features];
    end
end

% Shuffle the features
% features = features(:, randperm(size(features, 2)));

end