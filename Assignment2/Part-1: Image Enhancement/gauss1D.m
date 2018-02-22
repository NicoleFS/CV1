function G = gauss1D(sigma, kernel_size)
    G = ones(1, kernel_size)./(sigma*sqrt(2*pi));
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    %% solution
    r = floor(kernel_size/2);
    x = -r:r;
    G = G .* exp(-((x.*x)/(2*sigma^2)));
    G = G ./ sum(G);
end