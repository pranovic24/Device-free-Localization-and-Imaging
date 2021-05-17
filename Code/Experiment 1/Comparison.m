clear all;
clc; close all;

lambda = 0.125; 

h_tx = 1.2;
h_rx = 1.2;

axis=[];

p2 = [];
pfsl = [];
path_loss = [];


% K = 6;
% 
% file = '7.0m.txt';
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
% RSSI_mean = nanmean(dataset);
% 
% %RSSI_sd = nanstd(dataset_dB)
% 
% RSSI_meandB = 10*(log(RSSI_mean))/(log(10))

RSSI_mean_1 = [-36.4567,-39.9875,-39.4392,-38.9618,-51.5411,-43.9035,...
    -44.7942,-48.2283,-54.9007,-63.6124,-54.4137,-51.0139,-48.9644,-58.2452];

RSSI_mean_2 = [-45.3927, -59.1587, -47.9839, -51.3561, -53.1640, -62.5011,...
    -51.2160, -50.1691, -50.3827, -53.6880, -52.7177, -50.8607, -51.6589, -53.3350];

RSSI_mean_3 = [-31.3958, -42.9202, -54.5451, -40.9006, -48.6150, -51.9967,...
    -49.8723, -53.4707, -50.4611, -54.0713, -51.8552, -50.4403, -54.9725, -51.5328];

distances = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7];

for i = -300:850
    d = 10^(i/1000);
    axis =[axis d]; 
    fspower  = (lambda^2)/(4*pi*d)^2 ;
    power2   = fspower * 4 *(sin(2*pi*h_rx*h_tx/(lambda*d)))^2;
%     pl = -19.5 - 10*log10(power2);
%     path_loss = [path_loss, pl];
    p2 =[p2, 10*log10(power2)];
    pfsl=[pfsl, 10*log10(fspower)];
end

semilogx(axis,pfsl,'g-', 'LineWidth', 2)
hold on;

semilogx(axis,p2,'b-', 'LineWidth', 2)
hold on;

semilogx(distances,RSSI_mean_1, 'r-o', 'LineWidth', 2);
hold on;
semilogx(distances,RSSI_mean_2, 'c-o', 'LineWidth', 2);
hold on;
semilogx(distances,RSSI_mean_3, 'k-o', 'LineWidth', 2);

title('RSSI - ESP32 No.6 (dBm) vs.Distance of Separation (m)');
xlabel('log(Distance of Separation (m))');
ylabel('RSSI (dBm)');
grid on;
legend('Free-Space', 'Theoretical Two Ray Model', 'Trial 1', 'Trial 2', 'Trial 3')
set(gcf,'color','w');



