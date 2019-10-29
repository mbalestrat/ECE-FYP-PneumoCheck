myMeanFunction = @(block_struct) mean(block_struct.data);
blockMeans_gnd = blockproc(gnd_SpO2, [1, 9], myMeanFunction);
blockMeans_estimates = blockproc(SpO2_estimates, [1, 2], myMeanFunction);

blockMeans_estimates = round(blockMeans_estimates);

x1 = linspace(0,25,25);
x2 = linspace(0,25,400);
% 
% % Plot
plot(x1, blockMeans_estimates(1:length(x1)),'--bs',...
    'LineWidth',2);
hold on;
plot(x2, blockMeans_gnd(1:length(x2)), 'k','LineWidth',2);
title('SpO2 Estimation vs. Ground Truth Reading (Patient 6 - Forehead)');
legend({'PneumoCheck Estimate','Ground Truth'},'Location','northeast');
xlabel('Time (s)');
ylabel('SpO2 (%)');