function [H, r, c] = harris_corner_detector(im, threshold, n, kernel_size, sigma)    
    % https://stackoverflow.com/questions/23980080/derivative-of-gaussian-filter-in-matlab
    G = fspecial('gauss', [round(kernel_size*sigma), round(kernel_size*sigma)], sigma);
    [Gx, Gy] = gradient(G);  
    
    Ix = imfilter(im, Gx);
    Iy = imfilter(im, Gy);
    
    A = imfilter(Ix .* Ix, G);
    B = imfilter(Ix .* Iy, G);
    C = imfilter(Iy .* Iy, G);
    
    H = (A.*C-B.*B) - 0.04*(A+C).^2;
    
    % https://nl.mathworks.com/help/images/ref/ordfilt2.html?requestedDomain=true
    % Note: if (in theory) the maximum value occurs twive in the nxn area
    % then both will be seen as a possible maximum
    n2 = n*n;
    H_max = ordfilt2(H, n2, ones(n, n));
    corners = (H_max == H & H_max > threshold);
    [r, c] = find(corners == 1);
    
    figure;
    subplot(131), imshow(255*Ix/max(max(Ix)));
    title('Derivative x-direction');
    
    subplot(132); imshow(255*Iy/max(max(Iy)));
    title('Derivative y-direction');
    
    subplot(133);
    imshow(im);
    hold on
    plot(c, r, 'go');
    title('Image with corners');
    hold off
end