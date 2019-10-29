% Script to determine average calibration coefficient based on population
for cnt = 1:6
    patientCalib = double(calibrations{1,cnt});
    patientMean_p1(:, cnt) = mean(patientCalib(:, 1));
    patientMean_p2(:, cnt) = mean(patientCalib(:, 2));
    
    ans_p1 = mean(patientMean_p1);
    ans_p2 = mean(patientMean_p2);
end