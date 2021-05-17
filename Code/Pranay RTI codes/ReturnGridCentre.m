function [gridvec, gridcent, X, Y] = ReturnGridCentre(TxRx, gridXres, gridYres, RoomWidth, RoomLength)

x = 0:gridXres:RoomLength;%0:gridXres:2;%1:gridYres:2;%
y = 0:gridYres:RoomWidth;
[X,Y] = meshgrid(x,y);



count = 1;
gridvec = zeros(2, 4, (length(x)-1)*(length(y)-1));
for j = 1:length(x)-1
    for i = 1:length(y)-1
        gridvec(:,:,count) = [X(i,j) X(i+1,j) X(i,j+1) X(i+1,j+1); Y(i,j) Y(i+1,j) Y(i,j+1) Y(i+1,j+1)];       
        count = count+1;
    end
end

for i = 1:(length(x)-1)*(length(y)-1)
 gridcent(:,i) = [(max(gridvec(1,:,i))+min(gridvec(1,:,i)))/2 ; (max(gridvec(2,:,i))+min(gridvec(2,:,i)))/2];
end
