clear; clc; close all;

load '../data/log/Data1.mat';
load '../data/trig.mat';
m = WeanMap('../data/map/map_file.mat');

im = zeros(800,800);

% Set initial position of single particle (x, y, theta)
P = [4000, 4000, 0];
% This is the rotation necessary to rotate the laser points into the
% robot's odometry frame
Rotation = pi/2;
Rot = [cos(Rotation), -sin(Rotation); sin(Rotation), cos(Rotation)];

% This is the sigma of the two sensor modalities
odom_sigma = 0.1;
laser_sigma = 0.01;


robot_pts = 5 * [-10 -10; -10, 10; 10 10; 10 0; 0 0; 10 0; 10 -10; -10 -10];

for d = 1:numel(Data)
    D = Data{d};
    
    %% Motion
    % For the first position, we want to look at the laser data but there
    % will be no initial motion
    if d == 1
        xd = D.x;
        yd = D.y;
        thd = D.th;
    end
    
    % Find the difference between the old position and the new position
    % according to odom data.
    dx = (D.x - xd);
    dy = (D.y - yd);
    dth = (D.th - thd);
    
    % Rotate the change in (x,y) by some rotation matrix. this could be
    % done offline. Is this supposed to be constant though? I think so...
    
    R = [cos(Rotation), -sin(Rotation); sin(Rotation), cos(Rotation)];
    rotated_delta = [dx, dy] * R;
    dx = rotated_delta(1);
    dy = rotated_delta(2);
    
    %% Update the particles according to motion model
    
    % Create position updates based on a gaussian distribution of
    % the motion model centered around the difference between the
    % last data point
    gdx = normrnd(dx, odom_sigma);
    gdy = normrnd(dy, odom_sigma);
    gdth = normrnd(dth, odom_sigma);
    
    % Update the particle position
    P = P + [dx, dy, dth];
    
    % Display laser data
    if D.c == 'L'
        % This is the particle laser pose, which is simply offset from the particle
        % odometry pose by the actual measured differences between the
        % odom pose and laser pose at this timestamp
        L_pose = P + ([D.x_l, D.y_l, D.th_l] - [xd, yd, thd]);
        
        % Get the laser range points in (x, y) coordinates, where the robot
        % is pointing to the +y axis of the robot
        % Rotate the laser range points so that they are centered about the
        % +x axis of the robot, rather than the +y axis
        L_points = [D.r' .* Cos', D.r' .* Sin'] * Rot;
        
        
        % Rotation
%         theta = L_pose(3);
%         R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
%         L_points = L_points * R;
        
        
        % Translate the image points to the current laser pose
        % Translation (x, y)
%         L_points(:,1) = L_points(:,1) + L_pose(1);
%         L_points(:,2) = L_points(:,2) + L_pose(2);
        
        clf;
        hold on;
        r_pts = robot_pts;
        plot(r_pts(:,1), r_pts(:,2), 'b');
        plot(L_points(:,1), L_points(:,2), 'rx');
        axis([-2000,2000,-2000,2000]);
        drawnow;
%         m.visualizeRobotAndLaser(P(1), P(2), L_points(:,1), L_points(:,2));
        
    end
    
    
    
    xd = D.x;
    yd = D.y;
    thd = D.th;
    
end
