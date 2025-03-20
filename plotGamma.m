function plotGamma

%% load gamma data 
dataName = 'gammaCalibration_DenLab-EEG_20220304-1444.mat'; 
% 'gammaCalibration_DenLab-EEG_20220304-1444.mat'
% 'gammaCalibration_DenLab-Behav_20220304-1247.mat'
dataPath = sprintf('%s/data/%s', pwd, dataName); 
data = load(dataPath); % data.colorVals, data.luminance  

%% Plot 
figure
scatter(data.colorVals, data.luminance) 
figTitle = 'gammaCalibration_DenLab-Behav_20250320'; %dataName(1:end-4); 
% title(sprintf('%s', und2space(figTitle))) 
xlabel('Color val')
ylabel('Luminance') 

% format 
box off
grid on
axis square 
xlim([0 256])
xticks([0:32:256])
set(gca,'TickDir','out');
ax = gca;
ax.LineWidth = 1.5;
ax.XColor = 'black';
ax.YColor = 'black';
ax.FontSize = 14;

%% Save figure 
figDir = sprintf('%s/figures', pwd); 
if ~exist(figDir, 'dir')
    mkdir(figDir)
end
saveas(gcf,sprintf('%s/%s.png', figDir, figTitle))
