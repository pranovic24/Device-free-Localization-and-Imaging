clc; close all; 
clear all;

lambda = 0.3; 
ht100=100;
ht30=30;
ht2=2;
hr=2;

axis=[];
p100=[];
p30=[];
p2=[];
pfsl=[];



for i = 1000:5000
    d = 10^(i/1000);
    axis =[axis d]; 
    fspower  = (lambda/(4*pi*d))^2 ;
    power2   = fspower * (2*sin(2*pi*hr*ht2/(lambda*d)))^2;
    power100   = fspower * (2*sin(2*pi*hr*ht100/(lambda*d)))^2;
    power30   = fspower * (2*sin(2*3.1415*hr*ht30/(lambda*d)))^2;
    
    p100 = [p100, 10*log10(power100)];
    p30 = [p30, 10*log10(power30)];
    p2 =[p2, 10*log10(power2)];
    pfsl=[pfsl, 10*log10(fspower)];
end

semilogx(axis,pfsl,'y-', 'LineWidth', 2)
hold on;

semilogx(axis,p100,'g-', 'LineWidth', 2)
hold on;

semilogx(axis,p30,'b-', 'LineWidth', 2)
hold on;

semilogx(axis,p2,'r-', 'LineWidth', 2)
hold on;

% semilogx(axis, path_loss, 'r-', 'LineWidth', 2)
% hold on;

title('Two-Ray Ground Reflection Model'); 
xlabel('log(Distance (m))');
ylabel('RSSI (dBm)');
grid on;
legend('Free-Space', '100m', '30m', '2m')
set(gcf,'color','w');

