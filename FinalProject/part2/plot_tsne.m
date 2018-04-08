function [ydata, labels] = plot_tsne(nets, data)

%% replace loss with the classification as we will extract features
nets.pre_trained.layers{end}.type = 'softmax';
nets.fine_tuned.layers{end}.type = 'softmax';

% %% extract features and train SVM classifiers, by validating their hyperparameters
% [d.trainset, d.testset] = get_svm_data(data, net);
% 
% %% measure the accuracy of different settings
% [predictions, ~] = get_predictions(d);
% disp(predictions);

%%
predictions = [];
labels = [];
for i = 1:size(data.images.data, 4)  
    res = vl_simplenn(nets.pre_trained, data.images.data(:, :,:, i));
    predict = res(11).x;
    predict = reshape(predict, 1, 64);
    predictions = [predictions; predict];
    labels = [labels; data.images.labels(i)];
end

%%
% ydata = tsne(predictions);
% figure(2);
% plot(ydata(:, 1), ydata(:, 2), '.');
% title('Pretrained, without labels');

figure;
ydata = tsne(predictions, labels);
figure;
gscatter(ydata(:, 1), ydata(:, 2), labels, [], 'ox+*sdv^<>ph.');
axis off
% title('Labels');

F = getframe(gca);
imwrite(F.cdata, 'figures/tsne-pre.png');

%%
predictions = [];
labels = [];
for i = 1:size(data.images.data, 4)  
    res = vl_simplenn(nets.fine_tuned, data.images.data(:, :,:, i));
    predict = res(11).x;
    predict = reshape(predict, 1, 64);
    predictions = [predictions; predict];
    labels = [labels; data.images.labels(i)];
end

%%
% ydata = tsne(predictions);
% figure(1);
% plot(ydata(:, 1), ydata(:, 2), '.');
% title('Fine tuned, without labels');
% 
figure;
ydata = tsne(predictions, labels);
figure;
gscatter(ydata(:, 1), ydata(:, 2), labels, [], 'ox+*sdv^<>ph.');
axis off
title('Labels');

F = getframe(gca);
imwrite(F.cdata, 'figures/tsne-fine.png');

end


function [predictions, accuracy] = get_predictions(data)

best = train(data.trainset.labels, data.trainset.features, '-C -s 0');
model = train(data.trainset.labels, data.trainset.features, sprintf('-c %f -s 0', best(1))); % use the same solver: -s 0
[predictions, accuracy, ~] = predict(data.testset.labels, data.testset.features, model);

end

function [trainset, testset] = get_svm_data(data, net)

trainset.labels = [];
trainset.features = [];

testset.labels = [];
testset.features = [];
for i = 1:size(data.images.data, 4)
    
    res = vl_simplenn(net, data.images.data(:, :,:, i));
    feat = res(end-3).x; feat = squeeze(feat);
    
    if(data.images.set(i) == 1)
        
        trainset.features = [trainset.features feat];
        trainset.labels   = [trainset.labels;  data.images.labels(i)];
        
    else
        
        testset.features = [testset.features feat];
        testset.labels   = [testset.labels;  data.images.labels(i)];
        
        
    end
    
end

trainset.labels = double(trainset.labels);
trainset.features = sparse(double(trainset.features'));

testset.labels = double(testset.labels);
testset.features = sparse(double(testset.features'));

end