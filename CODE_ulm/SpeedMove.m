function answer = SpeedMove(refV, comV, rfirst, refVIBRO, comVIBRO,...
     condition, refFIG, comFIG, blankFIG, p1)

%Comparison of the speed of motion in stimulus 1 and 2 
%AM22.07.2015 did it
%The function to move the motor twice. 
%The parameters refV and comV are vectors [speed lr]. rfirst is a dummy (0,1)
%if rfirst == 1 then the reference is presented before the comparison.
%vibro is a vector (lenght = 2) with the vibration frequency and duration 
%of the stimulus.
%random shuffle refV and comV

velocity = zeros(1,2);
duration = zeros(1,2);
ISI = 2;

%random durations. If comment add refT, comT, as arguments
refT = abs(normrnd(2, 0.1));
comT = abs(normrnd(2, 0.1));

amplitude = zeros(1,2);
frequency = zeros(1,2);

%select the condition    
    switch condition
    case(1)
        %refV = refV;
        %comV = comV;
    case(2)
        refV = -refV;
        comV = -comV;
    case(3)
        refV = -refV;
   otherwise
        comV = -comV;
    end
    
if(rfirst == 1)
    velocity(1:2) = [refV comV];
    duration(1:2) = [refT comT]; 
    amplitude(1:2) = [refVIBRO(1) comVIBRO(1)];
    frequency(1:2) = [refVIBRO(2) comVIBRO(2)];
    
    fig1 = refFIG;
    fig2 = comFIG;  
else
    velocity(1:2) = [comV refV];
    duration(1:2) = [comT refT];
    amplitude(1:2) = [comVIBRO(1) refVIBRO(1)];
    frequency(1:2) = [comVIBRO(2) refVIBRO(2)];

    fig1 = comFIG;
    fig2 = refFIG;
end

for interval = 1:2
    ramp = duration(interval)*0.2;
    
    if(interval == 2)
        pause(ISI);
    end
    
    %Move (pause for safety) [check if  M is necessary in Velocity control]
    fprintf(p1,'V%i\n', velocity(interval));

    %Vibration [check that it is not blocking]
    %comment for the glove experiment
    %envelope_vibro(frequency(interval), amplitude(interval), 0, 10, duration(interval));

    %wait for ramp up
    pause(ramp)
    
    %touch the device
    if(interval == 1)
        figure(fig1)
    else
        figure(fig2)
    end
    
    pause(duration(interval) - (2 * ramp));
    
    %lift while ramp down
    figure(blankFIG)
    pause(ramp);
    fprintf(p1,'V%i\n', 0);

end

answer = 0;