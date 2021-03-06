clear all
close all
clc
tic
%% Global Variables for forward data

x_d = 0.6; % sensor spacing along x direction
y_d = 0.6; % sensor spacing along y direction
nu = 30;  % Permittivity
obj_cent = [2,2];
radius =  0.3; % Object radius

xm = 0:x_d:3; % Room dimension in x
ym = 0:y_d:3; % % Room dimension in y



%%
TxRx1 = [[xm(1,:)', repmat(ym(1),[1,length(xm)])'];...
    [repmat(xm(1,end), [1,length(ym)-1])', ym(1,2:end)']; ...
    [flip(xm(1,1:end-1))', repmat(ym(1,end),[1,length(xm)-1])'];...
    [repmat(xm(1,1), [1,length(ym)-2])', flip(ym(1,2:end-1))']];
save ('TxRx1.mat','TxRx1')
save ('xm.mat','xm')
save ('ym.mat','ym')
save ('radius.mat', 'radius')
save ('nu.mat', 'nu')

c = 3e8;
freq = 2.4e9;                                                              % Carrier Frequency
lambda = c/freq;

ScattF=[];
TotalF=[];
IncF =[];
TxRxpairs=[];
for ii= 1:length(TxRx1(:,1))
    
TxRx11 = [];
Rx_loc=[];

Tx_num = ii;
Source_loc = TxRx1(Tx_num,:);

mmax = 100;

%%
TxRx11 = TxRx1; 
TxRx11(:,3) = [1:length(TxRx1(:,1))]';
TxRx11(Tx_num,:) = []; 
Rx_loc = TxRx11(:,1:2);

TxRxpairs = [TxRxpairs [repmat(Tx_num,[1, length(TxRx1(:,1))-1]); TxRx11(:,3)']];

[pat, patt, h0kRso, pn] = fieldxx(obj_cent/lambda, Source_loc/lambda, radius/lambda, Rx_loc/lambda, nu, mmax);

ScattF(:,ii) = pat;
TotalF(:,ii) = patt;
IncF(:,ii) = (-1i/4*h0kRso);

end


%% Extract Unique links
save ('TxRxpairs.mat','TxRxpairs')
save ('ScattF.mat','ScattF')
save ('TotalF.mat','TotalF')
save ('IncF.mat','IncF')

%% Plot geometry
figure(1)
labels = num2str((1:length(TxRx1))');
pos = [-radius+obj_cent(1) -radius+obj_cent(2) 2*radius 2*radius];
rectangle('Position',pos,'Curvature',[1 1],'FaceColor',[0 0 0], ...
    'LineWidth', 1.5)
hold on;
rectangle('Position', [TxRx1(1,1), TxRx1(1,2),...
    3, 3], 'LineWidth', 1.5);
hold on;
scatter(TxRx1(:,1), TxRx1(:,2), 200,'s','filled', 'r', ...
    'MarkerEdgeColor', 'k'); 
hold on;
text(TxRx1(:,1),TxRx1(:,2),labels,'VerticalAlignment','bottom',...
    'HorizontalAlignment','left', 'Color','b', 'FontSize',18)
hold on;
scatter(obj_cent(1),obj_cent(2), '*', 'MarkerEdgeColor', 'w'); 
%scatter(TxRx1(:,1), TxRx1(:,2), 60,'v','filled'); hold on;
%text(TxRx1(:,1),TxRx1(:,2),labels,'VerticalAlignment','bottom','HorizontalAlignment','left', 'Color','red')
%text(Source_loc(1),Source_loc(2), 'Source', 'VerticalAlignment','top');
name = ['Wi-Fi Nodes Location - Radius of Cylinder ', num2str(radius), ' m'];
title(name, 'FontSize', 18)
xlabel('X (meters)', 'FontSize', 18)
ylabel('Y (meters)', 'FontSize', 18)
axis([-0.5 3.5 -0.5 3.5])
grid on;
set(gcf,'color','w');

% %% Plot Field
% figure(2)
% % plot(y,abs(pat/pn),'r-',y,abs(patt/pn),'.-',y,abs(1i/4*h0kRso)/pn, 'k')
% plot(TxRx11(:,3),abs(pat/pn),'r-',TxRx11(:,3),abs(patt/pn),'.-',TxRx11(:,3),abs(1i/4*h0kRso)/pn, 'k')
% legend('Scattered Field','Total Field', 'Incident Field')
% % 
% % grid
% %% Plot Field
% figure(3)
% plot(TxRx11(:,3)*(x_d/0.02),abs(patt),'.-')
% % legend('Total Field')
% figure(2)
% % % plot(y,abs(pat/pn),'r-',y,abs(patt/pn),'.-',y,abs(1i/4*h0kRso)/pn, 'k')
% plot(1:length(pat),abs(pat),'r-',1:length(pat),abs(patt),'.-',1:length(pat),abs(1i/4*h0kRso), 'k')
% legend('Scattered Field','Total Field', 'Incident Field')
% % % 
% grid on

timeElapsed = toc