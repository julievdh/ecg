% Catherine Turtle Data

% load data
load('turtlep2')

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
iInterval = 60./Interval;

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