

%% Remember to adjust: st, ed, & th
% This is for: line 28: y(ufy>th)=0;  AND line 46+47: y(ed*yfs:end)=0;

st = 600;     % start time of good section - for Beedholms second approach
ed = 1558;     % end time of good section - for Beedholms second approach
strt = 61.0120; % The time of the first radiosignal. (for plotting radio timings)
th = 0.5;    % threshold for y-value, above which data will be "deleted". (to delete large peaks)

badf = 1/0.4545; % ~Frequency of radiosignal (not exact)


tag = 'tt17_132x';
prefix = strcat(tag(1:2),tag(6:9));
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);


% read in the file
%X = d3parseswv(filedir); % THIS IS FOR ONE SWV FILE AT A TIME
X = d3readswv(recdir,prefix); % reads in the ecg of the entire deployment. Prefix excluding fileno.

%look up file names and then extract the ecg signal and fs
d3channames(X.cn);
ecg = X.x{12};
fs = X.fs(12);

[y, yfs] = ecgcleanup2new(ecg,fs);
figure(1), clf
plott(y,yfs,'b')

%% Beedholms first approach (cut off large signals = radio peaks)

% ufy=abs(hilbert(y));
% y(ufy>th)=0;   %threshold (th) set in the top of the script
% 
% [B,A] = butter(4, [0.1 0.3]);
% y=filter(B,A,y);
% 
% figure
% plott(y,yfs)

%% Beedholms second approach (need st and ed of ecg period and badf)
% clf
ol=length(y);

NL=2^22;

if ol<NL;
    y(NL)=0;
end;

oy=y;
y(1:st*yfs)=0;       % limits to good signal
y(ed*yfs:end)=0;     % limits to good signal

Y=fft(y);
OY=Y;
zr=-200:200;
zw=1-hanning(length(zr));
% clf
hold on
for k=1:floor(yfs/3/badf)
    zntr=round(k*badf/yfs*NL)+zr;
    Y(zntr)=Y(zntr).*zw;
end;

Y(NL/2+1:end)=0;
y=2*real(ifft(Y));
y=y(1:ol);

hold on, plott(y,yfs)

return 

%% get UTC time
% [CAL,DEPLOY] = d3loadcal(tag);
R = loadaudit(tag);

DEPLOY.TAGON.TIME = [2017 5 12 14 29 16];
DEPLOY.UTC2LOC = -4;
UTC = DEPLOY.TAGON.TIME(4:6) + [DEPLOY.UTC2LOC 0 0] ;

plotecgaudit_time(y,yfs,UTC,R);

% rename
ecgfilt = y;
ecgfiltfs = yfs;

%% Save y and yfs
ecgdir='C:\tag\tagdata\ecg';

save(fullfile(ecgdir,[prefix '_ecgthr.mat']),'ecgfilt', 'ecgfiltfs', 'st', 'ed', 'th','DEPLOY','tag');

return
%%
k=yfs*st:yfs*ed;
%H=findhr_siri(y(k),yfs,st,ed,strt); %played around with plotting radio timing
H=findhr(y(k),yfs);

H=H+st;

HR=60./diff(H(:,1));
figure, plot(H(1:length(H)-1),HR,'bo-')

%hrdir='/Users/sirielmegard/Documents/MATLAB/siri_HRdata/fieldHB';
%save(fullfile([hrdir '/' prefix '_hb']),'H', 'HR');
