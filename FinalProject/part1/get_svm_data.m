function [trainset, testset] = get_svm_data(imdb, kmeans_centers, settings)
% Prepares the data for the SVM
%
% [trainset testset] = get_svm_data(imdb, kmeans_centers, settings)
%   imdb            Structures with all the information of the images.
%   kmeans_centers  Number of Kmeans centers.
%   settings        Settings of the sift, color scheme and sift type.
%
% Output
%   trainset        Training set
%   testset         Test set

traindata = [];
trainlabels = [];
testdata = [];
testlabels = [];
for c = 1:numel(imdb.meta.classes)
    select = (imdb.images.labels == c & imdb.images.set == 1);
    % Paths to training images per class
    paths = imdb.images.paths(select);
    % Corresponding labels
    labels = imdb.images.labels(select);
    % Extract features for all training images, do not use the images 
    % used to construct the kmeans centers.
    for i = 1+settings.images_kmeans:settings.images_kmeans+settings.images_train   
        % Sift features
        descriptor = extract_features(paths(i), settings);
        % Kmeans features
        [features] = vl_ikmeanspush(descriptor, kmeans_centers);
        % Create histogram of the features
        image_hist = hist(double(features), settings.vocab_size, 'Normalization', 'count');      
        traindata = [traindata; image_hist];   
        trainlabels = [trainlabels; labels(i)];
    end
    
    % The same for test set
    select = (imdb.images.labels == c & imdb.images.set == 2);
    paths = imdb.images.paths(select);
    labels = imdb.images.labels(select);
    for i = 1:sum(select)
        descriptor = extract_features(paths(i), settings);
        [features] = vl_ikmeanspush(descriptor, kmeans_centers);
        image_hist = hist(double(features), settings.vocab_size, 'Normalization', 'count');      
        testdata = [testdata; image_hist];   
        testlabels = [testlabels; labels(i)];
    end
end

% Create test and train set
trainset.labels = double(trainlabels);
trainset.features = sparse(double(traindata));
perm = randperm(length(trainset.labels));
trainset.labels = trainset.labels(perm);
trainset.features = trainset.features(perm, :);

testset.labels = double(testlabels);
testset.features = sparse(double(testdata));
perm = randperm(length(testset.labels));
testset.labels = testset.labels(perm);
testset.features = testset.features(perm, :);

end