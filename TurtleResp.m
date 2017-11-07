function TurtleResp(data,sign,filename)
% Inputs:
%        data = column of venous pressure data (or signal from which you
%        want to detect peaks)
%        sign = positive or negative 
%        filename = output file name
%
% Output: filename.txt file of [peak height | peak loc | time to next peak]

% if data are more than one column, take the sensor data only (not time)
if size(data,2) > 1
    data = data(:,2);
end

% get sampling frequency
fs = 1./(data(2,1)-data(1,1));

% detect peaks
[pks,locs] = findpeaks(data(:,2),data(:,1), ...
    'MinPeakProminence',2,'MinPeakHeight',2,'MinPeakDistance',0.5);

% plot data
figure(1)
plot(data(:,1),data(:,2),'b',locs,pks,'*r'), grid
xlabel('Time (sec)'), ylabel('cm H_20'), title('turtle p2')

% get inter-resp interval
Interval = diff(locs);
Interval(length(Interval)+1) = 0; % no time to next breath for last event

%% load data
load('turtlep10')

% get sampling frequency
fs = 1./(data(2,1)-data(1,1));

% detect peaks
[pks,locs] = findpeaks(-data(:,2),data(:,1), ...
    'MinPeakProminence',2,'MinPeakHeight',2,'MinPeakDistance',0.5);

% plot data
figure(2)
plot(data(:,1),-data(:,2),'b',locs,pks,'*r'), grid
xlabel('Time (sec)'), ylabel('cm H_20')
axis ij, title('turtle p10')

% get inter-resp interval
Interval = diff(locs);
iInterval = 60./Interval;

figure(3)
spectrogram(data(:,2),fs,'yaxis'), colorbar off

%% load data
load('turtlep10txt')

[pks,locs] = findpeaks(-data(:,2), ...
    'MinPeakProminence',4,'MinPeakHeight',2,'MinPeakDistance',0.3);

figure(3), clf, hold on
plot(1:length(data),data(:,2),'b',locs,-pks,'*r'), grid

% find peaks below a certain threshold tha tare likely movement or
% electrical noise
kp = find(pks < 10); % can set threshold or can try quantile(data(:,2),0.99); (99th quantile of dataset)

plot(locs(kp),-pks(kp),'g*')

% keep only those peaks
locs = locs(kp); pks = pks(kp);

% get inter-peak interval
Interval = diff(locs);

% for output: 
output(:,1) = pks; 
output(:,2) = locs;
output(:,3) = Interval;