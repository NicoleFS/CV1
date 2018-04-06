clc
clearvars
close all


%%
run vlfeat-0.9.21/toolbox/vl_setup.m
addpath liblinear-2.1/matlab

%% Parameters

% amount of images per category to train SVM model on
settings.images_train = 50;

% % amount of images per category for testing
% settings.images_test = 50;

% amount of images per category to compute centroids
settings.images_kmeans = 100;
% amount of centroids for k-means
settings.vocab_size = 400;

% colorspace and sift-type for feature extraction
settings.color_scheme = "rgb";
settings.sift_type = "dense";

% path to imagefolder
settings.image_folder = '../Caltech4/ImageData/';

% structure with links to all images
imdb = getCaltechIMDB(settings.image_folder);

%% Get K-means centers
% load('100im_400voc_opponent_keypoint.mat')
kmeans_centers = get_kmeans_centers(imdb, settings);

% Shuffle the kmeans centers
% kmeans_centers = kmeans_centers(:, randperm(size(kmeans_centers, 2)));


%% Preparing data set for SVM
% Computes train and test for the SVM, based on the kmeans centroids
[trainset, testset] = get_svm_data(imdb, kmeans_centers, settings);

%% SVM models
% Creates a SVM model for each class
models = [];
for c = 1:numel(imdb.meta.classes)
    labels = double(trainset.labels == c);
    best = train(labels, trainset.features, '-C -s 0 -q');
    model = train(labels, trainset.features, sprintf('-c %f -s 0 -q', best(1))); % use the same solver: -s 0
%     model = train(labels, trainset.features, '-s 0 -q');
    models = [models model];
end

%% Predict with trained SVM
% Does a prediction for all test images
aps = [];
for c = 1:numel(imdb.meta.classes)
    labels = double(testset.labels == c);
    [prediction, accuracy, confidence] = predict(labels, testset.features, models(c), '-b 1 -q');
    ap1 = average_precision(confidence(:, 1), labels, sum(labels));
    ap2 = average_precision(confidence(:, 2), labels, sum(labels));
    if ap1 > ap2
        ap = ap1;
    else
        ap = ap2;
    end
    aps = [aps ap];
    fprintf('Class %s has an average precision of %.5f\n', imdb.meta.classes{c}, ap);
end
fprintf('Mean average precision: %.5f\n', mean(aps));

%% Helper functions

function [kmeans_centers] = get_kmeans_centers(imdb, settings)
%% Feature extraction
% Extracts SIFT features of some images to be used for k-means 
features = obtain_features_kmeans(imdb, settings);

%% K-means
% Calculates K-means centroids.
[kmeans_centers, ~] = vl_ikmeans(features, settings.vocab_size);

%% Save model
save(sprintf('%.0fim_%.0fvoc_%s_%s.mat', settings.images_kmeans, settings.vocab_size, settings.color_scheme, settings.sift_type), 'kmeans_centers');
end

function [ap] = average_precision(confidence, labels, n, direction)
if nargin < 4
    direction = 'descend';
end
% Gets the average precision
ap = 0;
ordered = sortrows([confidence, labels], direction);
correct = 0;
for i=1:size(ordered, 1)
    correct = correct + ordered(i, 2);
    ap = ap + ordered(i, 2)*correct/i;
end
ap = ap/n;
end


function imdb = getCaltechIMDB(image_folder)
% Prepare the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

paths = string();
paths_index = 1;
labels = [];
sets = [];
for c = 1:numel(classes)
    for s = 1:numel(splits)
        f = strcat(image_folder, classes{c}, '_', splits{s});
        full_path = fullfile(pwd, f);
        images = dir(strcat(full_path, '/', '*.jpg'));
        for i = 1:numel(images)
            im_path = strcat(images(i).folder, '/', images(i).name);
            paths{paths_index} = im_path;
            paths_index = paths_index + 1;
        end
        labels = [labels c*ones(1, numel(images))];
        sets = [sets s*ones(1, numel(images))];
    end
end

%%
imdb.images.paths = paths.' ;
imdb.images.labels = single(labels).' ;
imdb.images.set = sets.';
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.paths = imdb.images.paths(perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end






