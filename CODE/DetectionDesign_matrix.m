function desmat = DetectionDesign_matrix(VA)

%rel_disp: proprtion of one round of the belt
%random_lr: 1 to get random length of the path
% belt_cm = 53.3;
% times = 0.2;
% one_round = 830000;
%velocity and time check for reference (time1) and comparison (time2)
%cm = lr * (53.3/830000);
%vel_cmsec = 0.2308125 + (comV * 0.002882504);

ntrials = 100;
stimuli =[-150:25:-50 50:25:150]';
repetitions = ntrials/length(stimuli);

%input-vibration frequency
f1 = repmat([100 VA], ntrials, 1);
f2 = repmat([100 VA], ntrials, 1);

%If reference stimulus or comparison stimulus comes first
ref_first = repmat([ones(10, 1); zeros(10, 1)], 5, 1);   
 

mySP = repmat(80, ntrials, 1);
myLR = repmat(stimuli, repetitions, 1);
%blank = zeros(ntrials, 1);
  
desmat = [myLR mySP ref_first f1 f2];
