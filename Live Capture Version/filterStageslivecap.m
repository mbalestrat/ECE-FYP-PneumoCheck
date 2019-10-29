function [red, green, blue, redUpper,redLower, blueUpper, blueLower ] = filterStageslivecap(redTime,greenTime, blueTime, fs)
%filterStages Applies all filters to each colour channel

% Initial Bandpass Filtering
greenFilt = bandpass(greenTime, [0.3 2.5], fs); %formerly [0.3  2.5]
redFilt = bandpass(redTime, [0.3 2.5], fs); %formerly [0.3  2.5]
blueFilt = bandpass(blueTime, [0.3 2.5], fs); %formerly [0.3  2.5]

% Smooth the signals
green = greenFilt - smoothdata(greenFilt);
blue = blueFilt - smoothdata(blueFilt);
red = redFilt - smoothdata(redFilt);

% Secondary Bandpass Filter
[B, A] = butter(9, [0.05 0.15] ,'bandpass');
green = filter(B, A, green);
blue = filter(B, A, blue);
red = filter(B, A, red);

%Calculate envelopes
[greenUpper, greenLower] = envelope(green);
[redUpper,redLower] = envelope(red); %formerly redFilt
[blueUpper,blueLower] = envelope(blue); % see above

greenHi = mean(greenUpper);
blueHi = mean(blueUpper);
redHi = mean(redUpper);
greenLo = mean(greenLower);
blueLo = mean(blueLower);
redLo = mean(redLower);

% Detrending Step
ddtGreen = detrend(green);
ddtBlue = detrend(blue);
ddtRed = detrend(red);

igrn =  ddtGreen > greenHi;
iblu = ddtBlue > blueHi;
ired = ddtRed > redHi;

Dgnew = green(~igrn);
Dbnew = blue(~iblu);
Drnew = red(~ired);

ig = Dgnew < greenLo;
ib = Dbnew < blueLo;
ir = Drnew < redLo;

grnDtrended = Dgnew(~ig);
bluDtrended = Dbnew(~ib);
redDtrended = Drnew(~ir);

%Make all inputs same length
green = green(1:500);
red = red(1:500);
blue = blue(1:500);

green = bandy(grnDtrended);
blue = bandyBlue(bluDtrended);
red = bandyRed(redDtrended);
end

