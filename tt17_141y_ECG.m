clear

% set H as empty, fill when import if exist
H = [];
warning off

% import ECG data 
cd C:\tag\tagdata\ecg
V1 = load('tt17_141y_ecg'); % for 141y, combine two ecg .mat files
V2 = load('tt17_141y_ecg2');

% find HR
H = findhr(ecgfilt,ecgfilt_fs,[0.25 0.2],H);

% backup = H;

HR=60./diff(H(:,1));
cd C:\tag\tagdata\ecg
save(strcat(tag,'_ecg'),'ecgfilt','ecgfilt_fs','DEPLOY','H','tag');
