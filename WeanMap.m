classdef WeanMap
    %WeanMap is a map of Wean
    
    properties
        res = 10; % The resolution of the map in cm
        r_y; % The real "height" of the map in cm
        r_x; % The real "width" of the map in cm
        grid = []; % Matrix that contains the map
        image = []; % Matrix that contains the map image
    end
    
    methods
        % Construct the map from a .mat file containing a grid
        function map = WeanMap(file)
            load(file);
            map.grid = map_grid;
            map.image = repmat(map_grid, [1,1,3]);
            [y, x] = size(map.grid);
            map.r_y = map.res * y;
            map.r_x = map.res * x;
        end
        
        % Visualize the map
        function im = visualize(weanMap)
            im = imshow(weanMap.image);
        end
        
        % Show the map image with robot position
        function im = visualizeRobotPose(weanMap, x, y)
            % Update position to reflect resolution
            x = ceil(x / weanMap.res);
            % Create range of values to display in order to be visible
            x = (x - 3:x + 3);
            x(x < 1) = 1;
            x(x > size(weanMap.image,2)) = size(weanMap.image,2);
            % Same process for y
            y = ceil(y / weanMap.res);
            y = (y - 3:y + 3);
            y(y < 1) = 1;
            y(y > size(weanMap.image,1)) = size(weanMap.image,1);
            weanMap.image(y,x,1) = 1;
            weanMap.image(y,x,2) = 0;
            weanMap.image(y,x,3) = 0;
            im = imshow(weanMap.image);
        end
        
        % Return occupation status of grid, which will be in [0,1] or -1 to
        % indicate unknown. The input is in world (x,y) location
        function occ_status = getMapOcc(weanMap, y, x)
            
            % Convert world location to grid location
            grid_y = ceil(y / 10);
            grid_x = ceil(x / 10);
            indices = sub2ind(size(weanMap.grid), grid_y, grid_x);
            occ_status = weanMap.grid(indices);
        end
    end
    
end

