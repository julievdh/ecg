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

%% try this for the Interpolated data
% find the bad cues and replace with NanN
% hydrophone beats
if exist('T') == 1
    for i = 1:length(startbad)
        bad = find(iswithin(T,[startbad(i)-0.5 endbad(i)]+offset));
        sHhr(bad) = NaN;
    end
    % NaN out before signal actually starts
    sHhr(T < Hhbn(1)+offset) = NaN;
    
    % check:
    figure(10), plot(T,sHhr,'g.-')
    
    % dtag JNO beats
    for i = 1:length(startbad_tag)
        bad = find(iswithin(T,[startbad_tag(i)-0.5 endbad_tag(i)]));
        sDTAGhr(bad) = NaN;
    end
    % NaN out before signal actually starts
    sDTAGhr(T < DTAGhbn(1)) = NaN;
    sDTAGhr(T > DTAGhbn(end)) = NaN; 
    
    % check:
    figure(10), plot(T,sDTAGhr,'m.-')
    
    % DTAG jvdh
    null = find(H(:,2) == -1);
    nullT = nearest(T',null);
    sHR(nullT) = NaN;
    sHR(T < Hn(1)) = NaN; sHR(T > Hn(end,1)) = NaN; % Nan outside of signal
    
end