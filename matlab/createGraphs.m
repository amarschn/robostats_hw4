clear; clc; close all;

load '../data/log/Data1.mat';

m = WeanMap('../data/map/map_file.mat');


X = [];
Y = [];
Th = [];
im = zeros(800,800);

for d = 1:numel(Data)
    D = Data{d};
    X = [X; D.x];
    Y = [Y; D.y];
    Th = [Th; D.th];
    
end



subplot(3,1,1);
plot(linspace(1,numel(X), numel(X)), X);
% axis([0,2500,-1000,1000]);
title('X Motion');

subplot(3,1,2);
plot(linspace(1,numel(Y), numel(Y)), Y);
% axis([0,2500,-1000,1000]);
title('Y Motion');

subplot(3,1,3);
plot(linspace(1,numel(Th), numel(Th)), rad2deg(Th), 'rx');
title('Rotation');
