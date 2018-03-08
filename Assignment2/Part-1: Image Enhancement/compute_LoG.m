function imOut = compute_LoG(image, LOG_type)

% read image
im = imread(image);

% according to entered LoG_type, apply corresponding method
switch LOG_type
    case 1
        %method 1
        im = imfilter(im, gauss2D(0.5, 5));
        lap = fspecial('laplacian');
        imOut = imfilter(im, lap);
        
    case 2
        %method 2
        LoG = fspecial('log',5,0.5);
        imOut = imfilter(im, LoG);

    case 3
        %method 3
        sigma1 = 1.6;
        sigma2 = 1;
       
        gauss1 = fspecial('gauss',5, sigma1);
        gauss2 = fspecial('gauss',5, sigma2);
        
        imOut1 = imfilter(im, gauss1);
        imOut2 = imfilter(im, gauss2);
        
        imOut = imOut2 - imOut1;
        imOut = imOut * (255/max(imOut(:)));
end
end

