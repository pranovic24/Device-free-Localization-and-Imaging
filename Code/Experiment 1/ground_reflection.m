clc; 
close all; 
clear;
load p2
% load pfsl

f = 2.4e9;
c = 3e8;
lambda = c/f;

h_tx = 1.05;
h_rx = 1.05;
G_los = 1;
G_ref = 1;
%d_c = (4*h_tx*h_rx)/lambda;
%R = [0, -1/4, -1/2, -1];
R = [2, 0, -2];

% R = [1 , 1/2, 1/4, 0, -1/4, -1/2, -1];
%R = [1, 1/2, 1/4, 0];
Pt = 19.5;
Dt = 6.6;
Dr = 6.6;
n = 1.6:0.1:2;

% semilogx(axis,pfsl,'g-', 'LineWidth', 2)
% hold on;

for i = R
    Pr_new = [];
    axis = [];
    for j = -350:700
        d = 10^(j/1000);
        axis = [axis, d];
        
        d_los = sqrt(d^2 + (h_tx - h_rx)^2);
        d_ref = sqrt(d^2 + (h_tx + h_rx)^2);
        phi = (2 * pi * (d_ref - d_los))/lambda;

        g_los = sqrt(G_los)/d_los;
        g_ref = (sqrt(G_ref)*exp(-1i*phi))/d_ref;

        Pr = Pt*Dr*Dt*((lambda/(4*pi))^2) * (abs(g_los + (i * g_ref)))^2;
        
        Pr_new =[Pr_new, 10*log10(Pr)];
        
    end
    semilogx(axis,Pr_new,'Linewidth', 2);
    hold on;  

end

% for i = R
%     Pr_new = [];
%     axis = [];
%     for j = -350:700
%         d = 10^(j/1000);
%         axis = [axis, d];
%         
%         d_los = sqrt(d^2 + (1.05 - 1.05)^2);
%         d_ref = sqrt(d^2 + (1.05 + 1.05)^2);
%         phi = (2 * pi * (d_ref - d_los))/lambda;
% 
%         g_los = sqrt(G_los)/d_los;
%         g_ref = (sqrt(G_ref)*exp(-1i*phi))/d_ref;
% 
%         Pr = Pt*Dr*Dt*((lambda/(4*pi))^2) * (abs(g_los + (i * g_ref)))^2;
%         
%         Pr_new =[Pr_new, 10*log10(Pr)];
%         
%     end
%     semilogx(axis,Pr_new,'Linewidth', 2);
%     hold on;  
% 
% end

% for i = n
%     pfsl = [];
%     
%     for j = -350:900
%         d = 10^(j/1000);
% %         Pr_fsl = Pt*Dr*Dt*((lambda/(4*pi*d))^2);
%         Pr_fsl = Pt*Dr*Dt*((lambda/(4*pi))^2)*(1/(d^i));
%         pfsl = [pfsl, 10*log10(Pr_fsl)];
%     end
%     semilogx(axis,pfsl, 'LineWidth', 2)
%     hold on;
% end

% RSSI_mean_1 = [-36.4567,-39.9875,-39.4392,-38.9618,-51.5411,-43.9035,...
%     -44.7942,-48.2283,-54.9007,-63.6124,-54.4137,-51.0139,-48.9644,-58.2452];
% 
% % RSSI_mean_2 = [-45.3927, -59.1587, -47.9839, -51.3561, -53.1640, -62.5011,...
% %     -51.2160, -50.1691, -50.3827, -53.6880, -52.7177, -50.8607, -51.6589, -53.3350];
% 
% RSSI_mean_3 = [-31.3958, -42.9202, -54.5451, -40.9006, -48.6150, -51.9967,...
%     -49.8723, -53.4707, -50.4611, -54.0713, -51.8552, -50.4403, -54.9725, -51.5328];

% RSSI36_mean_1 = [-7.5409, -7.5042, -8.2809, -9.4713, -9.7276, -11.2630, -12.9042...
%     -13.3486, -16.7313, -15.4509, -20.4007, -18.2460] 
    
%     -25.8990, -30.3812];

% RSSI36_mean_2 = [-7.9294, -9.6900, -8.2839, -9.3313, -9.1295, -10.9835, -14.2032...
%     -15.0512, -16.9489, -16.2112, -19.2520, -20.0263] 
    
%     -26.3728, -29.6441];


distances = [0.5,1,1.5,2,2.5,3,3.5,4,4.5,5];
% 
% % Vertical at 1.05
% RSSI_mode_v_1 = [-5, -5, -6, -6, -8, -11, -10, -12, -12, -12];
% 
% RSSI_mode_v_2 = [-5, -4, -6, -6, -8, -10, -10, -10, -11, -13];
% 

RSSI_mode_hz_1 = [-4, -5, -4, -5, -6, -6, -8, -6, -17, -9];

RSSI_mode_hz_2 = [-5, -6, -5, -6, -7, -7, -10, -8, -18, -10];

