clear

%% Remember to adjust: st, ed, & th 
%This is for: line 28: y(ufy>th)=0;  AND line 46+47: y(ed*yfs:end)=0;

 st=1600;     % start time of good section - for Beedholms second approach
 ed=2100;     % end time of good section - for Beedholms second approach
 strt=1.53; % The time of the first radiosignal. (for plotting radio timings)
 th=0.05;    % threshold for y-value, above which data will be "deleted". (to delete large peaks)

 %badf=1/0.7998; % ~Frequency of radiosignal (not exact)
 
 
% prefix = 'Si15_330b';
% file = '002';
% 
% datadir = '/Volumes/SIRIS HEART/Siri_Porpoise/Fielddata/';
% filedir = [datadir prefix '/' prefix file];


tag = 'tt17_131z';
prefix = 'tt130z';
recdir = ['E:/tt17/tt17_130z'];

% settings from Siri:
% prefix='te16_333a';
% recdir='/Volumes/SIRIS HEART/TEST/test20161128/';


% read in the file
%X = d3parseswv(filedir); % THIS IS FOR ONE SWV FILE AT A TIME
X=d3readswv(recdir,prefix); % reads in the ecg of the entire deployment. Prefix excluding fileno.
 
%look up file names and then extract the ecg signal and fs
d3channames(X.cn);
ecg = X.x{12};
fs=X.fs(12);

[y, yfs] = ecgcleanup2new(ecg,fs);


%% Beedholms first approach (cut off large signals = radio peaks)

ufy=abs(hilbert(y));
y(ufy>th)=0;   %threshold (th) set in the top of the script

[B,A] = butter(4, [0.1 0.3]);
y=filter(B,A,y);

figure
plott(y,yfs)

%% Beedholms second approach (need st and ed of ecg period and badf)
%clf
% ol=length(y);
% 
% NL=2^22;
%
% if ol<NL;
%     y(NL)=0;
% end;
% 
% oy=y;
% y(1:st*yfs)=0;       %limits to good signal
% y(ed*yfs:end)=0;    %limits to good signal
% 
% Y=fft(y);
% OY=Y;
% zr=-200:200;
% zw=1-hanning(length(zr));
% clf
% hold on
% for k=1:floor(yfs/3/badf)
%     zntr=round(k*badf/yfs*NL)+zr;
%     Y(zntr)=Y(zntr).*zw;
% end;
% 
% Y(NL/2+1:end)=0;
% y=2*real(ifft(Y));
% y=y(1:ol);
%
%figure, plott(y,yfs)

%% This extracts acceleration and pressure data to look at.
% a1 = X.x{7};
% a2 = X.x{8};
% a3 = X.x{9};
% pr = X.x{10};

%% Save y and yfs

ecgdir='/Users/sirielmegard/Documents/MATLAB/siri_HRdata/fieldecg';

save(fullfile(ecgdir,[prefix '_ecgthr.mat']),'y', 'yfs', 'st', 'ed', 'th');

%% 
k=yfs*st:yfs*ed;
%H=findhr_siri(y(k),yfs,st,ed,strt); %played around with plotting radio timing
H=findhr(y(k),yfs);

H=H+st;

HR=60./diff(H(:,1));
figure, plot(H(1:length(H)-1),HR,'bo-')

%hrdir='/Users/sirielmegard/Documents/MATLAB/siri_HRdata/fieldHB';
%save(fullfile([hrdir '/' prefix '_hb']),'H', 'HR');
