clear all;
clc; close all;

%% Humans

% load final_dataset_pranay_jehiel
% load final_dataset_jehiel
% load final_dataset_before

% load no_one_3
% load no_one_5
% load jehiel_3
% load jehiel_5
% load jehiel_pranay_3
% load jehiel_pranay_5

load no_one
load no_one_2
load jehiel
load jehiel_pranay

jehiel = [no_one(end,:); jehiel];
jehiel_pranay = [jehiel(end,:); jehiel_pranay];
no_one_2 = [jehiel_pranay(end,:); no_one_2];

figure(1)
plot((no_one_2(:,1)/60), no_one_2(:,26), 'g-o', 'LineWidth', 1.5)
hold on
plot((jehiel_pranay(:,1)/60), jehiel_pranay(:,26), 'k-o', 'LineWidth', 1.5)
hold on
plot((jehiel(:,1)/60), jehiel(:,26), 'r-o', 'LineWidth', 1.5)
hold on
plot((no_one(:,1)/60), no_one(:,26), 'b-o', 'LineWidth', 1.5)

ylim([-32 -8])
ylabel('RSSI (dBm)', 'FontSize', 18);
xlabel('Time (Minutes)', 'FontSize', 18);
title('Presence of Humans between 3 meters', 'FontSize', 18);
grid on;
legend('No Humans Present', 'Two Humans Present', 'One Human Present', ...
    'No Humans Present', 'FontSize', 18)
set(gcf,'color','w');

% figure(2)
% plot(jehiel_5(:,1)/60, jehiel_5(:,26), 'b-o', 'LineWidth', 1.5)
% hold on
% plot(jehiel_pranay_5(:,1)/60, jehiel_pranay_5(:,36), 'r-o', 'LineWidth', 1.5)
% hold on
% plot(no_one_5(:,1)/60, no_one_5(:,26), 'g-o', 'LineWidth', 1.5)
% ylim([-40 -5])
% ylabel('RSSI (dBm)');
% xlabel('Time');
% title('Humans between 5 meters');
% grid on;
% legend('One Human', 'Two Humans', 'Empty')
% set(gcf,'color','w');



%% Styrofoam Results
% load styro_3
% load styro_5
% load no_styro_3
% load no_styro_5
% load no_styro
% load styro
% load no_styro_2
% 
% figure(3)
% plot(no_styro(:,1)/60, no_styro(:,26), 'g-o', 'LineWidth', 1.5)
% hold on;
% plot(styro(:,1)/60, styro(:,26), 'b-o', 'LineWidth', 1.5)
% hold on;
% plot(no_styro_2(:,1)/60, no_styro_2(:,26), 'r-o', 'LineWidth', 1.5)
% ylim([-14 -10])
% ylabel('RSSI (dBm)');
% xlabel('Time');
% title('Styrofoam Box Between 3 meters', 'FontSize', 18);
% grid on;
% legend('No Styrofoam Box', 'Styrofoam Box', 'No Styrofoam Box')
% set(gcf,'color','w');

% figure(4)
% plot(styro_5(:,1)/60, styro_5(:,26), 'b-o', 'LineWidth', 1.5)
% hold on;
% plot(no_styro_5(:,1)/60, no_styro_5(:,26), 'r-o', 'LineWidth', 1.5)
% ylim([-15 -10])
% ylabel('RSSI (dBm)');
% xlabel('Time');
% title('Styrofoam Box between 5 meters');
% grid on;
% legend('Styrofoam Box', 'No Styrofoam Box')
% set(gcf,'color','w');

%% Table Results
% load table_3
% load table_5
% load no_table_3
% load no_table_5
load no_table
load table
load no_table_2

table = [no_table(end,:); table];
no_table_2 = [table(end,:); no_table_2];

figure(5)
% plot(no_table(:,1)/60, no_table(:,26), 'g-o', 'LineWidth', 1.5)
% hold on;
% plot(table(:,1)/60, table(:,26), 'b-o', 'LineWidth', 1.5)
% hold on;


plot(no_table(:,1)/60, no_table(:,26), 'g-o', 'LineWidth', 1.5)
hold on;
plot(table(:,1)/60, table(:,26), 'b-o', 'LineWidth', 1.5)
hold on;
plot(no_table_2(:,1)/60, no_table_2(:,26), 'r-o', 'LineWidth', 1.5)


ylim([-20 -9])
ylabel('RSSI (dBm)', 'FontSize', 18);
xlabel('Time (Minutes)', 'FontSize', 18);
title('Presence of Wooden Table between 3 meters', 'FontSize', 18);
grid on;
legend('No Table Present', 'Table Present', 'No Table Present', 'FontSize', 18)
set(gcf,'color','w');

% figure(6)
% plot(table_5(:,1)/60, table_5(:,26), 'b-o', 'LineWidth', 1.5)
% hold on;
% plot(no_table_5(:,1)/60, no_table_5(:,26), 'r-o', 'LineWidth', 1.5)
% ylim([-17 -9])
% ylabel('RSSI (dBm)');
% xlabel('Time');
% title('Table between 5 meters');
% grid on;
% legend('Table', 'No Table')
% set(gcf,'color','w');