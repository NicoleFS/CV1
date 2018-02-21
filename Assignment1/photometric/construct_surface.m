function [ height_map ] = construct_surface(p, q, path_type)
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'column';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        
        % first the most left column
        for y = 2:h
            height_map(y, 1) = height_map(y-1, 1) + q(y, 1);
        end
        % for each row
        for y = 1:h
            % go over all values
            for x = 2:w
                height_map(y, x) = height_map(y, x-1) + p(y, x);
            end
        end
       
        % =================================================================
               
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE
        % for top row
        for x = 2:w
            height_map(1, x) = height_map(1, x-1) + p(1, x);
        end
        % for each column
        for x = 1:w
            % go over all values
            for y = 2:h
                height_map(y, x) = height_map(y-1, x) + q(y, x);
            end
        end        

        % =================================================================
          
    case 'average'
        
        % =================================================================
        % YOUR CODE GOES HERE
        % average both cases from above
        height_map1 = zeros(h, w);
        height_map2 = zeros(h, w);
        for x = 2:h
            height_map1(x, 1) = height_map1(x-1, 1) + q(x, 1);
        end
        for x = 1:h
            for y = 2:w
                height_map1(x, y) = height_map1(x, y-1) + p(x, y);
            end
        end
        for y = 2:w
            height_map2(1, y) = height_map2(1, y-1) + p(1, y);
        end
        for y = 1:w
            for x = 2:h
                height_map2(x, y) = height_map2(x-1, y) + q(x, y);
            end
        end
        height_map = (height_map1+height_map2)./2;
        
        % =================================================================
end


end

