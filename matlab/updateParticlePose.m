function [ P ] = updateParticlePose( P, D )
    %updateParticlePose : updates the pose and laser points of the particle
    % according to the data in D, which is in the odometry frame
    
    P.type = D.type;
    
    
    % Update the position of the particle according to it's motion model
    dp = normrnd(D.dp, P.odom_sigma);
    P.robot_pose(1:2) = P.robot_pose(1:2) + (P.R * dp(1:2)')';
    P.robot_pose(3) = P.robot_pose(3) + dp(3);
    
    % Update the position of the laser and it's points
    if D.type == 'L'
        P.laser_pose = P.robot_pose + D.dp_l;
        lp = normrnd(D.lp, P.laser_sigma);
        
        % rotate the laser points by the laser angle
        las_rot = [cos(P.laser_pose(3)), -sin(P.laser_pose(3));
            sin(P.laser_pose(3)), cos(P.laser_pose(3))];
        lp = las_rot * lp';
        
        % Add the pose of the laser to the laser points
        lp = lp + [P.laser_pose(1) * ones(1,length(lp)); P.laser_pose(2) * ones(1,length(lp))];
        
        % Store the laser points
        P.laser_points = lp;
    end
    
end

