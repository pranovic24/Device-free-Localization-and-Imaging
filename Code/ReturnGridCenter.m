function [gridvec, gridcenter, centerpixel, X, Y, x, y] = ReturnGridCenter(TxRx, gridXres, gridYres, room_length, room_width)

x = 0:gridXres:room_length;
y = 0:gridYres:room_width;
[X, Y] = meshgrid(x, y);

grids_number = (length(x)-1) * (length(y)-1); 

count = 1;
centerpixel = zeros(2, 1, grids_number);
gridvec = zeros(2, 4, grids_number);
for j = 1:length(x)-1
    for i = 1:length(y)-1
        gridvec(:,:,count) = [X(i,j) X(i+1,j) X(i,j+1) X(i+1,j+1); Y(i,j) Y(i+1,j) Y(i,j+1) Y(i+1,j+1)];
        centerpixel(:,:,count) = [(X(i,j)+X(i+1,j+1))/2;(Y(i,j)+Y(i+1,j+1))/2];
        count = count+1;
    end
end

gridcenter = zeros(2, grids_number);

for i = 1:grids_number
    gridcenter(:,i) = [(max(gridvec(1,:,i))+min(gridvec(1,:,i)))/2 ; (max(gridvec(2,:,i))+min(gridvec(2,:,i)))/2];
end

end