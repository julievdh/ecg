%% find all sub-audits: breaths, inh, exh
[~,breaths] = findaudit(R,'breath');
[~,inh] = findaudit(R,'inh');
[~,exh] = findaudit(R,'exh');
[~,chuff] = findaudit(R,'chuff');
[~,pneum] = findaudit(R,'pneum');

%%
figure(101), clf, hold on
% plot(R.cue(:,1),zeros(length(R.cue)),'ko')
plot(breaths.cue(:,1),zeros(length(breaths.cue)),'k.')
for i = 1:length(breaths.cue)
line([breaths.cue(i,1) breaths.cue(i,1)],[0 150],'color','k','linestyle',':')
end

if isempty(inh.cue) ~= 1
    % plot all inhales
    plot(inh.cue(:,1),zeros(length(inh.cue)),'bv')
    line([inh.cue(:,1) inh.cue(:,1)],[0 150],'color','b')
end

if isempty(exh.cue) ~= 1
    % plot all exhales
    plot(exh.cue(:,1),zeros(length(exh.cue),1),'g^')
    line([exh.cue(:,1) exh.cue(:,1)],[0 150],'color','g')
end

if isempty(chuff.cue) ~= 1
    % plot all chuffs
    for c = 1:length(chuff.cue)
        plot(chuff.cue(:,1),zeros(length(chuff.cue)),'r^')
        line([chuff.cue(c,1) chuff.cue(c,1)],[0 150],'color','r')
    end
end

if isempty(pneum.cue) ~= 1
    % plot pneumotach on
    for c = 1:size(pneum.cue,1)
        plot([pneum.cue(c,1) pneum.cue(c,1)],[0 150],'y--')
    end
end


%% find peaks/interruptions? how are those coded in the H matrix?
% peak levels of -1 are null beats to use as breaks in HR plots
null = find(H(:,2) == -1);
H(null) = NaN;

% calculate and plot HR
HR = 60./diff(H(:,1));

plot(H(1:end-1,1),HR,'r.-')
ylabel('Instantaneous HR'), xlabel('Time since tag on (s)')

% plot individual beats if you want
% plot(H(:,1),zeros(length(H),1)+80,'*')

