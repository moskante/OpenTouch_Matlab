function answer = DetectionMove2(myLR, mySP, mfirst, VF, VA,...
     fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)
 
%2AFC Motion detection task 

%blank figure
figure(blankFIG)

%Inizialize values
DeltaV = 400;   %Voltage threshold
sample = 100;    
buffer = zeros(sample,1);
skip = 1.0; %skip the first second 
k = 0;
incontact = 0;
interval = 0;
tk = 0;
ti = 0;
all_vals = [trial myLR mfirst 999 999 999 999];
%stimulus_flag = 0;
FirstInterval = 0;

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

trial_time = tic;

while(1)
    %read force(voltage) values
    line = fgetl(arduino_board);
    voltage = str2double(line);
    
    %start stopwatch stimulus_time
%     if(stimulus_flag == 0)
%         stimulus_time = tic;
%         stimulus_flag = 1;
%     end
    
    now = toc(trial_time);
    now2 = now - FirstInterval;
    %now2 = toc(stimulus_time);
    
    all_vals(4) = incontact;
    all_vals(5) = now;
    all_vals(6) = now2;
    
    %maybe this control is no longer needed...
    if(isempty(voltage) == 0)
        %remove outlayer
        if(voltage > 1200)
            voltage = 1200;
        end
        all_vals(7) = voltage;
    end
        
    if(incontact == 0)
        if(k < sample)
            k = k + 1;
            buffer(k,1)= voltage;
        else
            buffer(1:(sample-1),1) = buffer(2:sample,1);
            buffer(sample,1)= voltage;
        end
        DVi = mean(buffer);
            
        %touch the device
        if(now2 > skip)                                                     %change here
            %show the figure
            figure(fingerFIG)
                
            if(DVi >= DeltaV)
                %start vibration
                envelope_vibro(VF, VA, 0, 10, Vduration, 0);
                
                %update variables
                interval = interval + 1;
                incontact = 1;
                tstart = tic;
                
                %move only at motion interval
                if(interval == Minterval)
                    fprintf(p1,'ENPROG\n');
                end
            end
        end
    else    %incontact == 1
        %save current time
        ti = toc(tstart);
        
        %for safety, this always assign a value to ti
        if(isempty(ti) == 0)
            tk = ti;
        else
            ti = tk;
        end
    end
        
    fprintf(serial_id, '%3u\t %4d\t %1u\t %1u\t %.5f\t %.5f\t %4f\n', all_vals);    
       
    if(ti >= Vduration)
        figure(blankFIG)
        incontact = 0;
        FirstInterval = now;
        %stimulus_flag = 0;
        buffer = zeros(sample,1);
        ti = 0;
        
        %exit the while loop
        if(interval == 2)
            break;
        end
    end  
end
    
answer = 0;