% null out bad sections in hydrophone record
for i = 1:length(startbad)
bad = find(iswithin(Hhb,[startbad(i) endbad(i)])); 
Hhb(bad) = NaN; 
end
