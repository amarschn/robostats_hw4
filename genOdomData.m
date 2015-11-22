function [ odom_data ] = genOdomData( Data, noise, display )
    %odomFramePose This function returns the robot pose and the laser
    %points in the odometry frame (robot starts at (0,0) in the odometry
    %frame.
    % Output
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % odom_data : this is a cell array containing a struct for each data
    %             point. Each struct will contain the robot pose, and
    %             potentially the laser pose and points representing the
    %             laser ranges.
    
    % Load the stored trig values
    load '../data/trig.mat';
    
    if display  
        vid = VideoWriter('odom_vid.avi','Uncompressed AVI');
        open(vid);
        
    end
    
    % This is the sigma of the two sensor modalities
    odom_sigma = 0.1;
    laser_sigma = 0.01;
    
    % This will contain the robot pose and laser points
    odom_data = cell(size(Data));
    robot_pose = zeros(1,3); % initialize at 0 pose always
    
    % These points represent the robot and the laser to be displayed
    robot = 3 * [-10 -10; -10, 10; 10 10; 10 0; 0 0; 10 0; 10 -10; -10 -10];
    laser = 0.2 * robot;
    
    for d = 1:numel(Data)
        D = Data{d};
        O = struct();
        O.type = D.c;
        
        %% Update the robot pose for every data point
        % If this is the first piece of data, then the change in pose is 0
        if d == 1
            x_init = D.x;
            y_init = D.y;
        end
        
        % Find the difference between the old position and the new position
        % according to odom data. If we want noise then we use the normrnd
        % function
        if noise
            x = normrnd((D.x - x_init), odom_sigma);
            y = normrnd((D.y - y_init), odom_sigma);
            th = normrnd((D.th), odom_sigma);
        else
            x = (D.x - x_init);
            y = (D.y - y_init);
            th = D.th;
        end
        
        % Update the robots pose
        robot_pose = [x, y, th];
        % Store the robots pose
        O.robot_pose = robot_pose;
        
        %% Store the laser pose and points for every laser data point
        if D.c == 'L'
            % Find the difference between the stored robot pose and laser
            % pose
            diff = ([D.x_l, D.y_l, D.th_l] - [D.x, D.y, D.th]);
            % Add the difference to the robot pose in the odom frame in
            % order to get the laser pose in the odom frame
            laser_pose = robot_pose + diff;
            
            % Store the laser pose
            O.laser_pose = laser_pose;
            
            % Calculate the laser points about the y+ axis
            laser_points = [D.r' .* Cos', D.r' .* Sin'];
            
            % Rotate the laser points by -90 deg so that they are centered
            % about the x+ axis
            rot = [cos(-pi/2), -sin(-pi/2);sin(-pi/2), cos(-pi/2)];
            laser_points = (rot * laser_points')';
            
            % Rotate the laser points
            las_rot = [cos(laser_pose(3)), -sin(laser_pose(3));
                       sin(laser_pose(3)), cos(laser_pose(3))];
            laser_points = las_rot * laser_points';
            
            % Add the pose of the laser to the laser points
            p1 = laser_pose(1) * ones(1, length(laser_points));
            p2 = laser_pose(2) * ones(1,length(laser_points));
            laser_points = laser_points + [p1; p2];

            % Store the laser points
            O.laser_points = laser_points;
            
        end
        
        
        %% Add data struct to the cell array
        odom_data{d} = O;
        
        
        
        % Now get to displaying the data
        if display
            clf;
            hold on;
            
            % Rotate and then translate the robot visualization box by the robot's angle from the odom frame
            rob_rot = [cos(robot_pose(3)), -sin(robot_pose(3));
                       sin(robot_pose(3)), cos(robot_pose(3))];
            rob_tran = repmat([robot_pose(1); robot_pose(2)], 1, length(robot));
            r = rob_rot * robot';
            r = r + rob_tran;
            
            % Rotate and then translate the laser visualization box by the robot's angle from the odom frame
            las_tran = repmat([laser_pose(1); laser_pose(2)], 1, length(laser));
            l = las_rot * laser';
            l = l + las_tran;
           
            % Plots
            plot(r(1,:), r(2,:), 'b'); % Display the robot
            plot(l(1,:), l(2,:), 'g'); % Display the laser
            plot(laser_points(1,:), laser_points(2,:), 'rx'); % Display the laser points
            
            legend(strcat('Frame: ', num2str(d)),...
                   strcat('Robot Angle: ', num2str(rad2deg(robot_pose(3)))), ...
                   strcat('Laser Angle: ', num2str(rad2deg(laser_pose(3)))));
            axis([-2000, 2000, -2000, 2000]);
            drawnow;
            writeVideo(vid, getframe);
        end
    end
    
    if display
        close(vid);
    end
    
end

