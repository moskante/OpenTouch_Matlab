function answer = SpeedMove2(refV, comV, rfirst, refVIBRO, comVIBRO,...
     condition, fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)

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
mean_st = 2.6;
refT = abs(normrnd(mean_st, 0.1));
comT = abs(normrnd(mean_st, 0.1));

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
    
else
    velocity(1:2) = [comV refV];
    duration(1:2) = [comT refT];
    amplitude(1:2) = [comVIBRO(1) refVIBRO(1)];
    frequency(1:2) = [comVIBRO(2) refVIBRO(2)];
end

for interval = 1:2
    
    %set intervals
    stimulus = duration(interval);
    ramp = 0.8;
    %ramp = 1;
    
    touch = stimulus - ramp;
    
    if(interval == 2)
        pause(ISI);
    end
    
    %Move (pause for safety) [check if  M is necessary in Velocity control]
    fprintf(p1,'V%i\n', velocity(interval));
    touch_flag = 0;
    incontact = 0;
    blank_flag = 0;
    tk = 0;
    all_vals = [trial velocity(interval) 999 999 999];
    tstart = tic;
    
    while(1)
        %read serial port (uncomment if using the Arduino toolbox)
        %voltage = fscanf(arduino_board, '%4f\n');
        %voltage = readVoltage(arduino_board, 'A0');
        %Warning: Unsuccessful read: Matching failure in format..
        %in Arduino Serial.print print as ASCII character. Replace with:
        line = fgetl(arduino_board);
        % the following will convert to floating point numbers
        voltage = str2double(line);
        %see: https://it.mathworks.com/matlabcentral/answers/270319-warning-unsuccessful-read-matching-failure-in-format-subscripted-assignment-dimension-mismatch 
        
        %save current time
        ti = toc(tstart);
        
        %save incontact, voltage and ti values
        all_vals(3) = incontact;
        
        %maybe this control is no longer needed...
        if(isempty(voltage) == 0)
            all_vals(5) = voltage;
        end
        
        if(isempty(ti) == 0)
            tk = ti;
            all_vals(4) = ti;
        else
            ti = tk;
        end
        
        %output to serial object serial_id
        %fprintf(serial_id, '%3u\t %4d\t %1u\t %.5f\t %4.1f\n',...
        %    [trial velocity(interval) incontact ti voltage]);
        %this opent the serial port multiple times --> move it before
        %break?
        %check that format is consistent with fscanf
        fprintf(serial_id, '%3u\t %4d\t %1u\t %.5f\t %4f\n', all_vals);
        
        %touch the device
        if(ti >= ramp && touch_flag == 0)
            figure(fingerFIG)
            touch_flag = 1;
            incontact = 1;
        end
        
        %lift the finger while ramp down
        if(ti >= touch && blank_flag == 0)
            figure(blankFIG)
            blank_flag = 1;
            incontact = 0;
        end
        
        %stop the motor
        if(ti >= stimulus)
            fprintf(p1,'V%i\n', 0);
            break;
        end  
    end
    
end

answer = 0;