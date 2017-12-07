% truncate HR at each breath time
for i = 1:length(breaths.cue)
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

% put breath cues on figure 1
for i = 1:length(breaths.cue)
    text(breaths.cue(i,1),120,num2str(i))
end

% waterfall through time
figure(2), clf, hold on
% waterfall(beats.breath)
for i = 1:length(beats)-1
    plot3(repmat(i,length(beats(i).breath),1),beats(i).breath,beats(i).HR)
end