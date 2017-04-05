
clear  
% hdd = 'G'; % I save my data on a hard drive –this just tells what drive 

% next I assign a prefix (file name) and directory (you will need to make this fit your data) 
prefix = 'ts17_094a'
recdir = ['\\uni.au.dk\Users\au575532\Documents\MATLAB\tag'];

X=d3readswv(recdir,prefix); %reads in file
 ecg=X.x{6}; %creates a vector of ECG data (it is found in column six of cell array X.x)
 
fs=X.fs(6); %Identifies sampling rate of ECG data in column 6 

 [y1,yfs] = ecgcleanup2(ecg,fs); %run ecgcleanup to remove electrical noise and clean up

 % run butter filter to clean up a bit more
 
 [B,A]=butter(4,[0.1 0.3]); 
y=filter(B,A,y1);
figure
plott(y,yfs)
