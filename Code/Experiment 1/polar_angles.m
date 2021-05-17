clear all;
clc; close all;

RSSI_angles = [-16.7037, -10.0903, -9.2953, -5.7051, -4.9636, -4.7100, ...
    -4.8002, -5.5269, -4.8423, -8.1515, -9.7655, -11.5551, -18.2032, ...
    -31.4470, -24.4706, -38.2189, -16.7037];

angles_polar = [0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165,...
    180, 225, 275, 315, 360];

figure(1)
polarplot(angles_polar*(pi/180), abs(RSSI_angles), 'g-o', 'Linewidth', 2);
title('RSSI - ESP32 No.20 (dBm) vs. Angles');
grid on;
% legend('Trial 1', 'Trial 2')
set(gcf, 'color', 'w')