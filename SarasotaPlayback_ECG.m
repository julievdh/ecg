clear

% set H as empty, fill when import if exist
H = [];
warning off

% import ECG data 
cd C:\tag\tagdata\ecg
load('tt132y_ecgthr'); % for 141y, combine two ecg .mat files

% load audit
R = loadaudit(tag) 

% find HR
H = findhr(-ecgfilt,ecgfiltfs,[0.25 0.2],H);

% backup = H;

HR=60./diff(H(:,1));
cd C:\tag\tagdata\ecg
save(strcat(tag,'_ecg'),'ecgfilt','ecgfiltfs','DEPLOY','H','tag','R');
