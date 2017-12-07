% null out bad sections in hydrophone record
Hhb(end+1:end+length(startbad)) = startbad+0.5; % put the bad cues in the vector
Hhb(end+1:end+length(endbad)) = endbad-0.5; % put the bad cues in the vector
Hhb = sort(Hhb); 
% find the bad cues and replace with NanN
for i = 1:length(startbad)
bad = find(iswithin(Hhb,[startbad(i)-0.5 endbad(i)])); 
Hhb(bad) = NaN; 
end

% null out bad sections in DTAG record
for i = 1:length(startbad_tag)
bad = find(iswithin(DTAGhb,[startbad_tag(i)-0.5 endbad_tag(i)])); 
DTAGhb(bad) = NaN; 
end