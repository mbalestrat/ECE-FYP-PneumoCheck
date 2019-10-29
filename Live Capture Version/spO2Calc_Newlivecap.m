function [avgSpO2_estimate, SpO2_estimates, p] = spO2Calc_Newlivecap(red, blue, redUpper,redLower, blueUpper, blueLower)

Lred = length(red);
NFFTr = 2^nextpow2(Lred);
FFTred = fft(red, NFFTr)/Lred;

Lblue = length(blue);
NFFTb = 2^nextpow2(Lblue);
FFTblue = fft(blue, NFFTb)/Lblue;

DC_Red = ifft(FFTred(1));
DC_Blue = ifft(FFTblue(1));

AC_Reds = ifft(FFTred(2:end), 'symmetric');
AC_Blues = ifft(FFTblue(2:end), 'symmetric');

[AC_Redpks, AC_Redlocs] = findpeaks(abs(FFTred(2:end)));
[AC_Bluepks, AC_Bluelocs] = findpeaks(abs(FFTblue(2:end)));

% Calulating Ratio of Oxygenated to Un-Oxygenated Blood
R_Red = abs(FFTred(AC_Redlocs))/abs(FFTred(1));
R_Blue = abs(FFTblue(AC_Bluelocs))/abs(FFTblue(1));

if length(R_Red) > length(R_Blue)
    R = R_Red(1:length(R_Blue))./R_Blue;
end
if length(R_Blue) > length(R_Red)
    R = R_Red./R_Blue(1:length(R_Red));
end
if length(R_Red) == length(R_Blue)
    R = R_Red./R_Blue;
end

%R = (log10((AC_Red + DC_Red)./DC_Red))./(log10((AC_Blue + DC_Blue)./DC_Blue));

% Calibration step
% p = polyfit(R,gnd_SpO2(1:length(R)),1);
% yfit = polyval(p, R);
% SpO2_rawfit = yfit;

% Calculate SpO2 (based on calibration)
SpO2_raw = 96.58 - -0.015*R*100;

inRange = SpO2_raw < 100;
SpO2_estimates = SpO2_raw(inRange);
avgSpO2_estimate = real(mean(SpO2_estimates));

end

