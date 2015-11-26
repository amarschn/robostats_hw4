clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This will look for all log files in the log folder and will create a
% data.mat file for each log file. The data.mat file will contain a single
% cell array, where each row in the cell array is a struct representing a
% data point (a line from the log file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dirName = '../data/log/';
files = dir(fullfile(dirName, '*.log'));
fileNames = {files.name}';

for i = 1:size(fileNames, 1)
    file = strcat(dirName, fileNames{i});
    fileID = fopen(file);
    % Read each line from the file as a string and store it
    D = textscan(fileID, '%s', 'Delimiter', '\n');
    D = D{1};
    
    Data = cellfun(@readDataString, D, 'UniformOutput', false);
    save(strcat('Data', num2str(i), '.mat'), 'Data');
end

