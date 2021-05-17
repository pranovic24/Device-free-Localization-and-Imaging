% Read Water WiFi measure data

clear all
sta_max=20;

file ='log - (1500hrs-20-05-2020).txt';
A=importdata(file);
RSSI=A.data;
words=A.textdata;

% time calculation

hours_string=char(words(:,1));
hours=str2num(hours_string(:,2:3));

minutes_string=char(words(:,2));
minutes=str2num(minutes_string(:,1:2));

seconds_string=char(words(:,3));
seconds=str2num(seconds_string(:,1:2));

mseconds_string=char(words(:,4));
mseconds=str2num(mseconds_string(:,1:2));

t=minutes*60+seconds+mseconds/100;

% RSSI processing

L=length(RSSI);
sta_string=char(words(:,5));
sta=str2num(sta_string(:,8:9));

type_string=char(words(:,4));
type=double((type_string(:,9))-70)/13;

%cAP1=find(-(type-1).*sta==1);

AP=find(type==0);
LAP=length(AP);
dAP=[AP(2:LAP)-AP(1:(LAP-1))-1;L-AP(LAP)];


% make up 2D array with the measurement data

measure=-100*ones(LAP,sta_max+2);
measure(:,1)=t(AP);
measure(:,2)=sta(AP);
for n = 1:LAP
    points=((AP(n)+1):( AP(n)+dAP(n) ))';
    measure(n,sta(points)+2)=RSSI(points);
end


% error checking

for m=1:sta_max
    sta_m=(find(measure(:,2)==m));
    sta_scan(m)=length(sta_m);
    AP_n=length(find(measure(:,m+2)>-100));
    AP_obs(m)=AP_n;
end

figure(1)
plot(AP_obs)
title('AP obs')
grid

figure(2)
plot(sta_scan)
title('sta scan')
grid


n=1;
[sta_min m]=min(sta_scan);
%m=22;
sta_m = find(measure(:,2)==m);
hmn=measure(sta_m,n+2);

if sta_m
    tm=(measure(sta_m,1))/60;
    max(tm)
else 
    hmn=0;
    tm=0;
    tm
end
[m n]

% received signals at Rx m=min due to Tx signal at n=1

figure(3)
plot(tm,hmn)
name = ['Rx ', num2str(m), ' Tx ', num2str(n)];
title(name)
grid

% Tx signals from m=min Rx by all others

figure(4)
plot(measure(:,1)/60,measure(:,m+2))
name = ['Tx n= ', num2str(m)];
title(name)
xlabel('minutes')
grid

% Plot only Tx signals from m=min Rx by all others

n=3;
m=10;

sta_m = find(measure(:,2)==m);
x=find(measure(sta_m,n+2)>-100);
sta_m_m100=sta_m(x);
hmn=measure(sta_m_m100,n+2);
tm=(measure(sta_m_m100,1))/60;

% reciprocal

mm=m;
m=n;
n=mm;
sta_m = find(measure(:,2)==m);
x=find(measure(sta_m,n+2)>-100);
rsta_m_m100=sta_m(x);
rhmn=measure(rsta_m_m100,n+2);
rtm=(measure(rsta_m_m100,1))/60;

% Plot only received signals at Rx m due to Tx at n

figure(5)
%plot(tm,medfilt1(hmn,5,'truncate'),rtm,medfilt1(rhmn,5,'truncate'),'r')
plot(tm,hmn,rtm,rhmn,'r')
name = ['Rx ', num2str(m), ' Tx ', num2str(n), ' points = ',num2str(length(hmn))];
title(name)
xlabel('minutes')
ylabel('Rx dBm (Tx at 19.5 dBm)') 
grid


figure(6)
plot(tm,medfilt1(hmn,5,'truncate'),rtm,medfilt1(rhmn,5,'truncate'),'r')
%plot(tm,hmn,rtm,rhmn,'r')
name = ['Rx ', num2str(m), ' Tx ', num2str(n), ' points = ',num2str(length(hmn))];
title(name)
xlabel('minutes')
ylabel('Rx dBm (Tx at 19.5 dBm)') 
grid



