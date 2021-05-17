clear all;
clc; close all;

distances = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5];

%% Horizontal

% RSSI_mean_hz = [-4.081, -4.3419, -4.5013, -5.0154, -5.0962, -5.3621, -8.0130 ...
%     -6.331, -16.6139, -9.0190];

RSSI_mode_hz_1 = [-4, -5, -4, -5, -6, -6, -8, -6, -17, -9];

RSSI_mode_hz_2 = [-5, -6, -5, -6, -7, -7, -10, -8, -18, -10];

RSSI_mode_hz_3 = [-5, -6, -6, -6, -7, -7, -11, -8, -19, -10];

RSSI_mode_hz_4 = [-5, -6, -6, -6, -6, -7, -11, -8, -16, -10];

RSSI_mode_hz_5 = [-5, -5, -6, -6, -6, -6, -11, -8, -18, -11];

% Vertical at 1.05
RSSI_mode_v_1 = [-5, -5, -6, -6, -8, -11, -10, -12, -12, -12];

RSSI_mode_v_2 = [-5, -4, -6, -6, -8, -10, -10, -10, -11, -13];

% RSSI_sd_hz = [0.7817, 1.1225, 1.0493, 0.7442, 0.8630, 0.8139, 0.6213, 0.4860 ...
%     0.5728, 0.2956];

figure(1)
plot(distances, RSSI_mode_hz_1,'b-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_hz_2,'r-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_hz_3,'g-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_hz_4,'c-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_hz_5,'k-o', 'LineWidth', 2);
title('RSSI vs. Distance (Antenna Positioned Horizontally)', 'FontSize', 18);
xlabel('Distance of Separation (Meters)', 'FontSize', 18);
ylabel('RSSI (dBm)', 'FontSize', 18);
grid on;
legend('Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5')
set(gcf, 'color', 'w')

figure(2)
plot(distances, RSSI_mode_v_1,'b-o', 'LineWidth', 2);
hold on
plot(distances, RSSI_mode_v_2,'r-o', 'LineWidth', 2);
title('RSSI vs. Distance (Antenna Positioned Vertically at 1.05 m)', 'FontSize', 18);
xlabel('Distance of Separation (Meters)', 'FontSize', 18);
ylabel('RSSI (dBm)', 'FontSize', 18);
grid on;
legend('Trial 1', 'Trial 2')
set(gcf, 'color', 'w')




% figure(2)
% plot(distances, RSSI_sd_hz,'b-o', 'LineWidth', 2);
% hold on
% title('Standard Deviation','FontSize', 18);
% xlabel('Distance of Separation (Meters)', 'FontSize', 18);
% ylabel('RSSI (dBm)', 'FontSize', 18);
% grid on;
% legend('Trial 1')
% set(gcf, 'color', 'w')