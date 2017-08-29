function answer = SpeedMove3(refV, comV, rfirst, refVIBRO, comVIBRO,...
     condition, fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)

%Comparison of the speed of motion in stimulus 1 and 2 
%AM22.07.2015 did it
%The function to move the motor twice. 
%The parameters refV and comV are vectors [speed lr]. rfirst is a dummy (0,1)
%if rfirst == 1 then the reference is presented before the comparison.
%vibro is a vector (lenght = 2) with the vibration frequency and duration 
%of the stimulus.
%random shuffle refV and comV
%08.03.2017 skip time to trigger the motion stimulus

velocity = zeros(1,2);
duration = zeros(1,2);
ISI = 1;
DeltaV = 780;

%random durations. If comment add refT, comT, as arguments
mean_st = 1;
refT = abs(normrnd(mean_st, 0.1));
comT = abs(normrnd(mean_st, 0.1));

amplitude = zeros(1,2);
frequency = zeros(1,2);

%this is no longer necessary -> now in design matrix
%select the condition    
%     switch condition
%     case(1)
%         %refV = refV;
%         %comV = comV;
%     case(2)
%         refV = -refV;
%         comV = -comV;
%     case(3)
%         refV = -refV;
%    otherwise
%         comV = -comV;
%     end
    
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
    
    %if(interval == 2)
        pause(ISI);
        figure(blankFIG)
    %end
    
    %Move (pause for safety) [check if  M is necessary in Velocity control]
    %fprintf(p1,'V%i\n', velocity(interval));
    sample = 10;
    buffer = zeros(sample,1);
    k = 0;
    incontact = 0;
    tk = 0;
    ti = 0;
    all_vals = [trial velocity(interval) 999 999 999];
    stimulus_time = tic;
    skip = 1.0; %skip the first second
    
    while(1)
        %in Arduino Serial.print print as ASCII character. Replace with:
        line = fgetl(arduino_board);
        voltage = str2double(line);
        all_vals(3) = incontact;
        now = toc(stimulus_time);
        all_vals(4) = now;
        
        if(incontact == 0)
            if(k < sample)
                k = k + 1;
                buffer(k,1)= voltage;
            else
                buffer(1:(sample-1),1)= buffer(2:sample,1);
                buffer(sample,1)= voltage;
            end
            
            Gbuff = min(gradient(buffer));%check if monotonically increasing
            DVi = mean(buffer);
            
            %touch the device
            if(now > skip && DVi >= DeltaV && Gbuff >= 0)
                fprintf(p1,'V%i\n', velocity(interval));
                figure(fingerFIG)
                incontact = 1;
                tstart = tic;
            end
        else    %incontact == 1
                %save current time
            ti = toc(tstart);     
            if(isempty(ti) == 0)
                tk = ti;
                %all_vals(4) = ti;
            else
                ti = tk;
            end
        end
        
        %maybe this control is no longer needed...
        if(isempty(voltage) == 0)
            all_vals(5) = voltage;
        end
        fprintf(serial_id, '%3u\t %4d\t %1u\t %.5f\t %4f\n', all_vals);
                
        %stop the motor
        if(ti >= stimulus)
            fprintf(p1,'V%i\n', 0);
            figure(blankFIG)
            break;
        end  
    end
    
end

answer = 0;