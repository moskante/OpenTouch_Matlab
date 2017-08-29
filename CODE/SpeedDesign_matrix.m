function desmat = SpeedDesign_matrix()

%rel_disp: proprtion of one round of the belt
%random_lr: 1 to get random length of the path
% belt_cm = 53.3;
% times = 0.2;
% one_round = 830000;
%velocity and time check for reference (time1) and comparison (time2)
%cm = lr * (53.3/830000);
%vel_cmsec = 0.2308125 + (comV * 0.002882504);

%condition
condition = zeros([140 1]);
for k = 1:4
    cfrom = 1 +((k-1)*35);
    cto = (k*35);
    condition(cfrom:cto, 1) = repmat(k, 35, 1);
end

%Speed
refV = repmat(437, 140, 1);
comV = repmat(repmat([51 180 308 437 566 694 823]', 5, 1), 4, 1);

%Speed ccw
refVccw = repmat(-437, 140, 1);
comVccw = repmat(repmat([-51 -180 -308 -437 -566 -694 -823]', 5, 1), 4, 1);

%try to improve accuracy with a gain (1.5, 0.5)
%refVccw = repmat(-439, 140, 1);
%comVccw = repmat(repmat([-52 -183 -312 -439 -572 -699 -827]', 5, 1), 4, 1);

%If reference stimulus or comparison stimulus comes first
ref_first = repmat([ones(17, 1); zeros(18, 1)], 4, 1);   
 
%input-vibration frequency
f1 = repmat([50 1], 140, 1);
f2 = repmat([50 1], 140, 1);

%Match the nominal to the actual speed
reference = zeros([140 1]);
comparison = zeros([140 1]);

for nrow = 1:140
%select the condition    
    switch condition(nrow,1)
    case(1)
        reference(nrow,1) = refV(nrow,1);
        comparison(nrow,1) = comV(nrow,1);
    case(2)
        reference(nrow,1) = refVccw(nrow,1);
        comparison(nrow,1) = comVccw(nrow,1);
    case(3)
        reference(nrow,1) = refVccw(nrow,1);
        comparison(nrow,1) = comV(nrow,1);
    otherwise
        reference(nrow,1) = refV(nrow,1);
        comparison(nrow,1) = comVccw(nrow,1);
    end
end

%desmat = [comV lr ref_first cm vel_cmsec time];
desmat = [refV comV ref_first f1 f2 condition reference comparison];