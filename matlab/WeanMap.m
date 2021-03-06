classdef WeanMap < handle
    %WeanMap is a map of Wean
    
    properties
        x_max;
        y_max;
        res = 10; % The resolution of the map in cm
        r_y; % The real "height" of the map in cm
        r_x; % The real "width" of the map in cm
        grid = []; % Matrix that contains the map
        image = []; % Matrix that contains the map image
        ray_traces;
    end
    
    methods
        % Construct the map from a .mat file containing a grid
        function map = WeanMap(file)
            load(file);
            map.grid = map_grid;
            map.grid(map.grid == -1) = 0;
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
        function im = visualizeRobotAndLaser(weanMap, P)
            colormap(gray);
            im = imagesc(flipud(weanMap.grid));
            hold on;
            
            grid_robot_pose = ceil(P.robot_pose/10);
            plot(grid_robot_pose(1), grid_robot_pose(2), 'bo');
            
            if P.type == 'L'
                grid_laser_points = ceil(P.laser_points/10);
                plot(grid_laser_points(1,:), grid_laser_points(2,:), 'rx');
            end
            
            set(gca,'ydir','normal');
        end
        
        % Basic visualization for initial particle positions
        function im = visualizeParticles(weanMap, P, show)
            im = weanMap.grid;
            for p = 1:numel(P)
                particle = P{p};
                x = particle.robot_pose(1);
                y = particle.robot_pose(2);
                idx = weanMap.convertPosition(x,y);
                im(idx) = -10;
            end
            if show
                imagesc(im);
            end
        end
        
        % Convert world position to map indices
        function [idx, grid_x, grid_y] = convertPosition(weanMap, x, y)
            if sum(x > weanMap.x_max * weanMap.res) || ...
                    sum(y > weanMap.y_max * weanMap.res) || ...
                    sum(x < 1) || ...
                    sum(y < 1)
                idx = 1;
            else
                % Convert world location to grid location
                grid_y = ceil(y / 10);
                grid_x = ceil(x / 10);
                % Subtract the maximum map y value from the asked-for y value
                % in order to get values with an origin at the bottom left of
                % the image
                idx = sub2ind(size(weanMap.grid), weanMap.y_max + 1 - grid_y, grid_x);
            end
        end
        
        
        function im = visualizeRayTrace(weanMap, p, x, y)
            colormap(gray);
            im = imagesc(flipud(weanMap.grid));
            hold on;
            
            [py, px] = ind2sub(size(weanMap.grid), p);
            plot(px, py, 'bo');
            
            for i = 1:360
                [~, rx, ry] = weanMap.convertPosition(x(i), y(i));
                plot(rx, ry, 'rx');
            end
            
            set(gca,'ydir','normal');
        end
        
        % Return occupation status of grid, which will be in [0,1] or -1 to
        % indicate unknown. The input is in world (x,y) location
        function occ_status = getMapOcc(weanMap, x, y)
            
            indices = weanMap.convertPosition(x, y);
            occ_status = weanMap.grid(indices);
        end
        
    end
    
end

