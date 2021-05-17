%% Sensor Arrangement
clc;
clear all; 
close all; 
tic

K = 20; %number of nodes
M = (K^2-K)/2;
x_d = 0.6; %sensor placed in the x-direction
y_d = 0.6; %sensor placed in the y-direction 
%b = 0.1; %width of the ellipse

%grid resolution
x_res = 0.5;
y_res = x_res;

%size of the room
room_length = 3;
room_width = 3; 

xm = 0:x_d:room_length;
ym = 0:y_d:room_width;

TxRx = [[xm(1,:)', repmat(ym(1),[1,length(xm)])'];...
    [repmat(xm(1,end), [1,length(ym)-1])', ym(1,2:end)'];...
    [flip(xm(1,1:end-1))', repmat(ym(1,end),[1,length(xm)-1])'];...
    [repmat(xm(1,1), [1,length(ym)-2])', flip(ym(1,2:end-1))']]';

%%

x = 0:x_res:room_length;
y = 0:y_res:room_width;
[X,Y] = meshgrid(x,y);

x_len = length(x)-1;
y_len = length(y)-1;

grid_number = x_len*y_len;

count = 1;
%centerpixel = zeros(2,1,grid_number);
gridvec = zeros(2,4,grid_number);
for j = 1:x_len
    for i = 1:y_len
        gridvec(:,:,count) = [X(i,j) X(i+1,j) X(i,j+1) X(i+1,j+1); Y(i,j) Y(i+1,j) Y(i,j+1) Y(i+1,j+1)];
        %gridcent(:,i) = [(max(gridvec(1,:,i))+min(gridvec(1,:,i)))/2 ; (max(gridvec(2,:,i))+min(gridvec(2,:,i)))/2];
        %centerpixel(:,:,count) = [(X(i,j)+X(i+1,j+1))/2;(Y(i,j)+Y(i+1,j+1))/2];
        count = count+1;
    end
end

%% Assign Weights

TxRxMatrix = tril(ones(K,K),-1);
[row,column,ek] = find(TxRxMatrix);

gridsweightVector = zeros(y_len,x_len,M);

for j = 1:M
    
    gridsweight = zeros(y_len,x_len);
    
    x0 = TxRx(1,row(j));
    y0 = TxRx(2,row(j));
    x1 = TxRx(1,column(j));
    y1 = TxRx(2,column(j));
    
    if ((x0==0 && x1==0) || (x0==room_length && x1==room_length) || ...
            (y0==0 && y1==0) || (y0==room_width && y1==room_width))
        
        boundary = 1;
    else
        boundary  = false;
    end
    
    dx = x1-x0;
    dy = y1-y0;
    
    distance = sqrt(dx^2+dy^2);
    
    angle = atan2d(dy,dx) + 360;
    
    output = [x1, y1, x0, y0, angle];
    
    for k = 1:grid_number
       
        if (mod(angle,90) == 0 && boundary == 1) 

            gridsweight(k) = 0;
            
        else
            xx = gridvec(1,1,k);
            yy = gridvec(2,1,k);
            d = yy-y1-(dy/dx)*(xx-x1);
            %output = [x1, y1, x0, y0, xx, yy, d]
            %d = useEllipse(b,x0,y0,x1,y1,xx,yy);

            xx = gridvec(1,2,k);
            yy = gridvec(2,2,k);
            e = yy-y1-(dy/dx)*(xx-x1);
            %e = useEllipse(b,x0,y0,x1,y1,xx,yy);

            xx = gridvec(1,3,k);
            yy = gridvec(2,3,k);
            f = yy-y1-(dy/dx)*(xx-x1);
            %f = useEllipse(b,x0,y0,x1,y1,xx,yy);

            xx = gridvec(1,4,k);
            yy = gridvec(2,4,k);
            g = yy-y1-(dy/dx)*(xx-x1);
            %g = useEllipse(b,x0,y0,x1,y1,xx,yy);

            if (d < 0 || e < 0 || f < 0 || g < 0) && ...
                    (d > 0 || e > 0 || f > 0 || g > 0)
                
                gridsweight(k) = 1;
                
            elseif (dx == 0)
                
                if ~(abs(d) == Inf && abs(e) == Inf && abs(f) == Inf && abs(g) == Inf)
                
                
                gridsweight(k) = 1;
                end

            end
        end
    end
    gridsweightVector(:,:,j) = gridsweight;
end

%% Plotting and visualization
% 
% xxx = -0.5:grid_size:6.5;
% yyy = -0.5:grid_size:3.5;
% 
% for l = 1:19
%     figure(l);
%     imagesc(gridsweightVector(:,:,l));
%     hold on
%     plot(TxRx(1,:)+1,TxRx(2,:)+1,'ro','MarkerSize',8,'MarkerFaceColor','r');
%     hold off
%     colorbar;
%     ylim([1 4]);
%     xlim([1 7]);
%     xticks([1 2 3 4 5 6 7])
%     xticklabels({'0','1','2','3','4','5','6'})
%     yticks([1 2 3 4])
%     yticklabels({'0','1','2','3'})
%     grid on
% end
% 

