clear all;
clc; close all;


%% Indoor 

distances = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5];

RSSI_mean_25_1 = [-3.4713, -4.8768, -6.8890, -10.9412, -12.5097, -12.8526, -13.3759, ...
    -16.4357, -17.3620, -17.5083];

RSSI_mean_25_2 = [-3.7188, -4.6751, -7.0903, -10.9846, -11.1515, -12.4095, ...
    -13.0555, -16.5095, -15.7013, -16.3084];

RSSI_mean_25_3 = [-3.2510, -3.9085, -6.2766, -9.2112, -12.4713, -11.2112, ...
    -14.1004, -15.4007, -14.8969, -16.0000];

RSSI_mean_25_4 = [-4.0182, -4.2285, -6.0000, -10.9790, -11.3084, -11.5430, ...
    -13.7276, -16.1131, -14.1004, -15.5558];

RSSI_mode_5 = [-4, -4, -5, -9, -11, -11, -14, -15, -14, -16];

RSSI_mode_6 = [-5, -4, -6, -10, -12, -11, -15, -16, -14, -17];

% RSSI_mean_hz = [-4.081, -4.3419, -4.5013, -5.0154, -5.0962, -5.3621, -8.0130 ...
%     -6.331, -16.6139, -9.0190];




% RSSI_sd_25_1 = [0.5270, 0.3333, 0.3162, 0.2294, 0.5189, 0.3519, 0.5064, 0.8165, ...
%     0.5016, 0.6048];
% 
% RSSI_sd_25_2 = [0.8018, 0.4830, 0.3162, 0.3780, 0.5189, 0.5123, 0.5149, 0.7559,...
%     0.8321, 0.4924];
% 
% RSSI_sd_25_3 = [0.8876, 0.9428, 0.4830, 0.4385, 0.5774, 0.4385, 0.3333, ...
%     0.5345, 0.4935, 0];
% 
% RSSI_sd_25_4 = [0.8312, 0.6467, 0, 0.4472, 0.5, 0.5345, 0.4629, 0.3536, ...
%     0.3333, 0.9244];
% 
% RSSI_sd_hz = [0.7817, 1.1225, 1.0493, 0.7442, 0.8630, 0.8139, 0.6213, 0.4860 ...
%     0.5728, 0.2956];




% RSSI36_sd_1 = [1.1180, 0.9661, 0.7071, 0.5222, 0.4523, 0.4880, 0.4746...
%     0.5175, 0.7888, 0.7071, 0.5345, 1.6432];
%     
% %     0.3015, 1.7022];
% 
% RSSI36_mean_1 = [-7.5409, -7.5042, -8.2809, -9.4713, -9.7276, -11.2630, -12.9042...
%     -13.3486, -16.7313, -15.4509, -20.4007, -18.2460]; 
%     
% %     -25.8990, -30.3812];

% RSSI_mean_20 = [-3.7005, -3.7749, -4.3227, -4.8885, -5.2032, -7.2630, ...
%     -9.4713, -9.6405, -10.0820, -11.1515];
%     
% %     -12.5716, -13.0600]
% 
% RSSI_mean_25 = [-3.8325, -3.7807, -4.3394, -4.8581, -5.3084, -7.0751, ...
%     -7.9790, -8.5168, -8.3135, -11.1515];
% 
% RSSI_mean_25_1 = [-3.4713, -4.8768, -6.8890, -10.9412, -12.5097, -12.8526, -13.3759, ...
%     -16.4357, -17.3620, -17.5083];
% 
% RSSI_mean_25_2 = [-3.7188, -4.6751, -7.0903, -10.9846, -11.1515, -12.4095, ...
%     -13.0555, -16.5095, -15.7013, -16.3084];

figure(1)
plot(distances, RSSI_mean_25_1,'b-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mean_25_2,'r-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mean_25_3,'g-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mean_25_4,'k-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_5,'c-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_6,'m-o', 'LineWidth', 2);
title('RSSI vs. Distance (Positioned at 1.2 m)', 'FontSize', 18);
xlabel('Distance of Separation (Meters)', 'FontSize', 18);
ylabel('RSSI (dBm)', 'FontSize', 18);
grid on;
legend('Trial 1', 'Trial 2', ...
    'Trial 3', 'Trial 4', 'Trial 5', 'Trial 6')
set(gcf, 'color', 'w')

% figure(2)
% plot(distances, RSSI_sd_25_1,'b-o', 'LineWidth', 2);
% hold on
% plot(distances, RSSI_sd_25_2,'r-o', 'LineWidth', 2);
% hold on
% plot(distances, RSSI_sd_25_3,'g-o', 'LineWidth', 2);
% hold on
% plot(distances, RSSI_sd_25_4,'k-o', 'LineWidth', 2);
% hold on
% plot(distances, RSSI_sd_hz,'c-o', 'LineWidth', 2);
% title('Standard Deviation','FontSize', 18);
% xlabel('Distance of Separation (Meters)', 'FontSize', 18);
% ylabel('RSSI (dBm)', 'FontSize', 18);
% grid on;
% legend('Trial 1', 'Trial 2', ...
%     'Trial 3', 'Trial 4', 'Horizontal Case')
% set(gcf, 'color', 'w')




% 
% % RSSI36_sd_2 = [0.8165, 0.4880, 0.4804, 0.5164, 0.5774, 0.3922, 0.4410...
% %     0.4935, 0.7071, 0.4385, 0.6749, 1.3166];
% %     
% %     0.5477, 0.8254];
% 
% % RSSI36_mean_2 = [-7.9294, -9.6900, -8.2839, -9.3313, -9.1295, -10.9835, -14.2032...
% %     -15.0512, -16.9489, -16.2112, -19.2520, -20.0263]
% %     
% % %     -26.3728, -29.6441];
% % 
% RSSI_sd_25 = [0.7071, 0.9155, 0.8944, 0.5149, 0.4410, 0.4688, 0.5222, 0.5000...
%     0.3015, 0.3892];
% 
% RSSI_sd_20 = [0.9003, 0.4472, 0.7368, 0.7006, 0.5164, 0.2887, 0.4472, 0.5222, ...
%     0.6333, 0.3892];
% 
% %0.6504, 0.2582];
% 
% 
% 
% figure(1)
% plot(distances, RSSI_mean_20,'g-o', 'LineWidth', 2);
% hold on
% plot(distances, RSSI_mean_25_1,'r-o', 'LineWidth', 2);
% hold on
% plot(distances, RSSI_mean_25,'b-o', 'LineWidth', 2);
% title('RSSI - ESP32 No.23 (dBm) - With Antenna vs. Distance');
% xlabel('Distance of Separation (m)');
% ylabel('RSSI (dBm)');
% grid on;
% legend('Trial 1 - Indoor (Day 1)', 'Trial 2 - Indoor (Day 2)', 'Trial - Outdoor')
% set(gcf, 'color', 'w')
% 



%% Outdoor

% save p3