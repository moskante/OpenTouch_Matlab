%% trialsindex for durationaggregate
mySP=[300:250:1800];
myLR=[6000 12000];
speedIndex = find(mySP == 300:250:1800); %which speed from 1-7   see [300  1050   1800  2550  3300  4050  4800]
distanceIndex = (abs(myLR)/6000);    %0 for 6000 myLR, 1 for 12000 myLR
%trialIndex =(speedIndex+(distanceIndex*7)); % +7 for 12000 distance,+0 for 6000 ->1-14 vector

%%actual mean durations 1:7 for 6000, then 1:7 for 12000
% computed with 'beltspeed_calib'
actualDurations = ...
[0.48, 0.33, 0.28, 0.26, 0.25, 0.25, 0.25,   0.84, 0.51, 0.40, 0.34, 0.30, 0.29, 0.28];
    
%duration quotient (how much longer is the actual duration than its
%theoretical duration)
durationQuotients = ...
[1.20, 1.51, 1.84, 2.30, 2.68, 3.01, 3.70,   1.06, 1.17, 1.33, 1.46, 1.64, 1.92, 2.11];

%theoretical duration
for n= 1:length(mySP)
    for m= 1:length(myLR)
        theoreticalDuration(n+((m-1)*7)) = [(myLR(m)/15000)./(mySP(n)/300)];
    end 
end
