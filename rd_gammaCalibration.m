function luminance = rd_gammaCalibration(colorChannel, colorVals, monitorName)
%
% function luminance = rd_gammaCalibration(colorChannel, colorVals)

if nargin==0
    colorChannel = 1;
end
if nargin<2
    colorVals = 0:255;
end
if nargin<3
    monitorName = []; 
end
nVals = numel(colorVals);
luminance = zeros(nVals,1);

% Make directory to save data
dataDir = sprintf('%s/data',pwd); 
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end
fileName = sprintf('%s/gammaCalibration_%s_%s.mat', dataDir, monitorName, datestr(now,'yyyymmdd-HHMM'));

% ------------------------------------------------------------------------
% Screen setup
% ------------------------------------------------------------------------
% PTB-3 correctly installed and functional? Abort otherwise.
AssertOpenGL;

Screen('Preference', 'VisualDebuglevel', 3);
screenNumber = max(Screen('Screens')) ;

% Open a fullscreen, onscreen window with some color background.
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

[window winRect] = PsychImaging('OpenWindow', screenNumber, 0, [0 0 1400 800]); %128

% Select text size
Screen('TextSize', window, 30);

% ------------------------------------------------------------------------
% Cycle through all vals of one color channel
% ------------------------------------------------------------------------
rgbVal = [0 0 0];
for iVal = 1:nVals
    colorVal = colorVals(iVal);
    rgbVal(colorChannel) = colorVal;

    Screen('FillRect', window, rgbVal);
    
    rgbString = sprintf('[%d  %d  %d]', rgbVal(1), rgbVal(2), rgbVal(3));
    DrawFormattedText(window, rgbString, 0, 0, [255 255 255]);
    Screen('Flip', window);
    
    lumReading = input(sprintf('Luminance for %s:', rgbString));
    
    if ~isempty(lumReading)
        luminance(iVal) = lumReading;
    end
    
    % save on every presentation 
    save(fileName, 'colorChannel', 'colorVals', 'luminance')
end

% Finish up
Screen('CloseAll');

