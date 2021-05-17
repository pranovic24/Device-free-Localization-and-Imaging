close all; 
clear all;
clc;

K = 20;  %number of nodes
M = (K^2-K)/2;
b = 0.1;

grid_size = 0.5;
room_length = 6;
room_width = 3;

nodes_horizontal = (room_length)/grid_size;
nodes_vertical = (room_width)/grid_size;

grid_number = nodes_horizontal*nodes_vertical;


% TxRx1 = [0 0]';
% TxRx2 = [0.75 0]';
% TxRx3 = [1.5 0]';
% TxRx4 = [2.25 0]';
% TxRx5 = [3 0]';
% TxRx6 = [3.75 0]';
% TxRx7 = [4.5 0]';
% TxRx8 = [5.25 0]';
% TxRx9 = [6 0]';
% TxRx10 = [6 0.75]';
% TxRx11 = [6 1.5]';
% TxRx12 = [6 2.25]';
% TxRx13 = [6 3]';
% TxRx14 = [5.25 3]';
% TxRx15 = [4.5 3]';
% TxRx16 = [3.75 3]';
% TxRx17 = [3 3]';
% TxRx18 = [2.25 3]';
% TxRx19 = [1.5 3]';
% TxRx20 = [0.75 3]';
% TxRx21 = [0 3]';
% TxRx22 = [0 2.25]';
% TxRx23 = [0 1.5]';
% TxRx24 = [0 0.75]';
% 
% TxRx = [TxRx1 TxRx2 TxRx3 TxRx4 TxRx5 TxRx6 TxRx7 TxRx8 TxRx9 TxRx10 ...
%     TxRx11 TxRx12 TxRx13 TxRx14 TxRx15 TxRx16 TxRx17 TxRx18 TxRx19 ...
%     TxRx20 TxRx21, TxRx22, TxRx23, TxRx24];

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



x = 0:grid_size:room_length+(grid_size/2);
y = 0:grid_size:room_width+(grid_size/2);
[X,Y] = meshgrid(x,y);
% X(:,1) = 0;
% X(:,end) = room_length;
% Y(1,:) = 0;
% Y(end,:) = room_width;


count = 1;
centerpixel = zeros(2,1,grid_number);
gridvec = zeros(2, 4, grid_number);
for j = 1:nodes_horizontal
    for i = 1:nodes_vertical
        gridvec(:,:,count) = [X(i,j) X(i+1,j) X(i,j+1) X(i+1,j+1); Y(i,j) Y(i+1,j) Y(i,j+1) Y(i+1,j+1)];
        centerpixel(:,:,count) = [(X(i,j)+X(i+1,j+1))/2;(Y(i,j)+Y(i+1,j+1))/2];
        count = count+1;
    end
end



TxRxMatrix = tril(ones(K,K),-1);
[row,column,ek] = find(TxRxMatrix);

gridsweightVector = zeros(nodes_vertical,nodes_horizontal,M);

% d1 = []

gg = [];

for j = 1:M
    
    gridsweight = zeros(nodes_vertical,nodes_horizontal);
    
    x0 = TxRx(1,row(j));
    y0 = TxRx(2,row(j));
    x1 = TxRx(1,column(j));
    y1 = TxRx(2,column(j));
    
    if (x0==0 && x1==0 || x0==room_length && x1==room_length || ...
        y0==0 && y1==0 || y0==room_width && y1==room_width)
        boundary = 1;
    else
        boundary  = false;
    end
    
    distance = sqrt((x1-x0)^2+(y1-y0)^2);
    
    angle = atan2d((y1-y0),(x1-x0)) + 360;
    
    %output = [x1, y1, x0, y0, angle];
    
   
    for k = 1:grid_number
       
        if (mod(angle,90) == 0 && boundary == 1)
            
            gridsweight(k) = 0;
            
        else
%             xx = gridvec(1,1,k);
%             yy = gridvec(2,1,k);
%             d = useEllipse(b,x0,y0,x1,y1,xx,yy);
% %             d1 = [d1; d]
% 
%             xx = gridvec(1,2,k);
%             yy = gridvec(2,2,k);
%             e = useEllipse(b,x0,y0,x1,y1,xx,yy);
% 
%             xx = gridvec(1,3,k);
%             yy = gridvec(2,3,k);
%             f = useEllipse(b,x0,y0,x1,y1,xx,yy);
% 
%             xx = gridvec(1,4,k);
%             yy = gridvec(2,4,k);
%             g = useEllipse(b,x0,y0,x1,y1,xx,yy);
%             
            x_center = centerpixel(1,k);
            y_center = centerpixel(2,k);
            
            d_ij1 = sqrt((x0-x_center)^2+(y0-y_center)^2);
            d_ij2 = sqrt((x1-x_center)^2+(y1-y_center)^2);
                          
            if (d_ij1+d_ij2 <= distance + b )
                
                gridsweight(k) = 1/sqrt(distance);
                
%                 if (d < 1 || e < 1 || f < 1 || g < 1)
%                     gridsweight(k) = 1/sqrt(distance);
%                 end
                
            else
                gridsweight(k) = 0;
            end
                
            
        end
    end
    gridsweightVector(:,:,j) = gridsweight;
end
            

% 
% gridsweightVector = flip(gridsweightVector);
save gridsweightVector

