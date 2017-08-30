function answer = CalibreMove2(Vel, duration, p1, arduino_board, ISI, K)

%Comparison of the speed of motion in stimulus 1 and 2 
%AM22.07.2015 did it
%The function to move the motor twice. 
%The parameters refV and comV are vectors [speed lr]. rfirst is a dummy (0,1)
%if rfirst == 1 then the reference is presented before the comparison.
%vibro is a vector (lenght = 2) with the vibration frequency and duration 
%of the stimulus.
%random shuffle refV and comV

all_vals = [Vel duration 999 999];
t_final = [0 0];
p_final = [0 0];

for interval = 1:2
    if(ISI == 1)
        waitforbuttonpress;
    end
    
    if(interval == 2)
        if(Vel > 0)
            Vel = round(-Vel*(1 + K));
        else
            Vel = round(-Vel*(1 - K));
        end
    end
    
    %Check: delay?
    fprintf(p1,'V%i\n', Vel);
    tstart = tic;
    
    while(1)
        %read serial port (uncomment if using the Arduino toolbox)
        line = fgetl(arduino_board);
        % the following will convert to floating point numbers
        voltage = str2double(line);
         
        %save current time
        ti = toc(tstart);
        
        %save voltage and ti values.
        if(isempty(voltage) == 0)
            all_vals(3) = voltage;
        end
        
        if(isempty(ti) == 0)
            tk = ti;
            all_vals(4) = ti;
        else
            ti = tk;
        end
        
        %stop the motor
        if(ti >= duration)
            t_final(1,interval) = ti;
            fprintf(p1,'V%i\n', 0);
            %fprintf(p1,'V%i\n POS\n', 0);
            %p_final(1,interval) = str2double(fgetl(p1));
            %p_final(1,interval) = str2double(fscanf(p1));
            break;
        end  
    end
    
end

%answer = all_vals;
answer = [t_final p_final Vel];