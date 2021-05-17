%% Sensor Arrangement
clc;
clear all; 
close all; 
tic

K = 20; %number of nodes
M = (K^2-K)/2;
x_d = 0.6; %sensor placed in the x-direction
y_d = 0.6; %sensor placed in the y-direction 
b = 0.08; %width of the ellipse
% UL = 0;
% SubG = 0; 
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
centerpixel = zeros(2,1,grid_number);
gridvec = zeros(2,4,grid_number);
for j = 1:x_len
    for i = 1:y_len
        gridvec(:,:,count) = [X(i,j) X(i+1,j) X(i,j+1) X(i+1,j+1); Y(i,j) Y(i+1,j) Y(i,j+1) Y(i+1,j+1)];
        centerpixel(:,:,count) = [(X(i,j)+X(i+1,j+1))/2;(Y(i,j)+Y(i+1,j+1))/2];
        count = count+1;
    end
end

for i = 1:grid_number
    gridcent(:,i) = [(max(gridvec(1,:,i))+min(gridvec(1,:,i)))/2 ; (max(gridvec(2,:,i))+min(gridvec(2,:,i)))/2];
end



%%

TxRxMatrix = tril(ones(K,K),-1);
[row,column,ek] = find(TxRxMatrix);

gridsweightVector = zeros(y_len,x_len,M);


for j = 1:M
    
    gridsweight = zeros(y_len,x_len);
    
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
                          
            if (d_ij1+d_ij2 < distance + b)
                
                gridsweight(k) = 1/sqrt(distance);
                
%                 if (d < 1 || e < 1 || f < 1 || g < 1)
%                     gridsweight(k) = 1/sqrt(distance);
%                 end
%             elseif (abs(x0-x_center)<=x_res/2 && ...
%                     abs(y0-y_center)<=y_res/2 || ...
%                     abs(x1-x_center)<=x_res/2 && ...
%                     abs(y1-y_center)<=y_res/2)
%                 gridsweight(k) = 1/sqrt(distance);
            else
                gridsweight(k) = 0;
            end
                
            
        end
    end
    gridsweightVector(:,:,j) = gridsweight;
end
            
save gridsweightVector





