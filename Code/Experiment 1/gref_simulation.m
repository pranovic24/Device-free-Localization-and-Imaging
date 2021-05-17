clc; 
close all; 
clear;

load p2

f = 900e6; %frequency of transmission (Hz)
R = -1; %reflection coefficient
Pt = 1; %Transmitted power in mW
Glos=1; %product of tx,rx antenna patterns in LOS direction
Gref=1; %product of tx,rx antenna patterns in reflection direction
ht = 50; %height of tx antenna (m)
hr = 2; %height of rx antenna (m)
d = 1:0.1:10^5; %separation distance between the tx-rx antennas(m)
L = 1; %no system losses
c = 3 * 10^8;

%Two ray ground reflection model
d_los= sqrt((ht-hr)^2+d.^2);%distance along LOS path
d_ref= sqrt((ht+hr)^2+d.^2);%distance along reflected path
lambda = c/f; %wavelength of the propagating wave
phi = 2*pi*(d_ref-d_los)/lambda;%phase difference between the paths
s = lambda/(4*pi)*(sqrt(Glos)./d_los + R*sqrt(Gref)./d_ref.*exp(1i*phi));
Pr = Pt*abs(s).^2;%received power
Pr_norm = Pr/Pr(1);%normalized received power to start from 0 dBm


semilogx(axis,p2,'b-', 'LineWidth', 2)
hold on;
semilogx(d,10*log10(Pr),'r-','Linewidth', 2); 
hold on; 

title('Two ray ground reflection model');
xlabel('log(Distance (m))');
ylabel('RSSI (dBm)');
% ylim([-140 40]);
legend('Equation(1)', 'Equation(2)')
set(gcf, 'color', 'w');
grid on;