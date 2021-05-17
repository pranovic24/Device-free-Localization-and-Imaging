clear all;
clc; close all;

K = 40;

file = '5_0.txt';
A = importdata(file);
RSSI = A.data;
words = A.textdata;

%Determining the TX
device_string = char(words(:,5));
device = str2num(device_string(:,8:9));

measure_string = char(words(:,5));

TX = ~cellfun('isempty', strfind(cellstr(measure_string),'TX'));
%TXElement = ~cellfun('isempty', strfind(cellstr(measure_string),'Measure4 TX'));

TXIndex = find(TX == 1);
RSSIIndex = find(TX == 0);


for i = 1:length(TXIndex)-1
    RSSInumber(i) = (TXIndex(i+1)-TXIndex(i))-1;
end

RSSInumber = transpose(RSSInumber);

RSSILength = length(RSSI);

RSSInumber = [RSSInumber; RSSILength-TXIndex(length(TXIndex))];

dataset_dB = NaN(length(TXIndex),K);

for n = 1:length(TXIndex)
    dataPoints = ((TXIndex(n)+1):(TXIndex(n)+RSSInumber(n)))';
    dataset_dB(n,device(dataPoints)) = RSSI(dataPoints);
end

dataset = 10.^(dataset_dB/10);
%datapoints = sum(~isnan(dataset_dB))

RSSI_mean = nanmean(dataset);

%RSSI_sd = nanstd(dataset_dB)

RSSI_meandB = 10*(log(RSSI_mean))/(log(10))

% RSSI_mean_25 = [-3.8325, -3.7807, -4.3394, -4.8581, -5.3084, -7.0751, ...
%     -7.9790, -8.5168, -8.3135, -11.1515];
% 
% RSSI_mean_35 = [-4.2293, -3.6747, -3.9141, -5.2809, -5.4713, -7.7140, ...
%     -8.4713, -9.000, -9.000, -11.4263];

RSSI_mean_25_2 = [-3.7188, -4.6751, -7.0903, -10.9846, -11.1515, -12.4095, ...
    -13.0555, -16.5095, -15.7013, -16.3084];

RSSI_mean_25_3 = [-3.2510, -3.9085, -6.2766, -9.2112, -12.4713, -11.2112, ...
    -14.1004, -15.4007, -14.8969, -16.0000];

RSSI_mean_25_4 = [-4.0182, -4.2285, -6.0000, -10.9790, -11.3084, -11.5430, ...
    -13.7276, -16.1131, -14.1004, -15.5558];




