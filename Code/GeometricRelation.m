clear all
close all
clc

TxRx1 = [0 0]';
TxRx2 = [1 0]';
TxRx3 = [2 0]';
TxRx4 = [3 0]';
TxRx5 = [4 0]';
TxRx6 = [5 0]';
TxRx7 = [6 0]';
TxRx8 = [6 0.75]';
TxRx9 = [6 1.5]';
TxRx10 = [6 2.25]';
TxRx11 = [6 3]';
TxRx12 = [5 3]';
TxRx13 = [4 3]';
TxRx14 = [3 3]';
TxRx15 = [2 3]';
TxRx16 = [1 3]';
TxRx17 = [0 3]';
TxRx18 = [0 2.25]';
TxRx19 = [0 1.5]';
TxRx20 = [0 0.75]';



TxRx = [TxRx1 TxRx2 TxRx3 TxRx4 TxRx5 TxRx6 TxRx7 TxRx8 TxRx9 TxRx10 TxRx11 TxRx12 TxRx13...
    TxRx14 TxRx15 TxRx16 TxRx17 TxRx18 TxRx19 TxRx20];

% figure(3)
% plot(TxRx(1,:), TxRx(2,:))
% xlim([-0.5,6.5])
% ylim([-0.5,6.5])

x = -0.5:1:6.5;
y = -0.5:1:4.5;
[X,Y] = meshgrid(x,y);
% surf(X,Y,dd)
X(X(:)==-0.5) = 0;
X(X(:)== 6.5) = 6;
Y(Y(:)==-0.5) = 0;
Y(Y(:)== 4.5) = 4;

count = 1;
gridvec = zeros(2, 4, 35);
for j = 1:7
    for i = 1:5
        gridvec(:,:,count) = [X(i,j) X(i+1,j) X(i,j+1) X(i+1,j+1); Y(i,j) Y(i+1,j) Y(i,j+1) Y(i+1,j+1)];
        count = count+1;
    end
end

% stem(gridvec(1,:), gridvec(2,:));

% weightss = zeros(190, length(gridvec(:,:,:)));


% Unique line index
TxRxInd = ones(20,20);
TxRxInd1 = tril(TxRxInd,-1);
[row,col,v] = find(TxRxInd1);

% [TxRx(:, row(2)), TxRx(:, col(2))]
gridweighVec = zeros(5,7,190);
for i = 1:190
    
    gridweightss = zeros(5,7);
    for j = 1:35
        
        X1 = TxRx(1,row(i));
        Y1 = TxRx(2,row(i));
        X2 = TxRx(1,col(i));
        Y2 = TxRx(2,col(i));
        
%         if length(gridvec(1,1,j))
        XX = gridvec(1,1,j);
        YY = gridvec(2,1,j);
        a = YY - Y1 - ((Y2-Y1)/(X2-X1))*(XX-X1);                           % Equation of line as function          
        XX = gridvec(1,2,j);
        YY = gridvec(2,2,j);        
        b = YY - Y1 - ((Y2-Y1)/(X2-X1))*(XX-X1);
        XX = gridvec(1,3,j);
        YY = gridvec(2,3,j);
        c = YY - Y1 - ((Y2-Y1)/(X2-X1))*(XX-X1);
        XX = gridvec(1,4,j);
        YY = gridvec(2,4,j);
        d = YY - Y1 - ((Y2-Y1)/(X2-X1))*(XX-X1);
        
        if (a<0 || b<0 || c<0 || d<0) && (a>0 || b>0 || c>0 || d>0)% || (a==0 || b==0 || c==0 || d==0)
            gridweightss(j) = 1;
        end
        
%         if (X1==X2) || (Y1==Y2)
%             
%         end
        
    end
    gridweighVec(:,:,i) = gridweightss;
end



%% Plotting and visualization
% xxx = 0:0.1:8;
% yyy = 0:0.5:8;
% Y1 = 3;
% X1 = 6;
% X2 = 5;
% Y2 = 4;
% plot(xxx,Y1 + ((Y2-Y1)/(X2-X1))*(xxx-X1)) %(3/5)*(xxx-1)
% xlim([0,6])
% ylim([0,4])
% xticks([-0.5 0.5 1.5 2.5 3.5 4.5 5.5 6.5])
% yticks([-0.5 0.5 1.5 2.5 3.5 4.5])
% grid on
% hold on
scatter(TxRx(1,:), TxRx(2,:))
% hold off
% % 
% save row
% save col
% gridvec = []
