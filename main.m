clear all;
close all;
clc;

%% Import patients
allPatients = [1 2 3 4 5 6 7 8 9 10];

%% Input Region Number (For Single Region Analysis)
regionNumber = 332;

% Choice of forehead, cheek or background.
regionArray = xlsread('foreheadRegions.xlsx');

counter = 1;
%cols = 1;
k = 1;
global redTime;
global blueTime;
global greenTime;

%% VIDEO INPUT, COLOUR CHANNEL SEPARATION
% ======================================================================

for counter = 1:length(allPatients)
   % for cols = 1:length(regionArray)
        for k = 1:5 
    %% Choose a Patient
        patientNumber = num2str(allPatients(counter));
        fname = strcat('0', num2str(patientNumber), '-01.json');
        data = jsondecode(fileread(fname));

        patientVid = strcat('0', num2str(patientNumber), '-01.avi');
        capture = VideoReader(patientVid);

        regionNumber = regionArray(allPatients(counter), k); % set to constant for testing, should be regionArray(allPatients(counter), k);;

        fs = 25;
        timeTotal = capture.duration*fs;
        timeSteps = 1:timeTotal;
        timeStamps = timeSteps./fs;

        for i = 1:length(data.x_FullPackage)
           gnd_SpO2(i) = data.x_FullPackage(i).Value.o2saturation;
           gnd_pulse(i) = data.x_FullPackage(i).Value.pulseRate;
        end

    %% Analyse frames
    [redTime, greenTime, blueTime, avgR, video] = analyseFrames(capture, regionNumber);

    %% Import Grouth Truth Results
    % Extract Ground Values from Input Data
    avgGndPulse = mean(gnd_pulse);
    avgGndSpO2 = mean(gnd_SpO2);

    %% Filtering Stage
    [red, green, blue, redUpper,redLower, blueUpper, blueLower] = filterStages(redTime, greenTime, blueTime, fs);

    %% PULSE CALCULATION SECTION
    % ======================================================================
    [avgPulse_estimate, pulse_estimates] = pulseCalc(green, fs);

    %% SPO2 CALCULATION SECTION
    % ======================================================================
    [avgSpO2_estimate, SpO2_estimates] = spO2Calc_New(green, blue, redUpper,redLower, blueUpper, blueLower, gnd_SpO2);

    %% ERROR CALCULATION
    % ======================================================================
    % % Mean Standard Deviation
    % stErrPulse = std(data) / sqrt( length(data));
    % stErrSpO2 = std(data) / sqrt(length(data));

    % Gross Error Percentage
    errorPerc_Pulse = abs(((avgPulse_estimate - avgGndPulse)/avgGndPulse)*100);
    errorPerc_SpO2 = abs(((avgSpO2_estimate - avgGndSpO2)/avgGndSpO2)*100);

    %% DISPLAY ROI
    % ======================================================================
    %showRegion(regionNumber, avgR, video);

    %% PLOTTING
    % ======================================================================
    % & Results - stored in Plotting.m

    %% Output Results to File
    patient(k,:) = [str2double(patientNumber) regionNumber avgPulse_estimate avgSpO2_estimate errorPerc_Pulse errorPerc_SpO2 avgGndPulse avgGndSpO2];
    %calibration(k, :) = [p(1) p(2)];
    results{allPatients(counter)} = patient;
    %calibrations{allPatients(counter)} = calibration;
    %timeSeriesSpO2(k, :) = [SpO2_estimates];
    %timeSeriesSpO2{allPatients(counter)} = timeSeriesSpO2;
    end
  %end
end
save('results', 'results');

%% STANDARD ERROR (ENTIRE DATASET)
% ======================================================================

stError_Pulse = standardErrorCalc(allPatients, results, 3);
stError_SpO2 = standardErrorCalc(allPatients, results, 4);
stError_PercErrorPulse = standardErrorCalc(allPatients, results, 5);
stError_PercErrorSpO2 = standardErrorCalc(allPatients, results, 6);

%% T-TEST (To Be Run After Main Test)
% ======================================================================
% fhResults = xlsread('MidsemBreak_SpO2Green.xlsx', 'Forehead');
% cheekResults = xlsread('MidsemBreak_SpO2Green.xlsx', 'Cheek');
% bgResults = xlsread('MidsemBreak_SpO2Green.xlsx', 'Background');
% 
% %Set to 3 for pulse, set to 4 for SpO2
% fhResults = fhResults(1:50, 4);
% cheekResults = cheekResults(1:50, 4);
% bgResults = bgResults(1:50, 4);
% 
% [tTest_forehead, pFhd] = ttest(fhResults, bgResults)
% [tTest_cheek, pChk] = ttest(cheekResults, bgResults)

