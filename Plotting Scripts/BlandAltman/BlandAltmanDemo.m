data = xlsread('foreheadAnalysis_BlandAltman.xlsx');
% 
data1 = data(1:10, 2);
data2 = data(1:10,3); %3 for forehead, 4 for cheek

% data1 = SpO2_estimates(1:109);
% [P,Q] = rat(25/100);
% xnew = resample(blockMeans_gnd,P,Q);
% data2 = xnew;

% BA plot parameters
tit = 'Estimation Accuracy - Forehead'; % figure title
gnames = {};
%{estimates, ground truth values}; % names of groups in data {dimension 1 and 2}
label = {'Ground Truth','PneumoCheck Estimates','SpO2(%)'}; % Names of data sets
corrinfo = {'n','SSE','r2','eq'}; % stats to display of correlation scatter plot
BAinfo = {'RPC(%)','ks'}; % stats to display on Bland-ALtman plot
limits = 'auto'; % how to set the axes limits
if 1 % colors for the data sets may be set as:
	colors = 'br';      % character codes
else
	colors = [0 0 1;... % or RGB triplets
		      1 0 0];
end

% Generate figure with symbols
[cr, fig, statsStruct] = BlandAltman(data1, data2,label, tit, gnames, 'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits,'colors',colors, 'showFitCI',' on', 'data1mode' , 'Truth', 'baStatsMode', 'Gaussian');

% Generate figure with numbers of the data points (patients) and fixed
% Bland-Altman difference data axes limits
%BlandAltman(data1, data2,label,[tit ' (numbers, forced 0 intercept, and fixed BA y-axis limits)'],gnames,'corrInfo',corrinfo,'axesLimits',limits,'colors',colors,'symbols','Num','baYLimMode','square','forceZeroIntercept','on')


% Generate figure with differences presented as percentages and confidence
% intervals on the correlation plot
% BAinfo = {'RPC'};
% BlandAltman(data1, data2,label,[tit ' (show fit confidence intervals and differences as percentages)'],gnames,'diffValueMode','percent', 'showFitCI','on','baInfo',BAinfo)

%
% Display statistical results that were returned from analyses
disp('Statistical results:');
disp(statsStruct);
