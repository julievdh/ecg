% ECG HR comparison with Julie Oswald
% 6 Dec 2017

% load data
cd C:\tag\tagdata\ecg
load('tt17_130w_ecg') % ecg detections from JvdH
load('DtagHydrophone_130w_ecg') % ecg detections from JNO

R = loadaudit(tag); % audit data 

plotthisECG % plot this instantaneous HR from DTAG JvdH

%% compute HR from Julie Oswald DTAG detections
% remove zeros from vector
DTAGhb(all(DTAGhb==0,2),:)=[]; 

DTAGhr = 60./diff(DTAGhb(:,1));
plot(DTAGhb(2:end,1),DTAGhr,'b.-') % plot instantaneous HR on top

%% add whistle times 
% from DTAG
plot(DTAGwh(:,1),zeros(length(DTAGwh)),'c*')
for i = 1:length(DTAGwh)
    plot([DTAGwh(i,1) DTAGwh(i,1)],[0 150],'c--')
end
