function answer = DirectionMove2(myLR, mySP, VIBRO,...
    fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)

%Move once either CW or CCW 
%23.02.2017 AM and CR did it
%The function to move the motor once and collect voltage values from
%Arduino. VIBRO is not used in the current version.

%Voltage threshold
figure(blankFIG)
DeltaV = 180;

%random durations. If comment add refT, comT, as arguments
disp = abs(myLR);
ENCRES = 2048;
DELAY = round(normrnd(50, 8));
if(DELAY > 80)
    DELAY = 80;
else
    if(DELAY < 20)
        DELAY = 20;
    end
end
duration = 60 * ((disp/ENCRES)/mySP) + (DELAY*0.02); %motion duration plus twice DELAY (in sec)
myNP = myLR - 1;%notify one step before target

%target displacement and speed
%fprintf(p1,'PROGSEQ\n SP%i\n LR%i\n DELAY%i\n M\n DELAY%i\n POS\n END\n', [mySP myLR 50 tPOS]);
%fprintf(p1,'PROGSEQ\n SP%i\n LR%i\n DELAY%i\n M\n END\n', [mySP myLR 10]);
fprintf(p1,'PROGSEQ\n SP%i\n LR%i\n NP%i\n DELAY%i\n M\n END\n', [mySP myLR myNP DELAY]);

%target displacement and speed
%fprintf(p1,'SP%i\n LR%i\n', [mySP myLR]);
    
%Move (pause for safety) [check if  M is necessary in Velocity control]
%fprintf(p1,'V%i\n', velocity(interval));
sample = 50;
buffer = zeros(sample,1);
k = 0;
incontact = 0;
tk = 0;
ti = 0;
all_vals = [trial myLR 999 999 999 DELAY];
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
            if(now > skip)
                figure(fingerFIG)
                
                if(DVi >= DeltaV)
                    %start vibration
                    envelope_vibro(VIBRO(1), VIBRO(2), 0, 10, duration, 0); 
                    
                    %Move
                    fprintf(p1,'ENPROG\n');
                    incontact = 1;
                    tstart = tic;
                end
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
        fprintf(serial_id, '%3u\t %4d\t %1u\t %.4f\t %4.0f\t %3u\n', all_vals);
                
    %stop the motor
    if(ti >= duration)
        figure(blankFIG)
        break;
    end  
end

answer = 0;