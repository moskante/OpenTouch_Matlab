function desmat = DirectionDesign_matrix(POS, SP)

%POS: logical, position or velocity contro
%VA: inteeger, vibration amplitude

ntrials = 270;

%input-vibration frequency
%f1 = repmat([100 VA], ntrials, 1);
f1 = [repmat([100 0.0], ntrials/3, 1)
      repmat([100 0.5], ntrials/3, 1)
      repmat([100 1.0], ntrials/3, 1)];
  
if(POS == 0)
    %Speed cw
    comVcw = repmat(repmat([20 60 100]', 5, 1), 4, 1);

    %Speed ccw
    comVccw = -comVcw;
    target = [comVcw
         comVccw];
    desmat = [target f1];

else
    mySP = repmat(SP, ntrials, 1);
    %mySP = [repmat(60, ntrials/2, 1)
    %        repmat(20, ntrials/2, 1)];                                    %high and low speed ten repetitions each
    myLR = repmat([-45 -30 -15 15 30 45]', 45, 1);
    
    desmat = [myLR mySP f1];
end


