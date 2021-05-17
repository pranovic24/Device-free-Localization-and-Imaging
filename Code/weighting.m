clear all
close all
clc
tic

%% Initialization of Global Variables

% Number of Sensors
K = 20; 
M = (K^2-K)/2;

% Room Size
room_length = 1.5;
room_width = 1.5;

% Sensor Placement
x_d = 0.3; 
y_d = 0.3; 

% Dimension of Room
xm = 0:x_d:room_length; 
ym = 0:y_d:room_width; 

TxRx = [[xm(1,:)', repmat(ym(1),[1,length(xm)])'];...
    [repmat(xm(1,end), [1,length(ym)-1])', ym(1,2:end)']; ...
    [flip(xm(1,1:end-1))', repmat(ym(1,end),[1,length(xm)-1])'];...
    [repmat(xm(1,1), [1,length(ym)-2])', flip(ym(1,2:end-1))']];

figure(1);
labels = num2str((1:length(TxRx))'); 
rectangle('Position', [TxRx(1,1), TxRx(1,2),...
    room_length, room_width], 'LineWidth', 1.5);
hold on;
scatter(TxRx(:,1), TxRx(:,2), 200,'s','filled', 'r', ...
    'MarkerEdgeColor', 'k'); 
hold on;
text(TxRx(:,1),TxRx(:,2),labels,'VerticalAlignment','bottom',...
    'HorizontalAlignment','left', 'Color','b', 'FontSize',18)
title('Wi-Fi Nodes Location', 'FontSize', 18)
xlabel('X (meters)', 'FontSize', 18)
ylabel('Y (meters)', 'FontSize', 18)
axis([-0.5 2 -0.5 2])
grid on;
set(gcf,'color','w');

%% Determining the TxRx pairs
TxRxpairs = [];

for i = 1:length(TxRx)
    TxRx11 = TxRx; 
    TxRx11(:,3) = (1:length(TxRx))';
    TxRx11(i,:) = []; 
    TxRxpairs = [TxRxpairs [repmat(i,[1, length(TxRx)-1]); TxRx11(:,3)']];
end

%% Determining Grid Vector and Grid Center
gridXres = 0.5;
gridYres = 0.5;

[gridvec, gridcenter, centerpixel, x, y] = ReturnGridCenter(TxRx, gridXres,...
    gridYres, room_length, room_width);

%% Choosing the Method of Weighting Model

method = 1; % 1: Amar Method 2: Old Ellipse Model 1 3: RT Paper Ellipse Model

TxRxMatrix = tril(ones(K,K),-1);
[row,column,ek] = find(TxRxMatrix);

gridsweightVector = zeros(length(x)-1,length(y)-1,M);
grids_number = (length(x)-1) * (length(y)-1);


%% Method 1 - Amar's Weight Model
if method == 1
    

    SemiMin = gridXres/2;
    
    parfor i = 1:length(TxRxpairs)   
        TxRxDist = norm(TxRx(TxRxpairs(1,i),:) - TxRx(TxRxpairs(2,i),:));                % Distance b/w Tx and Rx
        Thresh = 2*sqrt(TxRxDist*TxRxDist/4 + SemiMin*SemiMin);

        RxRnDist = vecnorm((TxRx(TxRxpairs(2,i),:) - gridcenter(:,:)')');                 % Distance b/w Rx and Grid center
        TxRnDist = vecnorm((TxRx(TxRxpairs(1,i),:) - gridcenter(:,:)')');                 % Distance b/w Tx and Grid center   
        foc_sum = RxRnDist+TxRnDist;
        foc_sum(foc_sum > Thresh) = 0;
        foc_sum(foc_sum ~= 0) = 1;
        F(i,:) = foc_sum;        
    end

    
    save F

end

%% Method 2 - 2015 RT Paper Model
% Width of the Ellipse
b = 0.08;

if method == 2
    TxRx = TxRx';
    for j = 1:M

        gridsweight = zeros(length(x)-1,length(y)-1);

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


        for k = 1:grids_number

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

    
end


%% Method 3 - Old Ellipse Model


if method == 3
    TxRx = TxRx';
    for j = 1:M

        gridsweight = zeros(length(x)-1,length(y)-1);

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

        for k = 1:grids_number

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
end



toc





