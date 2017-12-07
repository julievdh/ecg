% combine signals where have all three
% use median of each

%% try something new
% make a time vector
T = min([min(H(:,1)) min(DTAGhb) min(Hhb)+offset]):0.5:max([max(H(:,1)) max(DTAGhb) max(Hhb)+offset]);

% remove NaNs
HRn = HR(~isnan(HR),:);
Hn = H(~isnan(HR),:);

DTAGhbn = DTAGhb(~isnan(DTAGhr)); 
DTAGhrn = DTAGhr(~isnan(DTAGhr)); 

Hhrn = Hhr(~isnan(Hhr));
Hhbn = Hhb(~isnan(Hhr));

% interpolate each time series at those points 
sHR = interp1(Hn(:,1),HRn,T,'spline');
sDTAGhr = interp1(DTAGhbn,DTAGhrn,T,'spline');
sHhr = interp1(Hhbn+offset,Hhrn,T,'spline'); 

figure(10), clf, hold on
plot(T,sHR,'.-')
plot(T,sDTAGhr,'.-')
plot(T,sHhr,'.-')

% put the NaNs back in 


% take median of all three 
all3 = nanmedian([sHR' sDTAGhr' sHhr']');

plot(T,all3,'ko-')


return 


% make a time vector
T = min([min(H(:,1)) min(DTAGhb) min(Hhb)+offset]):0.2:max([max(H(:,1)) max(DTAGhb) max(Hhb)+offset]);
% find nearest value in JVDH DTAG record
nearestD1 = nearest(H(:,1),T',0.1); 
% find nearest in other DTAG record
nearestD2 = nearest(DTAGhb(:,1),T',0.1);
% find nearest in Hydrophone
nearestH = nearest(Hhb+offset,T',0.1);

%% take median
medHR = nan(length(T),1);

all3 = [nearestD1 nearestD2 nearestH];
ii = find(~isnan(nearestD1)); 
all3(ii,1) = HR(nearestD1(ii));
ii = find(~isnan(nearestD2)); 
all3(ii,2) = DTAGhr(nearestD2(ii));
ii = find(~isnan(nearestH)); 
all3(ii,3) = Hhr(nearestH(ii));

medHR = nanmedian(all3'); 
plot(T(~isnan(medHR)),medHR(~isnan(medHR)),'ko-');

return 

%% 
for i = 1:length(H)-1
    if ~isnan(nearestD2(i)) & ~isnan(nearestH(i)) == 1
        medtime(i,1) = median([H(i+1,1),DTAGhb(nearestD2(i)+1,1),Hhb(nearestH(i)+1)+offset]);
        medHR(i,1) = median([HR(i,1),DTAGhr(nearestD2(i)),Hhr(nearestH(i))]);
    else
        if ~isnan(nearestD2(i)) == 1 % if DTAG measurement only exists
            medtime(i,1) = median([H(i+1,1),DTAGhb(nearestD2(i)+1,1)]);
            medHR(i,1) = median([HR(i,1),DTAGhr(nearestD2(i))]);
        else
            if ~isnan(nearestH(i)) == 1 % if hydrophone measurement only exists
                medtime(i,1) = median([H(i+1,1),Hhb(nearestH(i)+1)+offset]);
                medHR(i,1) = median([HR(i,1),Hhr(nearestH(i))]);
            else if isnan(nearestH(i)) +  isnan(nearestD2(i)) == 2
                    medtime(i,1) = H(i+1,1);
                    medHR(i,1) = HR(i,1);
                end
            end
        end
    end
end

plot(medtime,medHR,'k-','LineWidth',2)