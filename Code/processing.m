clear all;
clc; close all;

K = 20;

file = 'log - (1500hrs-20-05-2020).txt';
A = importdata(file);
RSSI = A.data;
words = A.textdata;

% time calculation

hours_string = char(words(:,1));
hours = str2num(hours_string(:,2:3));

minutes_string = char(words(:,2));
minutes = str2num(minutes_string(:,1:2));

seconds_string = char(words(:,3));
seconds = str2num(seconds_string(:,1:2));

mseconds_string = char(words(:,4));
mseconds = str2num(mseconds_string(:,1:2));

t = minutes*60+seconds+mseconds/100;

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

dataset = 10.^(dataset_dB/10);
%datapoints = sum(~isnan(dataset_dB))

%RSSI_mean = nanmean(dataset);

RSSI_mean = repmat(nanmean(dataset), size(dataset, 1), 1);

dataset(isnan(dataset)) = RSSI_mean(isnan(dataset));

dataset_dB_new = 10*(log10(dataset))/(log10(10));

result = [t(RSSIIndex), dataset_dB_new];

% plot(final_dataset(:,1)/60, final_dataset(:,24), 'b-o', 'LineWidth', 1.5)
% % hold on
% % plot(final_dataset(:,1)/60, final_dataset(:,7), 'r-o', 'LineWidth', 1.5)
% ylabel('RSSI (dBm)');
% xlabel('Time');
% title('RSSI vs. Time');
% grid on;
% legend('ESP32 - Node 1', 'ESP32 - Node 6')
% set(gcf,'color','w');

% save jehiel_pranay

