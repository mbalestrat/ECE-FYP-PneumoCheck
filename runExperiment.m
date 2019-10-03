clear all;
close all;
clc;

%% Input Region Number
regionNumber = 757;

%% Choose a Patient
capture = VideoReader('010-01.avi');
fs = 25;
timeTotal = capture.duration*fs;
timeSteps = 1:timeTotal;
timeStamps = timeSteps./fs;

fname = '010-01.json';
data = jsondecode(fileread(fname));

for i = 1:length(data.x_FullPackage)
   gnd_SpO2(i) = data.x_FullPackage(i).Value.o2saturation;
   gnd_pulse(i) = data.x_FullPackage(i).Value.pulseRate;
end

%% Analyse frames
i = 1;

while hasFrame(capture)
    video = readFrame(capture);
    %divide frame into colour components
        videoGreen = video(:,:,2);
    %20x20 blocks
        divideG = divideIntoBlocks(videoGreen, 20);
    %average the blocks
        avgG = mean(divideG);
        avgG = mean(avgG);
    %select & save ROI value in video frame (default of midpoint chosen)
        greenTime(i) = avgG(1,1, regionNumber);
        
    %take value of R,G,B layers (add to running total)
    i = i + 1;
end

%% Bandpass Filtering
greenFilt = bandpass(greenTime, [0.3 2.5], fs);

%% Analysis Step
avgGndPulse = mean(gnd_pulse);
avgGndSpO2 = mean(gnd_SpO2);

[greenPeaks, greenLocs] = findpeaks(greenFilt+ redFilt, fs, 'Threshold', 0.001);
localMins = islocalmin(greenFilt);

peakDiffsGreen = diff(greenLocs);
RRIntGreen = (mean(peakDiffsGreen));
avgHR_Green = 60 / RRIntGreen;

%% Print Results
fprintf('RESULTS:\n==================\n'); 
fprintf('PneumoCheck Calculated Average Pulse: %.2f\n', avgHR_Green); 
fprintf('Ground Truth Average Pulse: %.2f\n', avgGndPulse); 

errorPerc = ((avgHR_Green - avgGndPulse)/avgGndPulse)*100;
fprintf('Percentage Error: %.2f\n', errorPerc); 

