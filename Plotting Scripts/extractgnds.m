for i = 1:10
    %% Choose a Patient
  
        fname = strcat('0', num2str(i), '-01.json');
        data = jsondecode(fileread(fname));
        
        for k = 1:length(data.x_FullPackage)
           gnd_SpO2(k) = data.x_FullPackage(k).Value.o2saturation;
           gnd_pulse(k) = data.x_FullPackage(k).Value.pulseRate;
        end
        
    avgGndPulse(i) = mean(gnd_pulse);
    avgGndSpO2(i) = mean(gnd_SpO2);
end
