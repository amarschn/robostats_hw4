clear; clc; close all;

load '../data/log/Data1.mat';
m = WeanMap('../data/map/map_file.mat');

% Generate the update data
D = genParticleUpdateData(Data);

numInitParticles = 10000;
numFinalParticles = 100;
Particles = {};

% initial range of possible particles
range = linspace(3500,4500,1000);

% Create particle starting points on the map at allowed locations for the
% initial scan
p = 0;
while p < numInitParticles
    %     T = rand(1,2) * 8000;
    T = randsample(range,2);
    A = rand * 2 * pi; % The angle of the particle odometry frame to the world frame
    
    occ = m.getMapOcc(T(1), T(2));
    
    if occ > 0.9
        p = p + 1;
        P = struct();
        P.weight = 1;
        
        P.A = A;
        % The initial robot pose is the translation of the odometry frame
        % to the world frame and the initial robot theta
        P.robot_pose = [T(1), T(2), Data{1}.th + P.A];
        % This is the rotation transform of the particle's odometry frame
        % from the world frame
        P.R = [cos(A), -sin(A);
               sin(A), cos(A)];
        % This is the sigma of the two sensor modalities
        P.odom_sigma = 1;
        P.laser_sigma = 0.01;
        
        Particles{p} = P;
    end
    
end

% Paths = cell(2218,numInitParticles);

i = 1;

for d = 1:numel(D)
    
    [Particles, weight_ratio] = updateParticles(Particles, D{d}, m);
    
    if mod(d,50) == 0 || d == 1
        d
        images(:,:,i) = m.visualizeParticles(Particles, 0);
        i = i + 1;
    end
end





% Video creation
fh = figure(1);
for i = 1:size(images,3)
    imagesc(images(:,:,i));
    drawnow;
    frame = getframe(fh);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);
    if i == 1
        imwrite(A,map,'particle_path', 'gif','LoopCount',Inf,'DelayTime',1);
    else
        imwrite(A,map,'particle_path','gif','WriteMode','append','DelayTime',1);
    end
    
end



