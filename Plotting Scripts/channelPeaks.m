x = 1:length(green);
xblue = 1:length(blue);
[greenPeaks, greenLocs] = findpeaks((green), fs, 'Threshold', 5); %formerly 0.001
[bluePeaks, blueLocs] = findpeaks((blue), fs, 'Threshold', 5);
localMax = islocalmax(green(1:length(x)));
localMaxBlue = islocalmax(blue(1:length(xblue)));

figure();
subplot(2,1,1)
sgtitle('Excerpt of Function Output from 1-20s');
plot(x./fs, green(1:length(x)), 'g', 'LineWidth', 1.5)
hold on
scatter(x(localMax)./fs,green(localMax), 'rx')
title('Peaks Used for Pulse & Oxygenated hemoglobin (HbO2) Estimation (Green Channel)');
ylabel('Amplitude');
xlim([1 20]);
xlabel('Time (seconds)');

subplot(2,1,2)
plot(xblue./fs, blue(1:length(xblue)), 'LineWidth', 1.5)
hold on
scatter(x(localMaxBlue)./fs,blue(localMaxBlue), 'rx')
title('Peaks Used for Deoxygenated hemoglobin (Hb) Estimation (Blue Channel)');
ylabel('Amplitude');
xlim([1 20]);
xlabel('Time (seconds)');