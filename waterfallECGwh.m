function [beats] = waterfallECGwh(H,HR,breaths,I,B,wh)

% H is the time of beats 
% HR is the instantaneous HR at that time 
% breaths is the audit structure of breath times 
% I is the index of sorted whistles based on time of breath
% B is the time since the breath for each whistle 
% wh is the time of the whistles

% truncate HR at each breath time
for i = 1:length(wh)
    if i == length(breaths.cue)
        ii = find(H(:,1)>breaths.cue(i,1));
    else
        ii = iswithin(H(:,1),[breaths.cue(i,1) breaths.cue(i+1,1)]);
    end
    beats(i).breath = H(find(ii),1);
    beats(i).HR = HR(find(ii));
    if ~isempty(beats(i).breath)
        beats(i).breath = beats(i).breath - breaths.cue(i,1);
    end
end

% put whistle cues on figure 1
for i = 1:length(wh)
    text(wh(i),120,num2str(i))
end

% waterfall through time
figure(102), clf, hold on
% waterfall(beats.breath) 
% sort by I
for i = 1:length(wh) % for each whistle in order
     plot3(repmat(i,length(beats(I(i)).breath),1),beats(I(i)).breath,beats(I(i)).HR)
end
plot3(1:length(B),B,zeros(length(B))+60,'ko')
zlabel('Instantaneous HR (BPM)'), ylabel('Time (sec)')
xlabel('Ordered Whistle Number')

