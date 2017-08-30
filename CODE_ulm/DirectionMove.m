function answer = DirectionMove(velocity, VIBRO,...
    fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)

%Move once either CW or CCW 
%23.02.2017 AM and CR did it
%The function to move the motor once and collect voltage values from
%Arduino. VIBRO is not used in the current version.

%Voltage threshold
figure(blankFIG)
DeltaV = 780;

%random durations. If comment add refT, comT, as arguments
mean_st = 1.0;
duration = abs(normrnd(mean_st, 0.1));
    
%Move (pause for safety) [check if  M is necessary in Velocity control]
%fprintf(p1,'V%i\n', velocity(interval));
sample = 100;
buffer = zeros(sample,1);
k = 0;
incontact = 0;
tk = 0;
ti = 0;
all_vals = [trial velocity 999 999 999];
skip = 1.0; %skip the first second
stimulus_time = tic;
    
while(1)
    %in Arduino Serial.print print as ASCII character. Replace with:
    line = fgetl(arduino_board);
    voltage = str2double(line);
    
    %remove outlayer
    if(voltage > 1200)
        voltage = 1200;
    end
    all_vals(3) = incontact;
    now = toc(stimulus_time);
    all_vals(4) = now;
        
    if(incontact == 0)
        if(k < sample)
            k = k + 1;
            buffer(k,1)= voltage;
        else
            buffer(1:(sample-1),1) = buffer(2:sample,1);
            buffer(sample,1)= voltage;
        end
            
            %Gbuff = min(gradient(buffer));%check if monotonically increasing
            %Gbuff = 1; %remove diff check 
            DVi = mean(buffer);
            
            %touch the device
            if(now > skip && DVi >= DeltaV)
                fprintf(p1,'V%i\n', velocity);
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
    if(ti >= duration)
        fprintf(p1,'V%i\n', 0);
        figure(blankFIG)
        break;
    end  
end

answer = 0;