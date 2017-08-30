function answer = SSHMove(myLR, mySP, VF, VA, rfirst,...
     fingerFIG, blankFIG, p1, arduino_board, serial_id, trial)
 
%2AFC Speed discrimination task 
%in the design matrix, check that LR(1) + LR(2) < workspace
%LA0 after response

%blank figure
figure(blankFIG)

%Inizialize values
DeltaV = 200;   %Voltage threshold: change this to modify threshod on force in N
sample = 100;    
buffer = zeros(sample,1);
skip = 1.0; %skip the first second 
k = 0;
incontact = 0;
interval = 0;
tk = 0;
ti = 0;
all_vals = [trial myLR mySP rfirst 999 999 999 999];                       %now LR and SP are vectors
%stimulus_flag = 0;
FirstInterval = 0;

%fixed duration
%disp = abs(myLR);
%duration = 60 * ((disp/2048)/mySP);
%Vduration = duration + 1;
Vduration = 1.5; %check that stimulus duration always > than motion duration

if(rfirst == 1)
    myLR = [myLR(2) myLR(1)];
    mySP = [mySP(2) mySP(1)]; 
    VF = [VF(2) VF(1)];
    VA = [VA(2) VA(1)];
end

%This add a fixed delay to motion onset of the motor [stimulus1 stimulus2]
%units: 1/10 of seconds
mytime = [0 0];

%This add a fixed delay to vibration onset [stimulus1 stimulus2]
%units: seconds
SoundDelay = [0 0];

trial_time = tic;
while(1)
    %read force(voltage) values
    line = fgetl(arduino_board);
    voltage = str2double(line);
    
    now = toc(trial_time);
    now2 = now - FirstInterval;
    
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
        if(now2 > skip)                                                    %change here
            %show the figure
            figure(fingerFIG)
                
            if(DVi >= DeltaV)
                %update variables
                interval = interval + 1;
                incontact = 1;
                tstart = tic;
                
                %target displacement and speed
                fprintf(p1,'PROGSEQ\n SP%i\n LR%i\n DELAY%i\n M\n END\n', [mySP(interval) myLR(interval) mytime(interval)]);
                
                %start vibration
                envelope_vibro(VF(interval), VA(interval), 0, 10, Vduration, SoundDelay(interval));
                
                %Move
                fprintf(p1,'ENPROG\n');
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
        
    fprintf(serial_id, '%3u\t %4d\t %4d\t %4d\t %4d\t %1u\t %1u\t %.5f\t %.5f\t %4f\n', all_vals);    
       
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