% combine signals where have all three
% use median of each


% find nearest in other DTAG record
nearestD = nearest(DTAGhb(:,1),H(:,1),0.2);
% find nearest in Hydrophone
nearestH = nearest(Hhb+offset,H(:,1),0.2);
% take median
medtime = nan(length(H),1);
medHR = nan(length(H),1);
for i = 1:length(H)-1
    if ~isnan(nearestD(i)) & ~isnan(nearestH(i)) == 1
        medtime(i,1) = median([H(i+1,1),DTAGhb(nearestD(i)+1,1),Hhb(nearestH(i)+1)+offset]);
        medHR(i,1) = median([HR(i,1),DTAGhr(nearestD(i)),Hhr(nearestH(i))]);
    else
        if ~isnan(nearestD(i)) == 1 % if DTAG measurement only exists
            medtime(i,1) = median([H(i+1,1),DTAGhb(nearestD(i)+1,1)]);
            medHR(i,1) = median([HR(i,1),DTAGhr(nearestD(i))]);
        else
            if ~isnan(nearestH(i)) == 1 % if hydrophone measurement only exists
                medtime(i,1) = median([H(i+1,1),Hhb(nearestH(i)+1)+offset]);
                medHR(i,1) = median([HR(i,1),Hhr(nearestH(i))]);
            else if isnan(nearestH(i)) +  isnan(nearestD(i)) == 2
                    medtime(i,1) = H(i+1,1);
                    medHR(i,1) = HR(i,1);
                end
            end
        end
    end
end

plot(medtime,medHR,'k-','LineWidth',2)