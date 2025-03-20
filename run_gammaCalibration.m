%% Setup 
colorChannel = [1 2 3]; % ggb gray 

% colorVals = 0:32:256; % increments of 5 

% colorVals = [1 255]; 
% colorVals = [colorVals 127]; % midgray 
colorVals = 255; 

monitorName = 'DenLab-Behav'; % DenLab-EEG

%% Run
luminance = rd_gammaCalibration(colorChannel, colorVals, monitorName);