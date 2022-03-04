%% Setup 
colorChannel = [1 2 3];
% colorVals = 0:5:255; 
colorVals = [1 255]; 
colorVals = [colorVals 127];


%% Run
luminance = rd_gammaCalibration(colorChannel, colorVals);