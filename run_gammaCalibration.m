%% Setup 
colorChannel = [1 2 3]; % ggb gray 

colorVals = 0:5:255; % increments of 5 

% colorVals = [1 255]; 
% colorVals = [colorVals 127]; % midgray 

monitorName = 'DenLab-Behav'; % DenLab-EEG

%% Run
luminance = rd_gammaCalibration(colorChannel, colorVals, monitorName);