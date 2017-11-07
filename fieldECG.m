% Field HR ECG 

%%
tag = 'tt17_132z';
prefix = 'tt132z';
recdir = ['D:/tt17/tt17_132z'];
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
figure(2), plott(-ecgfilt,ecgfilt_fs)

return 

save(strcat(tag,'_ecg'),'ecgfilt','ecgfilt_fs','DEPLOY');

%% plot audit cues on top
% right now don't have cal file for tag, so can't make CAL or DEPLOY 
% cludge this a bit
DEPLOY.TAGON.TIME = [2017 5 9 17 59 46];
DEPLOY.UTC2LOC = -4;
UTC = DEPLOY.TAGON.TIME(4:6) + [DEPLOY.UTC2LOC 0 0] ;

%% plot ECG as function of time of day

% add audited cues
R = loadaudit(tag);

plotecgaudit_time(ecgfilt,ecgfilt_fs,UTC,R);

% figure, hold on
breaths=findaudit(R,'breath');
plott(ecgfilt,ecgfilt_fs)
plot(breaths(:,1),zeros(length(breaths)),'o','MarkerFaceColor','k','MarkerSize',4)


% plot lines for all VHF pings

hold on
% plot([276.8014 276.8014],[-0.8 08],'r:')
for i = 1:500
    % plot([276.8014+(2.25*i) 276.8014+(2.25*i)],[-0.8 0.8],'r:')
plot([292.5516+(2.25*i) 292.5516+(2.25*i)],[-0.8 0.8],'r:')
end
%% figure
%  
% figure
% plott(ecg,fs)
%  
 
%This extracts acceleration and pressure data to look at. 
a1 = X.x{7};
a2 = X.x{8};
a3 = X.x{9};
p = X.x{10};
 
figure
plott(a1, 625)
hold on
plott(a2,625)
plott(a3,625)
%  
figure
plott(p,625)
