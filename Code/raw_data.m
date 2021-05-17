clear all; close all;
clc;

% Setting the TxRx

%% Opening the File
file = 'log - (1300hrs-11-08-2020).txt';
A = importdata(file);
RSSI = A.data;
words = A.textdata;
K = 20;

%% Determining the Time
hours_string = char(words(:,1));
hours = str2num(hours_string(:,2:3));

minutes_string = char(words(:,2));
minutes = str2num(minutes_string(:,1:2));

seconds_string = char(words(:,3));
seconds = str2num(seconds_string(:,1:2));

milliseconds_string = char(words(:,4));
milliseconds = str2num(milliseconds_string(:,1:2));

time = minutes*60 + seconds + milliseconds/100;

%% Determing the Transmitter
device_string = char(words(:,5));
device = str2num(device_string(:,8:9));

measure_string = char(words(:,5));

TX = ~cellfun('isempty', strfind(cellstr(measure_string),'TX'));

TXIndex = find(TX == 1);
TXPower = device(TXIndex);

%% RSSI Processing
RSSIIndex = find(TX == 0);
RSSIData = device(RSSIIndex);

for i = 1:length(TXIndex)-1
    RSSInumber(i) = (TXIndex(i+1)-TXIndex(i))-1;
end

RSSInumber = transpose(RSSInumber);

RSSILength = length(RSSI);

RSSInumber = [RSSInumber; RSSILength-TXIndex(length(TXIndex))];

dataset_dB = NaN(length(TXIndex),K);

for n = 1:length(TXIndex)
    dataPoints = ((TXIndex(n)+1):(TXIndex(n)+RSSInumber(n)))';
    dataset_dB(n,device(dataPoints)) = RSSI(dataPoints);
end

for i = 1:length(TXPower)
    x = TXPower(i);
    dataset_dB(i,x) = NaN;
end

datasetNew = [time(TXIndex) device(TXIndex) dataset_dB];

%% Finding the Missing Values
new_dataset = [];
seq = device(TXIndex);
count_TX = zeros(1,K);
hist = NaN(K, K+2);
for i = 1:K
    hist(i,2) = i;
end
for i = 1:length(seq)
    if count_TX(datasetNew(i,2)) > 0
        for j=1:K
            if count_TX(j) == 0
                new_dataset = [new_dataset; hist(j,:)];
            end
        end
        count_TX = zeros(1,K);  
    end 
    hist(datasetNew(i, 2), :) = datasetNew(i,:);
    new_dataset = [new_dataset; datasetNew(i,:)];
    count_TX(datasetNew(i, 2)) = count_TX(datasetNew(i,2)) + 1;    
end

for j=1:length(count_TX)
    if count_TX(j) == 0
        new_dataset = [new_dataset; hist(j,:)];
    end
end

new_dataset(:,1) = [];

%% Ordering Dataset

multiple = length(new_dataset)/K;
sub_dataset = mat2cell(new_dataset,20*ones(1,multiple),21);
%celldisp(sub_dataset);

for k = 1:length(sub_dataset)
    sub_dataset{k} = sortrows(sub_dataset{k});
end

ordered_dataset = cell2mat(sub_dataset);
ordered_dataset(:,1) = [];

new_ordered_dataset = zeros(20,20,length(ordered_dataset)/K);

for i = 1:(length(ordered_dataset)/K)
    idr = (1:K)+(i-1)*K;
    ordered_dataset(idr,:);
    new_ordered_dataset(:,:,i) = ordered_dataset(idr,:);
%     new_ordered_dataset(:,:,i) = tril(new_ordered_dataset(:,:,i),-1)'+new_ordered_dataset(:,:,i);
    
end

%% Mode Matrix and Data Preparation
mode_matrix = mode(new_ordered_dataset, 3);
mean_matrix = nanmean(new_ordered_dataset, 3);
% empty_10_1_matrix = mode_matrix;
% empty_mean_matrix = mean_matrix;
% difference = mode_matrix - mean_matrix;
% standard_deviation = std(new_ordered_dataset, [], 3);

%% Plotting
figure(1)
transmitter = 13;
receiver = 6;
TXOpposite = receiver; 
RXOpposite = transmitter;


transmitterIndex = find(datasetNew(:,2) == transmitter);
receiverIndex = find(datasetNew(transmitterIndex,receiver+2));
overallIndex = transmitterIndex(receiverIndex);
receiverData = datasetNew(overallIndex,receiver+2);
receiverData_mode = mode(receiverData)
timeHour = (datasetNew(overallIndex,1))/60;

TXOppositeIndex = find(datasetNew(:,2) == TXOpposite);
RXOppositeIndex = find(datasetNew(TXOppositeIndex,RXOpposite+2));
overallOppositeIndex = TXOppositeIndex(RXOppositeIndex);
RXOppositeData = datasetNew(overallOppositeIndex,RXOpposite+2);
RXOppositeData_mode = mode(RXOppositeData)
timeHour1 = (datasetNew(overallOppositeIndex,1))/60;

plot(timeHour,receiverData, 'b-o', 'LineWidth', 1.5);
hold on; 
plot(timeHour1,RXOppositeData, 'r-o', 'LineWidth', 1.5);
% ylim([-30 0]);
% xlim([0 5]);
name = ['Transmitter = ', num2str(transmitter), ', Receiver = ', num2str(receiver), ', Data Points = ',num2str(length(receiverData))];
title('RSSI of Measured by Two ESP32 Boards', 'Fontsize', 18)
ylabel('RSSI (dBm)', 'Fontsize', 18);
xlabel('Time (Minutes)', 'Fontsize', 18);
detail_1 = ['Rx = ', num2str(receiver), ', Tx = ', num2str(transmitter)];
detail_2 = ['Rx = ', num2str(transmitter), ', Tx = ', num2str(receiver)];
legend(detail_1, detail_2, 'Fontsize', 18);
grid on
set(gcf,'color','w');

% save empty_10_1_matrix

