function showRegion(regionNumber, avgR, video)
%showRegion This function previews the ROI on the patient

%% Show ROI
% New approach
cursor = mod(regionNumber, length(avgR)); %regionNumber
columns = 640/20;

if cursor == 0
    xPos = 620;
    yPos = 460;
else
    xPos = abs((mod(cursor, columns) * 20)-20);
    yPos = abs((ceil(cursor/columns)* 20)-20);
end

imwrite(video, '03-01.png');
img = imread('03-01.png');
fh = figure;
imshow( img, 'border', 'tight' ); %//show your image

hold on;
rectangle('Position', [xPos yPos 20 20], 'EdgeColor', 'red', 'LineWidth', 2 ); %// draw rectangle on image
frm = getframe( fh ); %// get the image+rectangle

% %% Show Region as Image
% figure();
% pix = cat(3, divideR(:, :, regionNumber),  divideG(:, :, regionNumber),  divideB(:, :, regionNumber));
% %pix = divideR(:, :, regionNumber) +  divideG(:, :, 309) +  divideB(:, :, 309);
% pixR = rescale(pix);
% vidR = video((xPos:xPos+20), (yPos:yPos+20), :);
% image(vidR)
% hold on;
% title('ROI View');


end

