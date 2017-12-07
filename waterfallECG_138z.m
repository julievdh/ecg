% truncate HR at each breath time
% combine breaths and chuffs
list = [1:23,25:26];
allbreaths.cue = [breaths.cue(list,:); chuff.cue]; allbreaths.cue = sort(allbreaths.cue);
clear beats
for i = 1:length(allbreaths.cue)
    if i == length(allbreaths.cue)
        ii = find(H(:,1)>allbreaths.cue(i,1));
    else
        ii = iswithin(H(:,1),[allbreaths.cue(i,1) allbreaths.cue(i+1,1)]);
    end
    beats(i).breath = H(find(ii),1);
    beats(i).HR = HR(find(ii));
    if ~isempty(beats(i).breath)
        beats(i).breath = beats(i).breath - allbreaths.cue(i,1);
    end
end

% put breath cues on figure 1
for i = 1:length(allbreaths.cue)
    text(allbreaths.cue(i,1),120,num2str(i))
end

% waterfall through time
figure(2), clf, hold on
% waterfall(beats.breath)
for i = 1:length(beats)-1
    plot3(repmat(i,length(beats(i).breath),1),beats(i).breath,beats(i).HR)
end

%% data from Andreas
data = [1	3.9	3.6
    2	3.6	3.9
    3	2.9	3.3
    4	3.2	3.25
    5	3	3
    6	2.6	2.6
    7	4.2	4.5
    8	3	3.3
    9	2.5	3.8
    10	4	3.6
    11	3.5	4
    12	3.9	4
    13	3.7	3.1
    14	3.5	3.5
    15	3.9	3.8
    16	3.2	3.9
    17	11	6.2
    18	7.4	7.3
    19	7.7	6.7]; % breath number; VT exp; VT insp % breath 1 = 308 seconds

%% have pneumotach for breaths 9:24 and 3 chuffs
for i = 1:length(allbreaths.cue)
    text(allbreaths.cue(i,1),120,num2str(i))
end

%% for each beat segment calculate initial to max
% plot to check
for i = [9:27]
    if ~isempty(beats(i).HR)
        [mxv,mxi] = max(beats(i).HR);
        beats(i).diff = mxv - beats(i).HR(1);
        plot3([i i],[beats(i).breath(mxi) beats(i).breath(mxi)],[mxv mxv-beats(i).diff],'b')
    end
end

%% calculate amplitudes differently

[MAXTAB, MINTAB] = peakdet(HR, 10);
figure(1)
plot(H(MAXTAB(:,1)),MAXTAB(:,2),'o')
plot(H(MINTAB(:,1)),MINTAB(:,2),'o')

for i = 1:length(allbreaths.cue)-1
    % find nearest min value
    [kmin,ind] = nearest(H(MINTAB(:,1),1),allbreaths.cue(i,1),10);
    if ~isnan(kmin)
        plot(H(MINTAB(kmin,1)),MINTAB(kmin,2),'s','markersize',20)
    end
    % find nearest max value
    [kmax,ind] = nearest(H(MAXTAB(:,1),1),allbreaths.cue(i,1),10,1);
    if ~isnan(kmax)
        plot(H(MAXTAB(kmax,1)),MAXTAB(kmax,2),'s','markersize',20)
    end
    % store
    if ~isnan(kmax)
    amp(i) = MAXTAB(kmax,2)-MINTAB(kmin,2);
    end
end

%% correlate with measured VT
figure(3), clf, hold on
plot(amp(9:27),data(:,2),'^')
plot(amp(9:27),data(:,3),'v')

% add data labels
%for i = 1:19, text(amp(i+8),data(i,2)+0.5,num2str(i))
%end
xlabel('Delta BPM'), ylabel('Tidal Volume'),legend('Exhaled','Inhaled')

%% plot regular breaths and correlate
figure(4), clf, hold on
plot(amp(9:23),data(1:15,2),'^')
plot(amp(9:23),data(1:15,3),'v')

for i = 1:15, text(amp(i+8),data(i,2)+0.5,num2str(i))
end
xlabel('Delta BPM'), ylabel('Tidal Volume'),legend('Exhaled','Inhaled')

[curvefit_exh,gof_exh] = fit(amp(9:23)',data(1:15,2),'poly1')
