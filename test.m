clear; clc; close all;

load '../data/log/Data1.mat';
load '../data/trig.mat';
m = WeanMap('../data/map/map_file.mat');

im = zeros(800,800);

% Set initial position of single particle (x, y, theta)
P = [4000, 4000, pi/1.7];

% This is the sigma of the two sensor modalities
odom_sigma = 0.1;
laser_sigma = 0.01;

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
    dx = (xd - D.x);
    dy = (yd - D.y);
    dth = (thd - D.th);
    
    % Rotate the change in (x,y) by some rotation matrix. this could be
    % done offline. Is this supposed to be constant though? I think so...
    theta = pi/1.7;
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
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
    P = P + [gdx, gdy, gdth];

    % Display laser data
    if D.c == 'L'
        % This is the particle laser pose, which is simply offset from the particle
        % odometry pose by the actual measured differences between the
        % odom pose and laser pose at this timestamp
        L_pose = P + ([D.x_l, D.y_l, D.th_l] - [xd, yd, thd]);
        
        % Get the laser range points, and fit them to the image size
        L_points = [D.r' .* Cos', D.r' .* Sin'];
        
        % Rotation
        theta = L_pose(3);
        R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
        L_points = L_points * R;
        
        
        % Translate and rotate the image points to the current laser pose
        % Translation (x, y)
        L_points(:,1) = L_points(:,1) + L_pose(1);
        L_points(:,2) = L_points(:,2) + L_pose(2);
        
        
        % Scale points
        L_points = ceil(round(L_points/10));
        L_points(L_points < 1) = 1;
        L_points(L_points > 800) = 800;
        
        % Set the coordinates of the image so we can see them
        idx = sub2ind(size(im), L_points(:,2), L_points(:,1));
        
        %         L_pose = round(L_pose(1:2)/10);
        %         idx = sub2ind(size(im), L_pose(2), L_pose(1));
        %
        %         im(idx) = 1;
        %         imshow(im);
        %         im(idx) = 0;
        m.visualizeRobotPose(P(2), P(1));
    end
    
    
    
    xd = D.x;
    yd = D.y;
    thd = D.th;
    
end