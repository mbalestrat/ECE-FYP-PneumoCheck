function [stdError] = standardErrorCalc(allPatients, results, option)
%UNTITLED2 Summary of this function goes here
%   if option = 3, std error of pulse is generated
%   if option = 4, std error of SpO2 is generated

n = length(allPatients) * size(results{1,1}, 1);

for index = 1:length(allPatients)
    u(index) = mean(results{1, index}(:, 3));
end

uFinal = mean(u);

for index = 1:length(allPatients)
    for k = 1:size(results{1,1}, 1)
        current = results{1, index}(k, option);
        xes(index) = current - uFinal;
    end
end

xesFinal = xes.^2;
sig =  sqrt(sum(xesFinal)/(n-1));
stdError = sig/sqrt(n);
end

