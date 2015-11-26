function [ P ] = updateParticleWeight( P, D, map )
    %updateParticleWeight : updates a particle's weight according to the occupation map
    
    % Find out if the robot has run into a wall or off the map, if it has
    % then its weight is drastically decreased
    robot_occ = map.getMapOcc(P.robot_pose(1), P.robot_pose(2));
    outOfBounds = (robot_occ < 0.1);
    
    if outOfBounds
        P.weight = P.weight / 1000;
    else
        P.weight = P.weight + robot_occ;
        if D.type == 'L'
            laser_occ = map.getMapOcc(P.laser_points(1,1:45), P.laser_points(2,1:45)) + map.getMapOcc(P.laser_points(1,136:180), P.laser_points(2,136:180));
            P.weight = P.weight + 1/(sum(laser_occ) + 0.1);
        end
    end
end

