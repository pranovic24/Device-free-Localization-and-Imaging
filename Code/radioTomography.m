close all; 
clear all; 
K = 20;

%Setting the TX and RX

file = 'log - (1300hrs-11-08-2020).txt';
A = importdata(file);
RSSI = A.data;
words = A.textdata;

%Determining the time 
hours_string = char(words(:,1));
hours = str2num(hours_string(:,2:3));

minutes_string = char(words(:,2));
minutes = str2num(minutes_string(:,1:2));

seconds_string = char(words(:,3));
seconds = str2num(seconds_string(:,1:2));

milliseconds_string = char(words(:,4));
milliseconds = str2num(milliseconds_string(:,1:2));

time = minutes*60+seconds+milliseconds/100;

%Determining the TX
device_string = char(words(:,5));
device = str2num(device_string(:,8:9));

measure_string = char(words(:,5));

TX = ~cellfun('isempty', strfind(cellstr(measure_string),'TX'));
%TXElement = ~cellfun('isempty', strfind(cellstr(measure_string),'Measure4 TX'));

TXIndex = find(TX == 1);
RSSIIndex = find(TX == 0);


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

dataset = 10.^(dataset_dB);

TXPower = device(TXIndex);
RSSIData = device(RSSIIndex);



timeWindow = 60;
[row col] = find(isnan(dataset));
timeTX = time(TXIndex);
index1 = 1;
windowProfile = [];
counts = zeros(K,K);
values = zeros(K,K);
for i = 1:length(dataset)
    bar = zeros(2,K);
    bar(1,:) = dataset(i,:);
    bar(2,:) = values(TXPower(i),:);
    values(TXPower(i),:) = nansum(bar);
    counts(TXPower(i),:) = counts(TXPower(i),:)+1;
    [row col] = find(isnan(dataset(i,:)));
    for k = 1:length(col)
        counts(TXPower(i), col(k)) = counts(TXPower(i), col(k))-1;
    end
    if timeTX(i) - timeTX(index1) > timeWindow
        % create time profile of the chunk of data indexed from index1 to
        % i-1
        
        values = values ./ counts;
        for j = index1:i-1
            [row col] = find(isnan(dataset(j,:)));
            for k = 1:length(col)
                dataset(j,col(k)) = values(TXPower(j),col(k));
            end
        end   
        counts = zeros(K,K);
        values = zeros(K,K);
        index1 = i;
    end    
end

counts = zeros(K,K);
values = zeros(K,K);

for i = length(dataset)-2*timeWindow:length(dataset)
    bar = zeros(2,K);
    bar(1,:) = dataset(i,:);
    bar(2,:) = values(TXPower(i),:);
    values(TXPower(i),:) = nansum(bar);
    counts(TXPower(i),:) = counts(TXPower(i),:)+1;
    [row col] = find(isnan(dataset(i,:)));
    for k = 1:length(col)
        counts(TXPower(i), col(k)) = counts(TXPower(i), col(k))-1;
    end
end

values = values ./ counts;
for j = length(dataset)-2*timeWindow:length(dataset)
    [row col] = find(isnan(dataset(j,:)));
    for k = 1:length(col)
        dataset(j,col(k)) = values(TXPower(j),col(k));
    end
end



for i = 1:length(TXPower)
    x = TXPower(i);
    dataset(i,x) = NaN;
end

datasetNew = [time(TXIndex) device(TXIndex) round(log10(dataset))];


new_dataset = [];
seq = device(TXIndex);
count_TX = zeros(1,K);
hist = zeros(K, K + 2);
for i = 1:K
    hist(i, 2) = i;
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

multiple = length(new_dataset)/K;
sub_dataset = mat2cell(new_dataset,20*ones(1,multiple),21);
%celldisp(sub_dataset);

for k = 1:length(sub_dataset)
    sub_dataset{k} = sortrows(sub_dataset{k});
end

ordered_dataset = cell2mat(sub_dataset);
ordered_dataset(:,1) = [];

% ordered_dataset = tril(ordered_dataset,-1)' + ordered_dataset;



new_ordered_dataset = zeros(20,20,length(ordered_dataset)/K);

for i = 1:(length(ordered_dataset)/K)
    idr = (1:K)+(i-1)*K;
    ordered_dataset(idr,:);
    new_ordered_dataset(:,:,i) = ordered_dataset(idr,:);
%     new_ordered_dataset(:,:,i) = tril(new_ordered_dataset(:,:,i),-1)'+new_ordered_dataset(:,:,i);
    
end

for i = 1:(length(ordered_dataset)/K)
    for j = 1:K-1
        for k = j+1:K
            if isnan(new_ordered_dataset(j,k,i)) == 1
                new_ordered_dataset(j,k,i) = new_ordered_dataset(k,j,i);
            end
            if isnan(new_ordered_dataset(k,j,i)) == 1
                new_ordered_dataset(k,j,i) = new_ordered_dataset(j,k,i);
            end
        end
    end
end

final_dataset = zeros(20,20,length(ordered_dataset)/K);
for i = 1:(length(ordered_dataset)/K)
    final_dataset(:,:,i) = tril(new_ordered_dataset(:,:,i),-1);
end


%save final_dataset

%save new_ordered_dataset;
 
%sub_dataset = sort(sub_dataset);
figure(1)
transmitter = 1;
receiver = 3;
TXOpposite = receiver; 
RXOpposite = transmitter;

transmitterIndex = find(datasetNew(:,2) == transmitter);
receiverIndex = find(datasetNew(transmitterIndex,receiver+2));
overallIndex = transmitterIndex(receiverIndex);
receiverData = datasetNew(overallIndex,receiver+2);
timeHour = (datasetNew(overallIndex,1))/60;

TXOppositeIndex = find(datasetNew(:,2) == TXOpposite);
RXOppositeIndex = find(datasetNew(TXOppositeIndex,RXOpposite+2));
overallOppositeIndex = TXOppositeIndex(RXOppositeIndex);
RXOppositeData = datasetNew(overallOppositeIndex,RXOpposite+2);
timeHour1 = (datasetNew(overallOppositeIndex,1))/60;

plot(timeHour,receiverData, 'b-o', 'LineWidth', 1.5);
hold on; 
plot(timeHour1,RXOppositeData, 'r-o', 'LineWidth', 1.5);
% ylim([-30 0]);
% xlim([0 5]);
name = ['Transmitter = ', num2str(transmitter), ', Receiver = ', num2str(receiver), ', Data Points = ',num2str(length(receiverData))];
title('RSSI of the Receivers (Professor Murch Room)')
ylabel('RSSI (dBm)');
xlabel('Time');
detail_1 = ['Rx = ', num2str(receiver), ', Tx = ', num2str(transmitter)];
detail_2 = ['Rx = ', num2str(transmitter), ', Tx = ', num2str(receiver)];
legend(detail_1, detail_2);
grid on
set(gcf,'color','w');

