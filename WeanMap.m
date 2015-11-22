classdef WeanMap
    %WeanMap is a map of Wean
    
    properties
        x_max;
        y_max;
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
            [map.y_max, map.x_max] = size(map.grid);
            map.r_y = map.res * map.y_max;
            map.r_x = map.res * map.x_max;
        end
        
        % Visualize the map
        function im = visualize(weanMap)
            colormap(gray);
            im = imagesc(flipud(weanMap.grid));
            set(gca, 'ydir', 'normal');
            
        end
        
        % Show the map image with robot position and laser points plotted.
        % The 'W' argument is a struct containing robot world coordinates
        % and (if applicable) laser world coordinates and laser range world
        % coordinates
        function im = visualizeRobotAndLaser(weanMap, W)
            colormap(gray);
            im = imagesc(flipud(weanMap.grid));
            hold on;
            
            grid_robot_pose = ceil(W.robot_pose/10);
            plot(grid_robot_pose(1), grid_robot_pose(2), 'bo');
            
            if W.type == 'L'
                grid_laser_points = ceil(W.laser_points/10);
                plot(grid_laser_points(1,:), grid_laser_points(2,:), 'rx');
            end
            
            set(gca,'ydir','normal');
        end
        
        
        % Return occupation status of grid, which will be in [0,1] or -1 to
        % indicate unknown. The input is in world (x,y) location
        function occ_status = getMapOcc(weanMap, x, y)
            % Convert world location to grid location
            grid_y = ceil(y / 10);
            grid_x = ceil(x / 10);
            indices = sub2ind(size(weanMap.grid), map.y_max - grid_y, grid_x);
            occ_status = weanMap.grid(indices);
        end
    end
    
end

