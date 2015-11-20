clear; clc; close all;

load '../data/log/Data1.mat';

m = WeanMap('../data/map/map_file.mat');
m.visualizeRobotPose(1,1);
% hold on;
% for d = 1:numel(Data)
%     plot(Data{d}.x, Data{d}.y, 'x');
% end