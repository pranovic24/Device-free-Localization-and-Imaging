clear all;
clc; close all;

% K = 40;
% 
% file = '2.10.txt';
% A = importdata(file);
% RSSI = A.data;
% words = A.textdata;
% 
% %Determining the TX
% device_string = char(words(:,5));
% device = str2num(device_string(:,8:9));
% 
% measure_string = char(words(:,5));
% 
% TX = ~cellfun('isempty', strfind(cellstr(measure_string),'TX'));
% %TXElement = ~cellfun('isempty', strfind(cellstr(measure_string),'Measure4 TX'));
% 
% TXIndex = find(TX == 1);
% RSSIIndex = find(TX == 0);
% 
% 
% for i = 1:length(TXIndex)-1
%     RSSInumber(i) = (TXIndex(i+1)-TXIndex(i))-1;
% end
% 
% RSSInumber = transpose(RSSInumber);
% 
% RSSILength = length(RSSI);
% 
% RSSInumber = [RSSInumber; RSSILength-TXIndex(length(TXIndex))];
% 
% dataset_dB = NaN(length(TXIndex),K);
% 
% for n = 1:length(TXIndex)
%     dataPoints = ((TXIndex(n)+1):(TXIndex(n)+RSSInumber(n)))';
%     dataset_dB(n,device(dataPoints)) = RSSI(dataPoints);
% end
% 
% dataset = 10.^(dataset_dB/10);
% %datapoints = sum(~isnan(dataset_dB))
% 
% RSSI_mean = nanmean(dataset(:, 34:36));
% 
% %RSSI_sd = nanstd(dataset_dB)
% 
% RSSI_meandB = 10*(log(RSSI_mean))/(log(10))

distances = [0.90, 0.95, 0.98, 1.00, 1.02, 1.05, 1.10, 1.90, ...
    1.95, 1.98, 2.00, 2.02, 2.05, 2.10];
distance_fading = [1.00, 2.00];

RSSI_mean_Old = [-46.1032, -53.1102, -51.6016, -45.6756, ...
    -45.9494, -45.7190, -47.2320, -51.7567, -37.3700, -40.4854 ...
    -49.5410, -38.8541, -43.2723, -39.6847];

RSSI_mean_New = [-4.9085, -4.9769, -4.6736, -5.1934, ...
    -4.7790, -5.3084, -5.2293, -6.3084, -6.0835, -5.9616, -6.0393, ...
    -5.9426, -6.5551, -6.1989];

RSSI_Old_fading = [mean(RSSI_mean_Old(:,1:length(RSSI_mean_Old)/2)), ...
    mean(RSSI_mean_Old(:,(length(RSSI_mean_Old)/2)+1:end))];

RSSI_Old_fading_std = [std(RSSI_mean_Old(:,1:length(RSSI_mean_Old)/2)), ...
    std(RSSI_mean_Old(:,(length(RSSI_mean_Old)/2)+1:end))];

RSSI_New_fading = [mean(RSSI_mean_New(:,1:length(RSSI_mean_New)/2)), ...
    mean(RSSI_mean_New(:,(length(RSSI_mean_New)/2)+1:end))];

RSSI_New_fading_std = [std(RSSI_mean_Old(:,1:length(RSSI_mean_Old)/2)), ...
    std(RSSI_mean_Old(:,(length(RSSI_mean_Old)/2)+1:end))];

figure(1);
plot(distances,RSSI_mean_Old, 'r-o', 'LineWidth', 2);
hold on;
plot(distance_fading,RSSI_Old_fading, 'b-o', 'LineWidth', 2);
title('Fading of ESP32 Without Antenna');
xlabel('Distance of Separation (m)');
ylabel('RSSI (dBm)');
legend('Before Fading', 'After Fading')
grid on;
set(gcf,'color','w');

figure(2);
plot(distances,RSSI_mean_New, 'r-o', 'LineWidth', 2);
hold on;
plot(distance_fading,RSSI_New_fading, 'b-o', 'LineWidth', 2);
title('Fading of ESP32 With Antenna');
xlabel('Distance of Separation (m)');
ylabel('RSSI (dBm)');
legend('Before Fading', 'After Fading')
grid on;
set(gcf,'color','w');
