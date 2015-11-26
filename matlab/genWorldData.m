function [ W ] = genWorldData( O, T, R )
    %genWorldData : provides a world point from the odometry point given
    %the translation and rotation

    rot = [cos(R), -sin(R);
        sin(R), cos(R)];
    
    W = struct();
    W.type = O.type;
    W.robot_pose = O.robot_pose;
    W.robot_pose(1:2) = (rot * W.robot_pose(1:2)')';
    W.robot_pose = W.robot_pose + [T, R];
    
    
    if O.type == 'L'
        W.laser_pose = O.laser_pose;
        W.laser_pose(1:2) = (rot * W.laser_pose(1:2)')';
        W.laser_pose = W.laser_pose  + [T, R];
        W.laser_points = rot * O.laser_points;
        
        x = repmat(T(1), 1, length(W.laser_points));
        y = repmat(T(2), 1, length(W.laser_points));
        W.laser_points = W.laser_points + [x; y];
    end
    
end

