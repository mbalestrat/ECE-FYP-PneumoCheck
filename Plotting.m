%x = 1:length(green);
    % xblue = 1:length(blue);
    % xred =  1:length(red);
    % 
    % % Plot Peak Analysis
    % figure();
    % subplot(3,1,1)
    % plot(x./fs, green)
    % hold on
    % scatter(x(localMax)./fs,green(localMax), 'r')
    % title('Peaks Used for Pulse Calculation (Green Channel)');
    % ylabel('Amplitude');
    % xlim([0 65]);
    % xlabel('Time (seconds)');
    % 
    % subplot(3,1,2)
    % plot(xblue./fs, blue)
    % title('Blue Channel');
    % ylabel('Amplitude');
    % xlim([0 65]);
    % xlabel('Time (seconds)');
    % 
    % subplot(3,1,3)
    % plot(xred./fs, red)
    % title('Red Channel');
    % ylabel('Amplitude');
    % xlim([0 65]);
    % xlabel('Time (seconds)');
    % 
    % % Remove Outliers
    % R_plot = rmoutliers(R);
    % gndSpO2_plot = rmoutliers(gndSpO2_dwnsample);
    % 
    % % Plot Linear Regression
    % % scatter(R_plot(1:length(gndSpO2_plot)), gndSpO2_plot)
    % % hold on
    % % plot(R_plot(1:klength), k)
    % % xlabel('R')
    % % ylabel('SpO2')
    % % title('Linear Regression - SpO2 vs. R')
    % % grid on
    % 

    %% PRINT RESULT TO CONSOLE
    % ======================================================================
    % fprintf('REGION %d PULSE RESULTS:\n==================\n', regionNumber); 
    % fprintf('PneumoCheck Calculated Average Pulse: %.2f\n', avgPulse_estimate); 
    % fprintf('Ground Truth Average Pulse: %.2f\n', avgGndPulse); 
    % 
    % fprintf('Percentage Error: %.2f\n\n', abs(errorPerc_Pulse)); 
    % 
    % fprintf('REGION %d SPO2 RESULTS:\n==================\n', regionNumber); 
    % fprintf('PneumoCheck Calculated Average SpO2: %.2f\n', avgSpO2_estimate); 
    % fprintf('Ground Truth Average SpO2: %.2f\n', avgGndSpO2); 
    % 
    % 
    % fprintf('Percentage Error: %.2f\n', abs(errorPerc_SpO2)); 