clc; 
clear;
close all;

Weight
% sensor_setupnNew

load('Data_obj8lam_per_3_2');

new_before = tril(Data_obj8lam_per_3_2(:,:,1));
new_after = tril(Data_obj8lam_per_3_2(:,:,2));

out_before = reshape(nonzeros(new_before),[],1);
out_after = reshape(nonzeros(new_after),[],1);

delta_out = out_after - out_before;

% load('empty_20_matrix.mat')
% load('people_20_matrix.mat')
% % load('F.mat')
% 
% empty = tril(empty_20_matrix, -1);
% people = tril(people_20_matrix, -1);
% 
% empty_reshape = reshape(nonzeros(empty),[],1);
% people_reshape = reshape(nonzeros(people),[],1);
% 
% delta = people_reshape - empty_reshape;
% % delta = empty_reshape - people_reshape;
% 
% W_new = [];
% 
% for i = 1:M
%     W(:,:,i) = reshape(gridsweightVector(:,:,i),[],1).';
%     W_new = [W_new; W(:,:,i)];
% end
% 
% delta_out(all(W_new == 0,2)) = 0;
% 
% x_ls = inv((W_new.')*W_new)*(W_new.')*delta;
% x_ls_backup = x_ls;
% 
% 
% % x_ls = lsqr(W_new, delta_out);
% 
% for j = 1:grid_number
%     if x_ls(j,:) < 0
%         x_ls(j,:) = 0;
%     end
% end
% 
% x_lsFinal= reshape(x_ls,y_len,x_len);
% x_lsFinal = rescale(x_lsFinal);
% % x_lsFinal1  =  flip(x_lsFinal);
% 
% % x = -0.5:1:6.5;
% % y = -0.5:1:3.5;
% figure(1)
% imagesc(x_lsFinal);
% colormap gray
% colorbar

% plot(x,y)

% 
% grid on
% 
% 
% xlim([0+x_res/2 room_length+x_res/2]/x_res)
% xticks(([0 1 2 3 4 5 6]+x_res/2)/x_res);
% xticklabels({'0','1','2','3','4','5','6'});
% ylim([0+y_res/2 room_width+y_res/2]/y_res)
% yticks(([0 1 2 3]+y_res/2)/y_res);
% yticklabels({'0','1','2','3'});
% set(gca,'YDir','normal');
% set(gcf,'color','w');
% % title(['Image Reconstruction of Cylinder (Radius = ', num2str(radius),'m Permittivity = ' ...
% %     num2str(nu),')']);
% xlabel('Length of Room (m)');
% ylabel('Width of Room (m)');
% % a = get(gca,'XTickLabel');
% set(gca,'FontSize',20);
% % set(gca,'XTickLabelMode','auto');
% 
% title(['Image Reconstruction via RTI']);
% xlabel('Length of Room')
% ylabel('Width of Room')
% set(gca,'YDir','normal');
% set(gcf,'color','w');
% colorbar

