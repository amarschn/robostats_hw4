clear; clc; close all;

map = WeanMap('../../data/map/map_file.mat');
% data to be used
data = 'robotdata1.log';
% number of particles
num_particles_initial = 20000;
num_particles_final = 500;

% resampling threshold
resample_thresh = 100;
% odometry standard deviation
o_std = 2;
% laser standard deviation
l_std = 0.1;

particleFilter(map, data, num_particles_initial, num_particles_final, resample_thresh, o_std, l_std);