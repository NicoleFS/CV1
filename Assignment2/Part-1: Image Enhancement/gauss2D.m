function G = gauss2D(sigma, kernel_size)
    %% solution
    G = zeros(kernel_size, kernel_size);
    Gx = gauss1D(sigma, kernel_size);
    for i = 1:kernel_size
        G(i, :) = Gx(i) * Gx;
    end
end
