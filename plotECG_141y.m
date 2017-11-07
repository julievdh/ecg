% load ECG data

% import ECG data 
cd C:\tag\tagdata\ecg
V1 = load('tt17_141y_ecg_test'); % for 141y, combine two ecg .mat files
V2 = load('tt17_141y_ecg_comb');

R = V1.R; % because R should be the same
%% find all sub-audits: breaths, inh, exh
[~,breaths] = findaudit(R,'breath');
[~,inh] = findaudit(R,'inh');
[~,exh] = findaudit(R,'exh');


figure(1), clf, hold on
% plot(R.cue(:,1),zeros(length(R.cue)),'ko')
plot(breaths.cue(:,1),zeros(length(breaths.cue)),'k.')
line([breaths.cue(:,1) breaths.cue(:,1)],[0 150],'color','k','linestyle',':')

% plot all inhales
if isempty(inh.cue) ~= 1
plot(inh.cue(:,1),zeros(length(inh.cue)),'bv')
line([inh.cue(:,1) inh.cue(:,1)],[0 150],'color','b')
end

% plot all exhales
if isempty(exh.cue) ~= 1
plot(exh.cue(:,1),zeros(length(exh.cue)),'g^')
line([exh.cue(:,1) exh.cue(:,1)],[0 150],'color','g')
end


%% calculate and plot HR
V1.HR = 60./diff(V1.H(:,1));
V2.HR = 60./diff(V2.H(:,1));

% find peaks/interruptions? how are those coded in the H matrix? 
% peak levels of -1 are null beats to use as breaks in HR plots
null = find(V1.H(:,2) == -1);
V1.H(null) = NaN; 
plot(V1.H(2:end,1),V1.HR,'r.-')

null = find(V2.H(:,2) == -1);
V2.H(null) = NaN; 
plot(V2.H(2:end,1),V2.HR,'b.-')
% plot individual beats if you want
% plot(H(:,1),zeros(length(H),1)+80,'*')
