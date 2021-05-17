clear all; close all; clc
tic
%% Room Dimension, grid resolution and display the environment
load ('TxRxpairs.mat','TxRxpairs')
load ('TxRx1.mat','TxRx1')
load ('xm.mat','xm')
load ('ym.mat','ym')
load ('radius.mat', 'radius')
load ('nu.mat', 'nu')
TxRx = TxRx1; RoomLength = max(xm); RoomWidth = max(ym);
%% Global Paramters
gridXres = 0.05;  % Resolution of grid
gridYres = gridXres;
invM = 5;      % invM = 0: lsq;    invM = 1: non-neg lsq;        invM = 5: Regularization

clear opts
opts.mu = 2^3;   % 2^1 to 2^14
opts.beta = 2^8; % 2^1 to 2^14
opts.maxit = 200; % 10 to 3000
%%
opts.tol = 1E-3;
opts.TVnorm = 1;
opts.nonneg = true;

pran = 1;
SubG = 0;                 % SubG = 1: Apply Subgrid method; SubG = 0: Don't apply Subgrid method
fM = 0;                   % fM=0: Estimate new F, fM=1: load previous result
UL =0;                    % Unique links = 1
alph=5e-3;
nopts_C = 200;
ReqCard = 4;
[gridvec, gridcent] = ReturnGridCentre(TxRx, gridXres, gridYres, RoomWidth, RoomLength);
clear gridvec

%% Constants
C = 1;                                                                    % Correction factor
c = 3e8;
freq = 2.4e9;                                                              % Carrier Frequency
lambda = c/freq;
Gt = 1;
Gr = 1;
muo = 1.2567e-6;                                                           % Free Space Permeability (Air) 
epo = 8.85e-12;                                                            % Free Space permittivity
Gridarea = gridXres*gridYres;                                              % Area of one grid
Iimp = 120*pi;                                                             % intrinsic impedance 
ko = sqrt(((2*pi*freq)^2)*muo*epo);                                              % Wave Number of Free Space

%% Total Received power (scattering+Incident)
load ('TotalF.mat','TotalF')
load ('IncF.mat','IncF')
if pran ==1
    Prx_pran = ((abs(TotalF(:,:))).^2)*(lambda*lambda)/(4*pi*Iimp);
Prx_pran = 10*log10(Prx_pran/1e-3);          %dBm
end
TotalF=TotalF(:);
IncF=IncF(:);

%% Need Unique Links??
if UL ==1
    count=0;
TxRxpairsUL= TxRxpairs;
le = length(TxRx(:,1));
for iii=2:le
    TxRxpairsUL(:, 1 + (iii-1)*(le-1): count+ 1 + (iii-1)*(le-1)) = NaN;
%     ScattF1(1 + (iii-1)*(le-1): count+ 1 + (iii-1)*(le-1),1) = NaN;
    TotalF(1 + (iii-1)*(le-1): count+ 1 + (iii-1)*(le-1),1) = NaN;
    IncF(1 + (iii-1)*(le-1): count+ 1 + (iii-1)*(le-1),1) = NaN;
    count = count+1;
end

% ScattF1= ScattF1(~isnan(ScattF1));
TotalF= TotalF(~isnan(TotalF));
IncF= IncF(~isnan(IncF));
TTT1 = TxRxpairsUL(1,:);
TTT2 =  TxRxpairsUL(2,:);
TTT1= TTT1(~isnan(TTT1));
TTT2= TTT2(~isnan(TTT2));
TxRxpairsUL = [TTT1;TTT2];
TxRxpairs=[];
TxRxpairs=TxRxpairsUL;
clear TxRxpairsUL
clear TTT1
clear TTT12
end

%% Calculate scattered Power in dBm
Prx_forw = ((abs(TotalF(:))).^2)*(lambda*lambda)/(4*pi*Iimp);
Prx = 10*log10(Prx_forw/1e-3);          %dBm
PincTx2Rx_air_dBm = 10*log10((((abs(IncF(:))).^2)*(lambda*lambda)/(4*pi*Iimp))/1e-3);
Pryt = ((Prx-PincTx2Rx_air_dBm)/(10*log10(exp(-2))));

