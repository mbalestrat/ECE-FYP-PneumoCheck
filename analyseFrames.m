function [redTime, greenTime, blueTime, avgR, video] = analyseFrames(capture, regionNumber)
%analyseFrames This module analyses all frames in the given video

i = 1;

  while hasFrame(capture)
        video = readFrame(capture);
        %divide frame into colour components
            videoRed = video(:,:,1);
            videoGreen = video(:,:,2);
            videoBlue = video(:,:,3);
        %20x20 blocks
            divideR = divideIntoBlocks(videoRed, 20);
            divideG = divideIntoBlocks(videoGreen, 20);
            divideB = divideIntoBlocks(videoBlue, 20);
        %average the blocks
            avgR = mean(divideR);
            avgR = mean(avgR);
            %avgG = blockproc(videoGreen,[20 20], @(a) mean(a.data(:)));
            avgG = mean(divideG);
            avgG = mean(avgG);
            avgB = mean(divideB);
            avgB = mean(avgB);
        %select & save ROI value in video frame (default of midpoint chosen)
        % formerly 320
            redTime(i) = avgR(1,1, regionNumber);
            greenTime(i) = avgG(1,1, regionNumber); % avgG(regionY, regionX); 
            blueTime(i) = avgB(1,1, regionNumber);

            %take value of R,G,B layers (add to running total)
            i = i + 1;
  end
end

