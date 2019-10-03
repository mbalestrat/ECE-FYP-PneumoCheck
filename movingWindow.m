function [stMovingError] = movingWindow(movingAvg)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

stMovingError = std(movingAvg)./sqrt(length(movingAvg));

end

