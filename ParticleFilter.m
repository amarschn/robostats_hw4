clear; clc; close all;

% Load data
load '../data/log/Data1.mat';
load '..data/trig.mat';
D = numel(Data);

map = WeanMap('../data/map/map_file.mat');

% This is the sigma of the two sensor modalities
odom_sigma = 0.1;
laser_sigma = 0.01;

% Generate particles
numParticles = 1000;
[P, W] = generateParticlesAndWeights(numParticles, map);

% Go through all data points
for d = 1:D
    
    % For the first position, we want to look at the laser data but there
    % will be no initial motion
    if d == 1
        xd = Data{d}.x;
        yd = Data{d}.y;
        thd = Data{d}.th;
    end
    
    % Find the difference between the old position and the new position
    % according to odom data
    dx = xd - Data{d}.x;
    dy = yd - Data{d}.y;
    dth = thd - Data{d}.th;
    
    % Update the particles according to the data
    for i = 1:numParticles
        
        %% Update the particles according to motion model
        
        % Create position updates based on a gaussian distribution of
        % the motion model centered around the difference between the
        % last data point
        gdx = normrnd(dx, odom_sigma);
        gdy = normrnd(dy, odom_sigma);
        gdth = normrnd(dth, odom_sigma);
        
        
        P(i,:) = P(i,:) + [gdx, gdy, gdth];
        
        %% Update the weights according to the data
        
        % if the particle is running into a wall, then its weight needs to
        % drop to basically nothing and we break out of the for loop
        if map.getMapOcc(P(i,1), P(i,2)) <= 0
            W(i) = 0.001;
            break;
        end
        
        
        % if there is laser data
        if Data{d}.c == 'L'
            % This is the particle laser pose, which is simply offset from the particle
            % odometry pose by the actual measured differences between the
            % odom pose and laser pose at this timestamp
            L = P(i,:) + ([Data{d}.x_l, Data{d}.y_l, Data{d}.th_l] - [xd, yd, thd]);
            
            % Transform the laser points into world points
            
            % Homogeneous coordinates (x,y,1)
            L_points = [Data{d}.r' .* Cos', Data{d}.r' .* Sin', ones(180,1)];
            
            % Rotate and translate all points to world coordinates using
            % the particles (x,y,theta) pose
            
            % Translation
            T = ones(3);
            T(1,3) = L(i,1);
            T(2,3) = L(i,2);
            
            % Rotation
            R = ones(3);
            R(1,1) = cos(L(3));
            R(2,1) = sin(L(3));
            R(1,2) = R(1,1);
            R(2,2) = -R(2,1);
            
            % Translate and then rotate
            L_points = R * T * L_points;
            
            % Get occupancy of every laser world point and sum it up. The
            % larger the sum the larger the weight.
            W(i) = sum(map.getMapOcc(L_points(:,1), L_points(:,2)));
        end
    end
    
    % Calculate the threshold for updating the particles
    threshhold = max(W) / min(W);
    
    
    % Update the particle distribution after a threshold of weight
    % ratio is reached
    if threshold > 100
        % L1 normalize the weights
        W = W/sum(W);
        choices = mnrnd(1, weights, numParticles);
        [~, idx] = max(choices, [], 2);
        P = P(idx,:);
        W(:) = 1; % Set all of the weights to one
        
    end
    
    % Update the old position
    xd = Data{d}.x;
    yd = Data{d}.y;
    thd = Data{d}.th;
end