RSSI_mode_hz_3 = [-5, -6, -6, -6, -7, -7, -11, -8, -19, -10];

RSSI_mode_hz_4 = [-5, -6, -6, -6, -6, -7, -11, -8, -16, -10];

RSSI_mode_hz_5 = [-5, -5, -6, -6, -6, -6, -11, -8, -18, -11];
% 
% 
% 
% 
% % RSSI_mean_hz = [-4.081, -4.3419, -4.5013, -5.0154, -5.0962, -5.3621, -8.0130 ...
% %     -6.331, -16.6139, -9.0190];
% % 
% RSSI_mean_25_1 = [-3.4713, -4.8768, -6.8890, -10.9412, -12.5097, -12.8526, -13.3759, ...
%     -16.4357, -17.3620, -17.5083];
% 
% RSSI_mean_25_2 = [-3.7188, -4.6751, -7.0903, -10.9846, -11.1515, -12.4095, ...
%     -13.0555, -16.5095, -15.7013, -16.3084];
% 
% RSSI_mean_25_3 = [-3.2510, -3.9085, -6.2766, -9.2112, -12.4713, -11.2112, ...
%     -14.1004, -15.4007, -14.8969, -16.0000];
% 
% RSSI_mean_25_4 = [-4.0182, -4.2285, -6.0000, -10.9790, -11.3084, -11.5430, ...
%     -13.7276, -16.1131, -14.1004, -15.5558];
% 
RSSI_mode_5 = [-4, -4, -5, -9, -11, -11, -14, -15, -14, -16];

RSSI_mode_6 = [-5, -4, -6, -10, -12, -11, -15, -16, -14, -17];
% % 
% % 
% % 
% semilogx(distances,RSSI_mean_25_1, 'b-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mean_25_2, 'r-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mean_25_3, 'g-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mean_25_4, 'k-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mode_5, 'c-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mode_6, 'm-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mode_v_1, 'b-o', 'LineWidth', 2);
% hold on;
% semilogx(distances,RSSI_mode_v_2, 'r-o', 'LineWidth', 2);
% hold on;
semilogx(distances, RSSI_mode_hz_1,'b-o', 'LineWidth', 2);
hold on
semilogx(distances, RSSI_mode_hz_2,'r-o', 'LineWidth', 2);
hold on
semilogx(distances, RSSI_mode_hz_3,'g-o', 'LineWidth', 2);
hold on
semilogx(distances, RSSI_mode_hz_4,'c-o', 'LineWidth', 2);
hold on
semilogx(distances, RSSI_mode_hz_5,'k-o', 'LineWidth', 2);
% 

set(gcf, 'color', 'w');
legend('R = 2', 'R = 0', 'R = -2'...
    ,'Trial 1', 'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5', 'Fontsize', 18)
% legend('R = 0 (1.2 m)', 'R = -1 (1.2 m)', 'R = 0 (1.05 m)', 'R = -1 (1.05 m)'...
%     ,'Trial 1 (1.2 m)', 'Trial 2 (1.2 m)', 'Trial 1 (1.05 m)',...
%     'Trial 2 (1.05 m)','Fontsize', 18)
% legend('Theory (R = -1)', 'Theory (R = -1/2)', 'Trial 1', 'Trial 2');
% legend('Free-space path loss', 'Trial 1', 'Trial 2');
% legend('Theory (R = -1)', 'Theory (R = -1/2)', 'FSPL (n = 1.6)', 'FSPL (n = 1.7)',...
%     'FSPL (n = 1.8)', 'FSPL (n = 1.9)', 'FSPL (n = 2)', 'Trial 1', 'Trial 2')
% legend('R = 0', 'R = -1/4', 'R = -1/2', 'R = -1', 'Vertical Case - 1',...
%     'Vertical Case - 2', 'Fontsize', 18)
% legend('R = 0', 'R = -1/4', 'R = -1/2', 'R = -1', 'Trial 1',...
%     'Trial 2', 'Trial 3', 'Trial 4', 'Trial 5', 'Trial 6', 'Fontsize', 18)
% legend('R = 0', 'R = -1/4', 'R = -1/2', 'R = -1', 'Trial 1 (1.2 m)',...
%     'Trial 2 (1.2 m)', 'Trial 1 (1.05 m)', 'Trial 2 (1.05 m)', 'Fontsize', 18)
% legend('R = 1', 'R = 1/2', 'R = 1/4', 'R = 0', 'R = -1/4', 'R = -1/2', ...
%     'R = -1', 'Horizontal Case - 1',...
%     'Horizontal Case - 2', 'Horizontal Case - 3', 'Fontsize', 18)
% title('Two Ray Ground Reflection Model', 'Fontsize', 18);
title('Mode RSSI and Two Ray Ground Reflection Model (Antenna Positioned Hortizontally)'...
    , 'Fontsize', 18);
xlabel('log (Distance (meters))', 'Fontsize', 18);
ylabel('RSSI (dBm)', 'Fontsize', 18)
% legend('Equation(1)', 'Equation(2)')
grid on;


