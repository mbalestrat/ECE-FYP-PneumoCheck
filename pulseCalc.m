function [avgHR_Green, pulseTime] = pulseCalc(green,fs)
%pulseCalc Provides pulse rate estimation

thresh = rms(green)*(0.75);
[greenPeaks, greenLocs] = findpeaks((green), fs, 'MinPeakHeight', thresh); %formerly 0.001
localMax = islocalmax(green);

peakDiffsGreen = diff(greenLocs);
RRIntGreen = (mean(peakDiffsGreen));
avgHR_Green = 60 ./ RRIntGreen;

windowSize = 0.2;
n = length(greenPeaks);
sampRate = 0.04; % sample Rate in seconds
start = 0;

% Calculate end time
stopTime = n * sampRate - 0;

% Window index size
windowIdxSz = windowSize / sampRate;  % !! This must be an integer!
if mod(windowIdxSz,1) ~= 0
    error('Window size divided by sample rate must be an integer')
end
% initialize window index
windIdx = [1 : windowIdxSz];
% Number of indicies to shift window
windShift = 1/sampRate;  % !! This must be an integer
if mod(windShift,1) ~= 0
    error('Window increment divided by sample rate must be an integer')
end
% determine number of loops needed
nLoops = floor((n-start)/windowIdxSz);  %floor() results in skipping leftovers outside of final window
% Loop through your data
nPeaks = nan(nLoops, 1); 
for i = 1:nLoops
    % find peaks within your windowed data
    pks = findpeaks(green(windIdx), fs, 'Threshold', 5);   
    % store the number of peaks
    nPeaks(i) = length(pks); 
    % shift window
    windIdx = windIdx + windShift;   
end

pulseTime = (nPeaks .* 60)./(windowSize);

end

