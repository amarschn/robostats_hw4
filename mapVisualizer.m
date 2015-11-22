clear; clc; close all;

load '../data/log/Data1.mat';
m = WeanMap('../data/map/map_file.mat');

O = genOdomData(Data, 0, 0);
W = genWorldData(O, [4000, 4000], 0);

figure('units','normalized','outerposition',[0 0 1 1]);

vid = VideoWriter('test_vid.avi','Uncompressed AVI');
open(vid);

for i = 1:numel(W)
    m.visualizeRobotAndLaser(W{i});
    writeVideo(vid, getframe);
end

close(vid);