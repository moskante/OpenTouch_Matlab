function answer = DetectionMove(myLR, mySP, mfirst, VF, VA,...
     fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)

%Comparison of the speed of motion in stimulus 1 and 2 

%Voltage threshold
figure(blankFIG)
DeltaV = 780;%check if thershold is enough...

%fixed duration
disp = abs(myLR);
duration = 60 * ((disp/2048)/mySP);
Vduration = duration + 1;

%target displacement and speed
fprintf(p1,'PROGSEQ\n SP%i\n LR%i\n DELAY%i\n M\n END\n', [mySP myLR 50]);

if(mfirst == 1)
    Minterval = 1;
else
    Minterval = 2;
end

sample = 100;
skip = 1.0; %skip the first second
  
for interval = 1:2
    
    %set intervals
    figure(blankFIG)
    
    %Inizialize values
    buffer = zeros(sample,1);
    k = 0;
    incontact = 0;
    tk = 0;
    ti = 0;
    all_vals = [trial myLR 999 999 999];
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
                %show the figure
                figure(fingerFIG)
                
                if(DVi >= DeltaV)
                    %start vibration
                    envelope_vibro(VF, VA, 0, 10, Vduration, 0); 
                    
                    %move only at motion interval
                    if(interval == Minterval)
                        %fprintf(p1,'M\n');
                        fprintf(p1,'ENPROG\n');
                    end
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
        fprintf(serial_id, '%3u\t %4d\t %1u\t %.5f\t %4f\n', all_vals);
                
        %stop the motor
        if(ti >= Vduration)
            figure(blankFIG)
            break;
        end  
    end
    
end

answer = 0;