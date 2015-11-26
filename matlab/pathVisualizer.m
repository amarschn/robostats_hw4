function [ ] = pathVisualizer( Data )
    %visualizer visualizes stuff
    % Given a cell array of structured data, it will plot the robot's
    % position and laser data
    
    % These points represent the robot and the laser to be displayed
    robot = 3 * [-10 -10; -10, 10; 10 10; 10 0; 0 0; 10 0; 10 -10; -10 -10];
    laser = 0.2 * robot;
    
    for d = 1:numel(Data)
        D = Data{d};
        
        robot_pose = D.robot_pose;
        if D.type == 'L'
            laser_pose = D.laser_pose;
            laser_points = D.laser_points;
        end
        clf;
        hold on;
        
        % Rotate and then translate the robot visualization box by the robot's angle from the odom frame
        rob_rot = [cos(robot_pose(3)), -sin(robot_pose(3));
            sin(robot_pose(3)), cos(robot_pose(3))];
        rob_tran = repmat([robot_pose(1); robot_pose(2)], 1, length(robot));
        r = rob_rot * robot';
        r = r + rob_tran;
        
        % Rotate and then translate the laser visualization box by the robot's angle from the odom frame
        las_rot = [cos(laser_pose(3)), -sin(laser_pose(3));
            sin(laser_pose(3)), cos(laser_pose(3))];
        las_tran = repmat([laser_pose(1); laser_pose(2)], 1, length(laser));
        l = las_rot * laser';
        l = l + las_tran;
        
        % Plots
        plot(r(1,:), r(2,:), 'b'); % Display the robot
        plot(l(1,:), l(2,:), 'g'); % Display the laser
        plot(laser_points(1,:), laser_points(2,:), 'rx'); % Display the laser points
        
%         legend(strcat('Frame: ', num2str(d)),...
%             strcat('Robot Angle: ', num2str(rad2deg(robot_pose(3)))), ...
%             strcat('Laser Angle: ', num2str(rad2deg(laser_pose(3)))));
        axis([0, 6000, 0, 6000]);
        drawnow;
    end
    
end

