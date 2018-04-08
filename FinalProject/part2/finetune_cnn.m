function [net, info, expdir] = finetune_cnn(varargin)


%% Define options
run(fullfile(fileparts(mfilename('fullpath')), ...
  'matconvnet-1.0-beta25', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet_bs100_lr303020' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
% if ~isfield(opts.train, 'gpus') opts.train.gpus = []; end;
% 
% opts.train.gpus = [];

%% update model

net = update_model();

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB() ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

end


% -------------------------------------------------------------------------
function imdb = getCaltechIMDB()
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%% TODO: Implement your loop here, to create the data structure described in the assignment
image_folder = '../Caltech4/ImageData/';

data = [];
labels = [];
sets = [];
for c = 1:numel(classes)
    for s = 1:numel(splits)
        f = strcat(image_folder, classes{c}, '_', splits{s});
        images = loadImages(f, '*.jpg');
        result = imresize3(im2single(images{1}), [32, 32, 3]);
        N = length(images);
        for i = 2:N
            if length(size(images{i})) == 3
                im = imresize3(im2single(images{i}), [32, 32, 3]);
            else
                im = imresize(im2single(images{i}), [32, 32]);
                im = cat(3, im, im, im);
            end
            result = cat(4, result, im);
        end
        data = cat(4, data, result);
        labels = [labels c*ones(1, N)];
        sets = [sets, s*ones(1, N)];
    end
end

%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);

imdb.images.data = data ;
imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end

function Seq = loadImages(imgPath, imgType)
    %imgPath = 'path/to/images/folder/';
    %imgType = '*.png'; % change based on image type
    full_path = fullfile(pwd, imgPath);
    images  = dir(strcat(full_path, '/', imgType));
    N = length(images);

    % check images
    if( ~exist(imgPath, 'dir') || N < 1 )
        disp('Directory not found or no matching images found.');
    end

    % preallocate cell
    Seq{N,1} = [];

    for idx = 1:N
        im_path = strcat(full_path, '/', images(idx).name);
        Seq{idx} = imread(im_path);
    end
end

