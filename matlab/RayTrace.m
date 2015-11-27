clc; clear; close all;

map = WeanMap('../../data/map/map_file.mat');

% Generate the cosine and sine transformations for every angle
Cos = zeros(360,1);
Sin = zeros(360,1);
for i = 1:360
    Cos(i) = cosd(i) * map.res;
    Sin(i) = sind(i) * map.res;
end

ray_trace = zeros(length(map.grid(:)),360,2);

% Flip the map to get the indices correct so the zero position is in the
% bottom left
open_blocks = find(flipud(map.grid) > 0.9);

fprintf('Total Blocks: %d\n', length(open_blocks));
% For each block, we will trace 360 rays
for i = 1:10%length(open_blocks)
    
    if mod(i,100)
        fprintf('Block Number: %d\n',i);
    end
    idx = open_blocks(i);
    
    [r,c] = ind2sub(size(map.grid), idx);
    
    % Get the x and y position of the current map point with the zero
    % position at the bottom left of the map
    x = c * map.res;
    y = r * map.res;
    
    % the rays matrix will store the x and y position for each ray's
    % endpoint
    rays = zeros(2,360);
    
    % for every angle in 1 degree increments
    for th = 1:360
        xr = x;
        yr = y;
        dxr = Cos(th);
        dyr = Sin(th);
        counter = 1;
        while map.getMapOcc(xr, yr) > 0.8 &&...
              xr < map.x_max*map.res && yr < map.y_max*map.res &&...
              xr > 1 && yr > 1 &&...
              counter < 200
          
            xr = xr + dxr;
            yr = yr + dyr;
            counter = counter + 1;
        end
        rays(:,th) = [xr;yr];
    end
    
    ray_trace(idx,:,1) = rays(1,:);
    ray_trace(idx,:,2) = rays(2,:);
end

save('ray_trace.mat', 'ray_trace', '-v7.3');

% p = open_blocks(10);
% x = ray_trace(p,:,1);
% y = ray_trace(p,:,2);
% map.visualizeRayTrace(p,x,y);


