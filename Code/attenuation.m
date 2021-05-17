close all 
clc
clear 

load final_dataset
load gridsweightVector_new


for i  = 1:(length(ordered_dataset)/K)
    out(:,:,i) = reshape(nonzeros(final_dataset(:,:,i)),[],1);
end

for j  = 1:(length(ordered_dataset)/K)-1
    delta_out(:,:,j) = out(:,:,j+1) - out(:,:,j);
end

W_new = [];
for i = 1:M
    W(:,:,i) = reshape(gridsweightVector(:,:,i),[],1).';
    W_new = [W_new; W(:,:,i)];
end

for i = 1:(length(ordered_dataset)/K)-1
    x_ls(:,:,i) = abs(inv((W_new')*W_new)*(W_new')*delta_out(:,:,i));
    for j = 1:grids_number
        if x_ls(j,:,i) < 2
            x_ls(j,:,i) = 0;
        end
    end
    x_lsFinal(:,:,i) = reshape(x_ls(:,:,i),nodes_vertical,nodes_horizontal);
end
    
save x_lsFinal
% for i = 1:(length(ordered_dataset)/K)-1    
%     x_new(:,:,i) = lsqminnorm(delta_out(:,:,i),W_new);
%     for j = 1:grids_number
%         if x_new(:,j,i) < 0
%             x_new(:,j,i) = 0;
%         end
%     end
%     x_final(:,:,i) = reshape(x_new(:,:,i),nodes_vertical,nodes_horizontal);
% end


