clear  

%% Open fielddata, run filters, create y and yfs.
% Remember to update prefix and date

prefix = 'ts17_081a'
recdir = ['\\uni.au.dk\Users\au575532\Documents\MATLAB\tag'];
%%
X=d3readswv(recdir,prefix); %reads in file
ecg=X.x{6}; %creates a vector of ECG data (it is found in column six of cell array X.x)
 
fs=X.fs(6); %Identifies sampling rate of ECG data in column 6 

[y1,yfs] = ecgcleanup2new(ecg,fs); %run ecgcleanup to remove electrical noise and clean up

% run butter filter to clean up a bit more 
[B,A]=butter(4,[0.1 0.3]); 
y=filter(B,A,y1);

figure;
plott(y,yfs)



%% Find Heart beats

%define start and end of ecg data
st= 1; 
ed= 450; 

k=yfs*st:yfs*ed;
H=findhr(y(k),yfs); % peak-finder, time points of heart beats.
HR=60./diff(H(:,1));
tid=H(:,1);
plot(tid(1:length(tid)-1),HR,'o-')
