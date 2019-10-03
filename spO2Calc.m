function [avgSpO2_estimate, SpO2_estimates] = spO2Calc(red,blue, redUpper,redLower, blueUpper, blueLower, gnd_SpO2)
%UNTITLED8 Summary of this function goes here
% movRMSdcR = dsp.MovingRMS(50);
% movRMSdcB = dsp.MovingRMS(50);
% movRMSacR = dsp.MovingRMS(50);
% movRMSacB = dsp.MovingRMS(50);

% Red & Blue DC Values
% DC_Red = movRMSdcR(red);
% DC_Blue = movRMSdcB(blue);

DC_Red = mean(red);
DC_Blue = mean(blue);

% Old DC Calculations
% DC_Red = movmean(rms(red), 50);
% DC_Blue = movmean(rms(blue), 50);

AC_Red = movmean(redUpper - DC_Red, 50);
AC_Blue = movmean(blueUpper - DC_Blue, 50);
% 
% % Old AC Calculations
% AC_Red = movmean((redUpper - DC_Red), 50);
% AC_Blue = movmean((blueUpper - DC_Blue), 50);

% Calulating Ratio of Oxygenated to Un-Oxygenated Blood
%R = (AC_Red/DC_Red)./(AC_Blue/DC_Blue);
R = (log10((AC_Red + DC_Red)./DC_Red))./(log10((AC_Blue + DC_Blue)./DC_Blue));

% Calibration step
p = polyfit(R,gnd_SpO2(1:length(R)),1);
yfit = polyval(p, R);
% [r , m , b] = regression(gnd_SpO2(1:length(R)), R*100); %R previously multiplied by 100
% b1 = R/gnd_SpO2(1:length(R));
% k1 = mean(rmoutliers(b*R));
% klength = length(k);
% Rxk = R(1:klength).*k;
%SpO2_raw = abs((b) - m .* R);

% Non-calibration step
SpO2_raw = yfit;
%109 - 25 .* R;

inRange = SpO2_raw < 100;
SpO2_estimates = SpO2_raw(inRange);
avgSpO2_estimate = real(mean(SpO2_estimates));

end

