function [answer] = SSHMove_pilot(myLR, mySP, VF, VA, rfirst,...
    fingerFIG, blankFIG, toomuchFIG, motor, forceplate, trial, mysound)
%
% 2AFC Speed discrimination task
% in the design matrix, check that LR(1) + LR(2) < workspace
% LA0 after response
%
% Version LM Theunissen: 17.08.2017

% blank figure
figure(blankFIG)

% Inizialize values
forceplateThreshold = 20;   % Voltage threshold: change this to modify threshod on force in N
buffer = ones(100,1)*forceplateThreshold;   % buffer the forceplate input to accomodate for outliers?
skip = 1; % skip the first [] second

startReset = 0;
incontact = 0;
interval = 0;  % interval decides whether the first or second set of stimuli is to be used
% tk = 0;
ti = 0;
%all_vals = [trial myLR mySP rfirst 999 999 999 999]; % now LR and SP are vectors
accData = [];
% stimulus_flag = 0;
FirstInterval = 0;
showFigureHand = 1;
showFigureBlank = 1;

if(rfirst == 1) % change order of stimuli
    myLR = [myLR(2) myLR(1)];
    mySP = [mySP(2) mySP(1)];
    VF = [VF(2) VF(1)];
    VA = [VA(2) VA(1)];
end

%results for the estimated amplitudeMultipliers: [7 13 12 30 10 50 6]
amplitudeMultiplier = [7 13 12 30 10 50 6];
%collumns 1-7 are speeds 300-4800 for 6000 distance, 8-14 for 12000 distance
speedIndex(1) = find(mySP(1) == 300:750:4800);
speedIndex(2) = find(mySP(2) == 300:750:4800); %which speed from 1-7   see [300  1050   1800  2550  3300  4050  4800]
distanceIndex = (abs(myLR)/6000)-1;    %0 for 6000 myLR, 1 for 12000 myLR
%select correct collumn as soundinput
inputSignal = mysound(:,(speedIndex+(distanceIndex*7))); % +7 for 12000 distance,+0 for 6000
inputSignal = inputSignal.*amplitudeMultiplier(speedIndex);


% fixed duration of vibration
% disp = abs(myLR);
% duration = 60 * ((disp/2048)/mySP);
% Vduration = duration + 1;
% Vduration = 1.5; %check that stimulus duration always > than motion duration

%flexible vibrrtion duration dependent on movement speed and distance
Vduration = (abs(myLR/15000))./(mySP/300);

% This adds a fixed delay to motion onset of the motor [stimulus1 stimulus2]
% units: 1/10 of seconds
MotorDelay = [0 0];

% This add a fixed delay to vibration onset [stimulus1 stimulus2]
% units: seconds
%SoundDelay = [0.07 0.07];
SoundDelay = [0.08 0.08]+0.15;       %0.07 from timestamp analysis, constant factor by "feeling"
%(old) vibro function takes about 0.035 at the first interval and 0.015 at the
%second interval - this difference is no more present with the updated
%'play_vibro' function and pre computed sound input

trial_time = tic;
while(1)
    %     read force (voltage) values
    line = fgetl(forceplate);
    voltage = str2double(line); % might provide nan
    %voltage = str2num(fscanf(arduino_board)); % might provide empty voltage
    
    % read accelerometer data
    %     tempData = fgetl(accMeter);
    %     tempData = str2num(tempData);
    %    tempData = str2num(fscanf(accMeter));
    
    % check if voltage is empty
    if(isempty(voltage) == 0)
        %remove outlier
        if(voltage > 800)
            voltage = 800;   %dampen the voltage response, short pressure bursts dont count as much
        % reset trial
        clear sound;    %stops possible sound output of the tractor 
        trial_time = tic;
        FirstInterval = 0;
        startReset = 0;
        interval = 0;
        incontact = 0;
        showFigureHand = 1;
        showFigureBlank = 1;
        buffer = ones(100,1)*forceplateThreshold;   % buffer the forceplate input to accomodate for outliers?
        figure(toomuchFIG)
        %  move back to starting  position...
        fprintf(motor,'SP%i\n LA%i\n M\n', [2550, 0]);
        %pause(0.1)
        elseif(isnan(voltage))
            voltage = 0;
        end
    else
        voltage = 0;
    end
    % %     check if tempData is empty
    %     if isempty(tempData)
    %         tempData = [nan, nan, nan];
    %     elseif length(tempData) ~= 3
    %         tempData = [nan, nan, nan];
    %     end
    
    now = toc(trial_time);
    now2 = now - FirstInterval; % always 0 after interval 1?? sense?
    
    %     % reminder: all_vals = [trial myLR mySP rfirst 999 999 999 999];
    %     all_vals(4) = incontact;
    %     all_vals(5) = now;
    %     all_vals(6) = now2;
    %     all_vals(7) = voltage;          %does interval2 override all those?
    %     %all_vals doesnt even get saved!
    
    buffer(1:(end-1), 1) = buffer(2:end, 1); % buffer gets updated from end to start
    buffer(end, 1) = voltage;
    DVi = mean(buffer);
    if startReset == 0 && round(DVi) <= 2 
        startReset = 1;   
    end
    
    if startReset == 1
        if incontact == 0
            % touch the device
            if now2 > skip % change here
                % show the figure (it is extremely slow and much faster if its
                % only shown once!)
                if showFigureHand
                    figure(fingerFIG)
                    showFigureHand = 0;
                end
                if DVi >= forceplateThreshold % DVi = mean voltage of the last 100 voltage datapoints
                    % update variables
                    interval = interval + 1;   %interval =1 in first interaction, then 2, then break
                    incontact = 1;
                    tstart = tic;
                    %                 saveAccData = 1;
                    % target displacement and speed
                    % PROGSEQ= input the program sequence for the faulhaber
                    % motor without starting it!
                    fprintf(motor,'PROGSEQ\n SP%i\n LR%i\n DELAY%i\n M\n END\n', [mySP(interval) myLR(interval) MotorDelay(interval)]);
                    % generate and start vibration (own delay)
                    play_vibro(inputSignal(:, interval), VA(interval), SoundDelay(interval));
                    % ENPROG = start the previously saved program sequence for
                    % the faulhaber motor
                    fprintf(motor,'ENPROG\n');
                end
            end
        else  % incontact == 1
            ti = toc(tstart); % save current time
            %         if saveAccData
            %             accData(end+1, 1:5) = [interval, toc, tempData];
            %         end
            
            %        fprintf(serial_id, '%3u\t %4d\t %4d\t %4d\t %4d\t %1u\t %1u\t %.5f\t %.5f\t %4f\n', all_vals);
            
            if(ti >= Vduration(interval) + 0.5)
                if showFigureBlank
                    figure(blankFIG)   %maybe "release finger" figure instead?
                    showFigureBlank = 0;
                end
                %             saveAccData = 0;
                if round(DVi) == 0
                    FirstInterval = now;    %sense?
                    incontact = 0;
                    ti = 0;
                    showFigureHand = 1;
                    showFigureBlank = 1;
                end
                % exit the while loop = end the trial after first and second
                % stimulus have been pesented (position is not jet resetted to POS0)
                if(interval == 2)
                    break;
                end
            end
        end
    end
end
% %get the actual timespan in the 2 intervals of accData [in sec]
% accInervalIndex = find(accData==2,1);
% accDataTimespan = (accData(accInervalIndex-1,2)-accData(1,2)) + (accData(end,2)-accData(accInervalIndex,2));
% sampleFreq = length(accData)/accDataTimespan;
answer = 0;