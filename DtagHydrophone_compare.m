% ECG HR comparison with Julie Oswald
% 6 Dec 2017

% load data
cd C:\tag\tagdata\ecg
load('tt17_130w_ecg') % ecg detections from JvdH
load('DtagHydrophone_130w_ecg') % ecg detections from JNO

R = loadaudit(tag); % audit data 

%% remove any DTAG beats > 890
H(H>890,1) = NaN; 
DTAGhb(DTAGhb>890) = NaN; 
% null out bad sections
nullHydrobeats

%% plot JVDH DTAG data
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

%% Align datasets based on whistle times
% whistles are numbered and aligned, but have more Hwh than DTAGwh
offset = mean(DTAGwh - Hwh(1:length(DTAGwh))); 
% Hydrophone is *offset* more than DTAG
%% plot whistles from Chest Hydrophone
plot(Hwh(:,1)+offset,zeros(length(Hwh)),'b*')
for i = 1:length(Hwh)
    plot([Hwh(i,1)+offset Hwh(i,1)+offset],[0 150],'b--')
end

%% plot HR from Chest Hydrophone

Hhr = 60./diff(Hhb(:,1));
plot(Hhb(2:end,1)+offset,Hhr,'.-') % plot instantaneous HR on top


%% for each whistle, plot the iHR for a time before and after
figure(2), clf, hold on
% find nearest heart beat to whistle
nearestH = nearest(H(:,1),DTAGwh); 
th = 4; 
for i = 1:length(DTAGwh)-1
plot(H(nearestH(i)-th:nearestH(i)+th,1)-H(nearestH(i)),HR(nearestH(i)-th:nearestH(i)+th),'.-') % center on zero
end
xlabel('Time relative to whistle (sec)')
ylabel('Instantaneous HR (BPM)')
title('DTAG JvdH')

%% Plot DTAG JNO DtagHR -- SOMETHING NOT WORKING HERE
figure(3), clf, hold on
% find nearest heart beat to whistle
nearestDh = nearest(DTAGhr(:,1),DTAGwh); 
th = 4; 
for i = 1:length(DTAGwh)-1
plot(DTAGhb(nearestDh(i)-th:nearestDh(i)+th,1)-DTAGhb(nearestDh(i)),DTAGhr(nearestDh(i)-th:nearestDh(i)+th),'.-') % center on zero
end
xlabel('Time relative to whistle (sec)')
ylabel('Instantaneous HR (BPM)')
title('DTAG JNO')

