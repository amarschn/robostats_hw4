clear; clc; close all;

load '../data/log/Data1.mat';
m = WeanMap('../data/map/map_file.mat');

% Generate the update data
D = genParticleUpdateData(Data);


P = struct();
P.A = pi/2;
P.weight = 1;
% The initial robot pose is the translation of the odometry frame
% to the world frame and the initial robot theta
P.robot_pose = [0, 0, Data{1}.th + P.A];
% This is the rotation transform of the particle's odometry frame
% from the world frame
P.R = [cos(P.A), -sin(P.A);
    sin(P.A), cos(P.A)];
% This is the sigma of the two sensor modalities
P.odom_sigma = 0;
P.laser_sigma = 0;

Particle = {P};
Path = {};

for d = 1:numel(D)
    [Particle, weight_ratio] = updateParticles(Particle, D{d}, m);
    Path(d) = Particle;
end

pathVisualizer(Path);

