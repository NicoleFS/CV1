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
%         image_hist = (image_hist - mean(image_hist)) ./ var(image_hist);
        traindata = [traindata; image_hist];   
        trainlabels = [trainlabels; labels(i)];
    end
    
    % Do the same for the test set
    select = (imdb.images.labels == c & imdb.images.set == 2);
    paths = imdb.images.paths(select);
    labels = imdb.images.labels(select);
    for i = 1:sum(select)
        descriptor = extract_features(paths(i), settings);
        [features] = vl_ikmeanspush(descriptor, kmeans_centers);
        image_hist = hist(double(features), settings.vocab_size, 'Normalization', 'count');      
%         image_hist = (image_hist - mean(image_hist)) ./ var(image_hist);
        testdata = [testdata; image_hist];   
        testlabels = [testlabels; labels(i)];
    end
end

% zero meain features
traindata = (traindata - mean(traindata)) ./ var(traindata);
testdata = (testdata - mean(testdata)) ./ var(testdata);

% Shuffle the data set
perm = randperm(length(trainlabels));
trainlabels = trainlabels(perm);
traindata = traindata(perm, :);

% Create train set
trainset.labels = double(trainlabels);
trainset.features = sparse(double(traindata));

% Do the same for the test set
perm = randperm(length(testlabels));
testlabels = testlabels(perm);
testdata = testdata(perm, :);
testset.labels = double(testlabels);
testset.features = sparse(double(testdata));

end