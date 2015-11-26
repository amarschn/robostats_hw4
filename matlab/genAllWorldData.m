function [ world_data ] = genAllWorldData( odom_data, T, R )
    %genWorldData generates world-frame based data given odometry-frame based position
    %data and some transform (initial world position and the rotation of
    %the odometry frame
    % O : odometry data, a cell array containing a  struct for each data
    %     point
    % T : translation (x, y) of the odometry frame to the world frame
    % R : rotation (th) of the odometry frame to the world frame
    
    world_data = cell(size(odom_data));
    rot = [cos(R), -sin(R);
        sin(R), cos(R)];
    
    
    % Transform the data in each struct
    for o = 1:numel(odom_data)
        O = odom_data{o};
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
        
        world_data{o} = W;
    end
    
end