% RSSI_angles = [-16.7037, -10.0903, -9.2953, -5.7051, -4.9636, -4.7100, ...
%     -4.8002, -5.5269, -4.8423, -8.1515, -9.7655, -11.5551, -18.2032, ...
%     -31.4470, -24.4706, -38.2189];
% 
% % RSSI20_mean_1 = [-3.7005, -3.7749, -4.3227, -4.8885, -5.2032, -7.2630, ...
% %     -9.4713, -9.6405, -10.0820, -11.1515, -12.5716, -13.0600];
% 
% % RSSI_mean1 = [-38.2857,-41.8421,-40.9091,-40.4384,-53.4737,-44.8947,...
% %     -46.3500,-49.3810,-56.3750,-64.7143,-55.2143,-52.2630,-50.4375,-61.9375];
% 
% % RSSI_mean6 = [-36.6250,-40.2632,-39.6957,-39.1429,-51.6190,-43.9524,...
% %     -44.8846,-48.2778,-54.9600,-63.9000,-54.4762,-51.0323,-49.0455,-59.6957];
% 
% % RSSI_mean_1 = [-36.4567,-39.9875,-39.4392,-38.9618,-51.5411,-43.9035,...
% %     -44.7942,-48.2283,-54.9007,-63.6124,-54.4137,-51.0139,-48.9644,-58.2452];
% % 
% % RSSI_sd_new = [1.055,1.5931,1.4904,1.3148,0.8646,0.6690,0.8638,0.6691,...
% %     0.7348,1.9888,0.7496,0.4069,0.8439,2.6187];
% % 
% % RSSI_mean_2 = [-45.3927, -59.1587, -47.9839, -51.3561, -53.1640, -62.5011,...
% %     -51.2160, -50.1691, -50.3827, -53.6880, -52.7177, -50.8607, -51.6589, -53.3350];
% % 
% % RSSI_mean_3 = [-31.3958, -42.9202, -54.5451, -40.9006, -48.6150, -51.9967,...
% %     -49.8723, -53.4707, -50.4611, -54.0713, -51.8552, -50.4403, -54.9725, -51.5328];
% 
% 
% RSSI_sd_1 = [0.5175, 0.8165, 1.3156, 1.2649, 0.7559, 0.8367, 0.8944, ...
%     1.2867, 1.6762, 0.500, 0.5477, 0.5774, 0.6325, 0.5345, 0.8944, 0.9759];
% 
% RSSI_mean_1 = [-36.3975, -37.9253, -60.5355, -56.8562, -37.4392, -44.7370, -47.9234, ...
%     -40.7328, -40.5914, -44.7276, -48.5720, -49.3084, -49.9616, -32.5430, -38.3227, -35.4763];
% 
% RSSI_mean_polar_1 = [-36.3975, -37.9253, -60.5355, -56.8562, -37.4392, -44.7370, -47.9234, ...
%     -40.7328, -40.5914, -44.7276, -48.5720, -49.3084, -49.9616, -32.5430, -38.3227, -35.4763, -36.3975];
% 
% RSSI_mode_1 = [-37, -38, -61, -56, -38, -45, -49, -40, -43, -45, -49, -49, -50 ...
%     -33, -39, -36];
% 
% RSSI_sd_2 = [0.5774, 0.6686, 1.4848, 1.1595, 0.5270, 1.2517, 1.5811, ...
%     1.1877, 1.4975, 0.9718, 1.2536, 0.9189, 0.3892, 0.6504, 0.8233, 0.8006];
% 
% RSSI_mean_2 = [-37.9671, -46.8697, -44.4779, -48.5461, -46.4163, -41.5417, -45.6795, ...
%     -42.2234, -45.1237, -45.1286, -52.5358, -38.1155, -33.1515, -43.5716, -45.6324, -33.7793];
% 
% RSSI_mean_polar_2 = [-37.9671, -46.8697, -44.4779, -48.5461, -46.4163, -41.5417, -45.6795, ...
%     -42.2234, -45.1237, -45.1286, -52.5358, -38.1155, -33.1515, -43.5716, -45.6324, -33.7793, -37.9671];
% 
% RSSI_median_2 = [-38, -47, -45, -49, -46, -42, -46, -42.5, -45, -45, -53, -38 ...
%     -33, -44, -45.5, -34];
% 
% RSSI_mode_2 = [-38, -47, -45, -49, -46, -42, -46, -43, -45, -45, -53, -38 ...
%     -33, -44, -46, -34];
% 
% angles = [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 225, 275, 315];
% 
% angles_polar = [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, 225, 275, 315, 360];
% 
% distances = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6,6.5,7];
% 
% 
% % 
% % plot(distances,RSSI_mean_1, 'r-o', 'LineWidth', 2);
% % hold on;
% % plot(distances,RSSI_mean_2, 'c-o', 'LineWidth', 2);
% % hold on;
% % plot(distances,RSSI_mean_3, 'k-o', 'LineWidth', 2);
% % 
% % title('RSSI - ESP32 No.6 (dBm) vs.Distance of Separation (m)');
% % xlabel('Distance of Separation (m)');
% % ylabel('RSSI (dBm)');
% % grid on;
% % legend('Free-Space', 'Theoretical Two Ray Model', 'Trial 1', 'Trial 2', 'Trial 3')
% % set(gcf,'color','w');
% % 
% % figure(2);
% % semilogx(distances, experiment_data_std, 'r-o', 'LineWidth', 2);
% % title('Standard Deviation of all the Trials');
% % xlabel('Distance of Separation (m)');
% % ylabel('RSSI (dBm)');
% % grid on;
% % set(gcf,'color','w');
% 
% % figure(1)
% % plot(angles, RSSI_mean_1,'r-o', 'LineWidth', 2);
% % hold on
% % plot(angles, RSSI_mean_2,'b-o', 'LineWidth', 2);
% % title('RSSI - ESP32 No.6 (dBm) vs. Angles');
% % xlabel('Angles (degrees)');
% % ylabel('RSSI (dBm)');
% % grid on;
% % legend('Trial 1', 'Trial 2')
% % set(gcf, 'color', 'w')
% % 
% % figure(2)
% % plot(angles,RSSI_sd_1, 'r-o', 'LineWidth', 2);
% % hold on
% % plot(angles,RSSI_sd_2, 'b-o', 'LineWidth', 2);
% % title('Standard Deviation');
% % xlabel('Angles (degrees)');
% % ylabel('RSSI (dBm)');
% % grid on;
% % legend('Trial 1', 'Trial 2')
% % set(gcf, 'color', 'w')
% % 
% % figure(3)
% % plot(angles, RSSI_mean_1,'r-o', 'LineWidth', 2);
% % hold on
% % plot(angles, RSSI_mode_1,'g-o', 'LineWidth', 2);
% % title('RSSI - ESP32 No.6 (dBm) vs. Angles - Trial 1');
% % xlabel('Angles (degrees)');
% % ylabel('RSSI (dBm)');
% % grid on;
% % legend('Mean', 'Mode')
% % set(gcf, 'color', 'w')
% % 
% % figure(4)
% % plot(angles, RSSI_mean_2,'r-o', 'LineWidth', 2);
% % hold on
% % plot(angles, RSSI_mode_2,'g-o', 'LineWidth', 2);
% % title('RSSI - ESP32 No.6 (dBm) vs. Angles - Trial 2');
% % xlabel('Angles (degrees)');
% % ylabel('RSSI (dBm)');
% % grid on;
% % legend('Mean', 'Mode')
% % set(gcf, 'color', 'w')
% % 
% % figure(5)
% % polarplot(angles_polar*(pi/180), abs(RSSI_mean_polar_1), 'r-o', 'Linewidth', 2);
% % hold on
% % polarplot(angles_polar*(pi/180), abs(RSSI_mean_polar_2), 'b-o', 'Linewidth', 2);
% % title('RSSI - ESP32 No.6 (dBm) vs. Angles');
% % grid on;
% % legend('Trial 1', 'Trial 2')
% % set(gcf, 'color', 'w')