%% LOS
if SubG == 0
    SemiMin = gridXres/2;
    parfor i = 1:length(TxRxpairs(1,:))   
        TxRxDist = norm(TxRx(TxRxpairs(1,i),:) - TxRx(TxRxpairs(2,i),:));                % Distance b/w Tx and Rx
        Thresh = 2*sqrt(TxRxDist*TxRxDist/4 + SemiMin*SemiMin);

        RxRnDist = vecnorm((TxRx(TxRxpairs(2,i),:) - gridcent(:,:)')');                 % Distance b/w Rx and Grid center
        TxRnDist = vecnorm((TxRx(TxRxpairs(1,i),:) - gridcent(:,:)')');                 % Distance b/w Tx and Grid center   
        foc_sum = RxRnDist+TxRnDist;
        foc_sum(foc_sum > Thresh) = 0;
        foc_sum(foc_sum ~= 0) = 1;
        F(i,:) = foc_sum;        
    end
end
% 
% 

%% Find Green's Function and F with Subgrid calculations 
if SubG == 1
    if fM ==0
subgridRes = round(lambda/10, 2);
subgridResC = subgridRes/2;
Gridarea = subgridRes*subgridRes;                                              % Area of one grid

for i = 1:length(TxRxpairs(1,:))  
    
    TxRxDist = norm(TxRx(TxRxpairs(1,i),:) - TxRx(TxRxpairs(2,i),:));                % Distance b/w Tx and Rx    
    EincTx2Rx_air = (-1i/4)*(besselj(0,ko*TxRxDist) - 1i * bessely(0,ko*TxRxDist));%(exp(1i*ko*TxRxDist)*sqrt(Iimp*PTx_W*(C/(4*pi*(TxRxDist)^2))));
        
    parfor j = 1:length(gridcent(1,:))
        xsubgrid = gridcent(1,j)-0.5*gridXres+subgridResC : subgridRes : gridcent(1,j)+0.5*gridXres-subgridResC;
        ysubgrid = gridcent(2,j)-0.5*gridYres+subgridResC : subgridRes : gridcent(2,j)+0.5*gridYres-subgridResC;
        [Xsubgrid, Ysubgrid] = meshgrid(xsubgrid, ysubgrid);
        subgridC = [Xsubgrid(:)'; Ysubgrid(:)']';
        RxRnDist = vecnorm((TxRx(TxRxpairs(2,i),:) - subgridC(:,:))');                 % Distance b/w Rx and Grid center
        TxRnDist = vecnorm((TxRx(TxRxpairs(1,i),:) - subgridC(:,:))');                 % Distance b/w Tx and Grid center
        
        EincTx2Rn_air = (-1i/4)*(besselj(0,ko*TxRnDist) - 1i * bessely(0,ko*TxRnDist));%(exp(1i*ko.*TxRnDist).*sqrt(Iimp*PTx_W.*(C/(4*pi*(TxRnDist').^2))));      
        greenf = (-1i/4)*(besselj(0,ko*RxRnDist) - 1i * bessely(0,ko*RxRnDist));%((exp(1i*ko.*RxRnDist))./(4*pi*RxRnDist));
        FFF = -1*real(Gridarea*sum(greenf.*EincTx2Rn_air)/EincTx2Rx_air);
        F(i,j) = FFF;        
    end
end
save ('F.mat','F')
    end
    
    if fM==1
        load ('F.mat','F')
    end
end
%% Solve Optimization problem
n = length(F(1,:));
NN =length(gridcent(1,:));
clear gridcent

%% Least Square Solution
if invM ==0
O = (F'*F)\F'*Pryt;
% O1 = F'*((F*F')\Pryt);
end

%% Non-Negative Least Square Solution
if invM ==1
O = lsqnonneg(F,Pryt);
end

%% Norm 1 Regularization
if invM ==2
cvx_begin quiet
% cvx_precision low
    variable O(n)
    minimize(sum((Pryt-F*O).^2) + alph*(sum(abs(O))))% + 1e-5*norm((O(2:n)-O(1:n-1)),1))%*norm(D*O, 1)) (sum(huber(Pryt-F*O)))%
    subject to
        O>=0;
cvx_end
end

%% Norm 0 Regularization
if invM ==3

O = lsqnonneg(F,Pryt);
lnorm = norm(O,1);
alphas = linspace(0,lnorm,nopts_C);
sparsity=0;
count=0;
O_N0_R_temp=[];

for k=2:(nopts_C-1)
	alpha = alphas(k);

    if sparsity <= ReqCard
          cvx_begin quiet
            variable O_N0_R(NN)
            minimize(norm(F*O_N0_R-Pryt))
            subject to
                norm(O_N0_R,1) <= alpha;
                O_N0_R>=0;
          cvx_end

    O_N0_R(find(abs(O_N0_R) < 1e-4*max(abs(O_N0_R)))) = 0;
    ind = find(abs(O_N0_R));
    sparsity = length(ind);
    fprintf(1,'Current sparsity pattern k = %d \n',sparsity);
    fprintf(1,'Current loop k = %d \n',k);
    
    if sparsity==ReqCard
      count = count+1;
      O_N0_R_temp(:,count) = O_N0_R;  
      residual_t(:,count) = norm(F*O_N0_R-Pryt);
    end
    end

    if sparsity > ReqCard
          break
    end

end

[resd_min, ind] = min(residual_t(:));
O = O_N0_R_temp(:,ind);
end
%%
if invM==5
    O = TVAL3(F,Pryt,NN,1,opts);
end
%% 
zz = ones(1,NN);
% O = round(O);
epr = zz+(O'/(((2*pi*freq)^2)*muo*epo));

epr1 = reshape(epr,RoomWidth/gridYres,RoomLength/gridXres);
%  epr1 = reshape(epr,1/gridYres,1/gridXres);

epr1flip = flip(epr1, 1); %

%%
figure(4)
imagesc(epr1flip)

xlim([0+gridXres/2 RoomLength+gridXres/2]/gridXres)
xticks(([0 1 2 3]+gridXres/2)/gridXres);
xticklabels({'0','1','2','3'});
ylim([0+gridYres/2 RoomWidth+gridYres/2]/gridYres)
yticks(([0 1 2 3]+gridYres/2)/gridYres);
yticklabels({'3','2','1','0'});
xlabel('X (meters)', 'FontSize', 18)
ylabel('Y (meters)', 'FontSize', 18)
%axis equal
name_recons = ['Image Reconstruction of Cylinder (Radius = ', ...
    num2str(radius),' m Permittivity = ', num2str(nu),')'];
title(name_recons, 'FontSize', 18);


grid on;
set(gcf,'color','w');
colormap gray
colorbar

timeElapsed = toc