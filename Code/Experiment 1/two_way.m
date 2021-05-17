clc; close all; 
clear all;



% f = 900e6;
% c = 3e8;
% % lambda = round((c/f), 3);
% lambda = 0.125;

f = 2.4e9;
c = 3e8;
lambda = c/f;

h_tx = 1.2;
h_rx = 1.2;

axis=[];

p2 = [];
pfsl = [];
path_loss = [];


for i = -350:900
    d = 10^(i/1000);
    axis =[axis d]; 
    fspower  = (lambda/(4*pi*d))^2 ;
    power2   = fspower * (2*sin(2*3.1415*h_rx*h_tx/(lambda*d)))^2;
    p2 =[p2, 10*log10(power2)];
    pfsl=[pfsl, 10*log10(fspower)];
end

semilogx(axis,pfsl,'g-', 'LineWidth', 2)
hold on;

semilogx(axis,p2,'b-', 'LineWidth', 2)
hold on;

% semilogx(axis, path_loss, 'r-', 'LineWidth', 2)
% hold on;

title('Two-Ray Ground Reflection Model'); 
xlabel('Distance of Separation (m)');
ylabel('RSSI (dBm)');
grid on;
legend('Free-Space', 'Theoretical Two Ray Model')
set(gcf,'color','w');

save p2
save pfsl