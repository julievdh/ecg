% Field HR ECG

%%
tag = 'tt17_132y';
prefix = strcat(tag(1:2),tag(6:9));
recdir = strcat(gettagpath('AUDIO'),'/',tag(1:4),'/',tag);
%%
X = d3readswv(recdir,prefix); % reads in the ecg of the entire deployment. Prefix excluding fileno.

% look up file names and then extract the ecg signal and fs
d3channames(X.cn);
ecg = X.x{12};
fs=X.fs(12);

%Run a modified ecgcleanup
[y1, ecgfilt_fs] = ecgcleanup2new(ecg,fs);

%Run a butter filter ? this was often not needed.
[B,A] = butter(4, [0.1 0.3]);
ecgfilt=filter(B,A,y1);
figure(2), plott(ecgfilt,ecgfilt_fs)

%% plot audit cues on top
% right now don't have cal file for tag, so can't make CAL or DEPLOY
% cludge this a bit
 [CAL,DEPLOY] = d3loadcal(tag);
 DEPLOY.TAGON.TIME = [2017 5 12 20 15 42];
 DEPLOY.UTC2LOC = -10;
 R = loadaudit(tag);
% UTC = DEPLOY.TAGON.TIME(4:6) + [DEPLOY.UTC2LOC 0 0] ;

return
cd C:\tag\tagdata\ecg
save(strcat(tag,'_ecg'),'tag','ecg','fs','ecgfilt','ecgfilt_fs','DEPLOY','R');


%% plot ECG as function of time of day
%% load filtered ECG
cd C:\tag\tagdata\ecg
load(strcat(tag,'ecgthr'))
HR = 60./diff(H(:,1)); % calculate heart rate
HR(HR > 150) = NaN;
%% add audited cues
% load audit
R = loadaudit(tag);

% plotecgaudit_time(ecgfilt,ecgfilt_fs,UTC,R);

figure, hold on
breaths=findaudit(R,'breath');
plott(ecgfilt,ecgfilt_fs)
plot(breaths(:,1),zeros(length(breaths)),'ko','MarkerFaceColor','k','MarkerSize',4)

beats = findaudit(R,'beat');
plot(beats(:,1),zeros(length(beats)),'go','MarkerSize',4)

chuff = findaudit(R,'chuff');
plot(chuff(:,1),zeros(length(chuff)),'k*','MarkerSize',4)

exh = findaudit(R,'exh');
plot(exh(:,1),zeros(length(exh)),'k^','MarkerSize',4)

inh = findaudit(R,'inh');
plot(inh(:,1),zeros(length(inh)),'kv','MarkerSize',4)


figure(29), clf, hold on
plot(H(2:end,1),HR,'o-')
for i = 1:length(breaths)
    plot([breaths(i,1) breaths(i,1)] ,[0 120],'k')
    plot([breaths(i,1)+breaths(i,2) breaths(i,1)+breaths(i,2)] ,[0 120],'r')
end
for i = 1:length(chuff)
    plot([chuff(i,1) chuff(i,1)] ,[0 120],'k:')
    plot([chuff(i,1)+chuff(i,2) chuff(i,1)+chuff(i,2)] ,[0 120],'r:')
end
for i = 1:length(exh)
    plot([exh(i,1) exh(i,1)] ,[0 120],'g--')
    plot([exh(i,1)+exh(i,2) exh(i,1)+exh(i,2)] ,[0 120],'g--')
end
for i = 1:length(inh)
    plot([inh(i,1) inh(i,1)] ,[0 120],'b--')
    plot([inh(i,1)+inh(i,2) inh(i,1)+inh(i,2)] ,[0 120],'b--')
end