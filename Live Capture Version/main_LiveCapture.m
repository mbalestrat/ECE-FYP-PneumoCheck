clear all;
close all;
clc;

%% Live capture
% cam = webcam(1);
% %cam.Resolution = '1280x960';
% 
% vidWriter = VideoWriter('framesRGB.avi', 'Uncompressed AVI');
% open(vidWriter);
% 
% for index = 1:500
%     % Acquire frame for processing
%     img = snapshot(cam);
%     % timestamp to calculate sample rate;
%     sampTime(index) = datetime('now', 'Format', 'mmss');
%     % Write frame to video
%     writeVideo(vidWriter,img);
% end
% 
% close(vidWriter);
% clear cam
% 
% % calculate sample rate
% dur = sampTime - sampTime(1);
% dt = seconds(dur);
% fs= mean(1./diff(dt));
% 
% % import clip for analysis

capture = VideoReader('framesRGB.avi');
fs = 25;

%% Input Region Number (For Single Region Analysis)
regionNumber = 302;

% Preview ROI 
  frames = read(capture);
  imwrite(frames(:,:,:, 1), fullfile(sprintf('frame.jpg')));
  
prev = imread('frame.jpg');
showRegion(regionNumber, ones(1, 1, 768), prev);

%% Confirm ROI
answer = questdlg('Continue with selected ROI?')
% Handle response
switch answer
    case 'Yes'
        disp([answer ' ROI Confirmed'])
    case 'No'
        disp([answer ' Please select new ROI'])
        return
end

%% Define Global Variables
% Choice of forehead, cheek or background.
counter = 1;
global redTime;
global blueTime;
global greenTime;

%% VIDEO INPUT, COLOUR CHANNEL SEPARATION
% ======================================================================
f = waitbar(0,'Please wait while your estimation is calculated');
pause(.5)

capture = VideoReader('framesRGB.avi');

while i < length(frames(1,1,1,:))
   % for cols = 1:length(regionArray)
    %for k = 1:5 
    %% Analyse frames
    [redTime, greenTime, blueTime, avgR, video] = analyseFrames(capture, regionNumber);

    %% Import Grouth Truth Results
    % Extract Ground Values from Input Data
%     avgGndPulse = mean(gnd_pulse);
%     avgGndSpO2 = mean(gnd_SpO2);

    %% Filtering Stage
    [red, green, blue, redUpper,redLower, blueUpper, blueLower] = filterStageslivecap(redTime, greenTime, blueTime, fs);

    %% PULSE CALCULATION SECTION
    % ======================================================================
    [avgPulse_estimate, pulse_estimates] = pulseCalc(green, fs);

    %% SPO2 CALCULATION SECTION
    % ======================================================================
    [avgSpO2_estimate, SpO2_estimates] = spO2Calc_Newlivecap(green, blue, redUpper,redLower, blueUpper, blueLower);

    %% ERROR CALCULATION
    % ======================================================================
    % % Mean Standard Deviation
    % stErrPulse = std(data) / sqrt( length(data));
    % stErrSpO2 = std(data) / sqrt(length(data));

    % Gross Error Percentage
    %errorPerc_Pulse = abs(((avgPulse_estimate - avgGndPulse)/avgGndPulse)*100);
    %errorPerc_SpO2 = abs(((avgSpO2_estimate - avgGndSpO2)/avgGndSpO2)*100);

    %% DISPLAY ROI
    % ======================================================================
    showRegion(regionNumber, avgR, video);

    %% PLOTTING
    % ======================================================================
    % & Results - stored in Plotting.m

    %% Output Results to File
    %patient(k,:) = [str2double(patientNumber) regionNumber avgPulse_estimate avgSpO2_estimate errorPerc_Pulse errorPerc_SpO2 avgGndPulse avgGndSpO2];
    %calibration(k, :) = [p(1) p(2)];
    %results{allPatients(counter)} = patient;
    %calibrations{allPatients(counter)} = calibration;
    %timeSeriesSpO2(k, :) = [SpO2_estimates];
    %timeSeriesSpO2{allPatients(counter)} = timeSeriesSpO2;
    
    f = waitbar(1,f)
    pause(1)
    end
  %end

%% ESTIMATION OUTPUT
% ======================================================================
h = msgbox(sprintf('Pulse Estimation: %0.2f \n SpO2 Estimation: %0.2f',avgPulse_estimate, avgSpO2_estimate));
th = findall(h, 'Type', 'Text');               
th.FontSize = 12;  

%% PLOT OUTPUT
% ======================================================================
x = 1:length(green);
[greenPeaks, greenLocs] = findpeaks((green), fs, 'Threshold', 5); %formerly 0.001
localMaxg = islocalmax(green);

xblue = 1:length(blue);
[bluePeaks, blueLocs] = findpeaks((blue), fs, 'Threshold', 5); %formerly 0.001
localMaxb = islocalmax(blue);

figure();
subplot(2,1,1)
plot(x./fs, green, 'g', 'LineWidth', 2)
hold on
scatter(x(localMaxg)./fs,green(localMaxg), 'rd','filled')
title('Peaks Used for Pulse Calculation (Green Channel)');
ylabel('Amplitude');
xlim([0 15]);
xlabel('Time (seconds)');

subplot(2,1,2)
plot(xblue./fs, blue, 'LineWidth', 2)
hold on
scatter(xblue(localMaxb)./fs,blue(localMaxb), 'rd','filled')
title('Blue Channel Peaks (SpO2)');
ylabel('Amplitude');
xlim([0 15]);
xlabel('Time (seconds)');
