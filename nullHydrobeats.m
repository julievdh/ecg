% null out bad sections in hydrophone record
for i = 1:length(startbad)
bad = find(iswithin(Hhb,[startbad(i) endbad(i)])); 
Hhb(bad) = NaN; 
end

% null out bad sections in DTAG record
for i = 1:length(startbad_tag)
bad = find(iswithin(DTAGhb,[startbad_tag(i) endbad_tag(i)])); 
DTAGhb(bad) = NaN; 
end