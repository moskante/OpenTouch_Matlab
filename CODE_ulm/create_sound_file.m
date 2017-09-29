% create_sound_file
%
% CREATE_SOUND_FILE creates and saves a sound file with 7 sound signals
% that can be loaded once for the experiment
%
% Version LM Theunissen: 06.09.2017 
% edited by felix traub 29.9.2017, new speeds and actual durations instead
% of theoretical durations!


%% Settings
myLR = [6000 12000];
% mySP = [300  1050   1800  2550  3300  4050  4800];  old speeds
mySP = [300 550 800 1050 1300 1550 1800];       %new sower speeds
fs = 4000; % sampling frequency

% set amplitudeAdjustment multiplier
amplitudeAdjustment = [1, 1, 1, 1, 1, 1, 1];        %not yet computed

%actualDurations measured with 'beltspeed_calib' - these are much longer
%(~2-3times) for the 6000 distance cases!
actualDurations = ...
[0.48, 0.33, 0.28, 0.26, 0.25, 0.25, 0.25,   0.84, 0.51, 0.40, 0.34, 0.30, 0.29, 0.28];

% initialize mysound
% mysound = zeros((max(myLR)/15000)/(min(mySP)/300)*fs, length(mySP)*length(myLR));
mysound = zeros(max(actualDurations)*fs, length(mySP)*length(myLR));

%% generate sound for the different speeds

for u = 1:length(myLR)
    for n = 1:length(mySP)
        
%         % get duration - old
%         theoreticalDuration = (myLR(u)/15000)/(mySP(n)/300);

        % create time vector - take the indexed duration out of actualDurations
        t = 0:1/fs:actualDurations(n + ((u-1)*length(mySP)));
        nValues = length(t);
        
        %% sorting 7 speeds and the standard speed into 5 bins
        % [300 550 800 1050 1300 1550 1800]
        if n == 1    % 300SP bin
            freq = round(f(f>30)*10)/10;
            amplitude = P1average300(f > 30)*amplitudeAdjustment(1);
        elseif n == 2     
            freq = round(f(f>30)*10)/10;
            amplitude = P1average550(f > 30)*amplitudeAdjustment(2);
        elseif  n == 3   
            freq = round(f(f>30)*10)/10;
            amplitude = P1average800(f > 30)*amplitudeAdjustment(3);
        elseif  n == 4       
            freq = round(f(f>30)*10)/10;
            amplitude = P1average1050(f > 30)*amplitudeAdjustment(4);
        elseif   n == 5    
            freq = round(f(f>30)*10)/10;
            amplitude = P1average1300(f > 30)*amplitudeAdjustment(5);
        elseif   n == 6     
            freq = round(f(f>30)*10)/10;
            amplitude = P1average1550(f > 30)*amplitudeAdjustment(6);
        elseif  n == 7    
            freq = round(f(f>30)*10)/10;
            amplitude = P1average1800(f > 30)*amplitudeAdjustment(7);
        end
        
        % set collumn index
        idx = n + ((u-1)*length(mySP));
        %collumns 1-7 are speeds 300-1800 for 6000 distance, 8-14 for 12000
        %distance
        
        % generate the vibration signal
        for i = 1:length(freq)
            vibration = sin(2*pi*freq(i)*t)*amplitude(i);
            if i == 1
                mysound(1:nValues, idx) = vibration;
            else
                mysound(1:nValues, idx) = mysound(1:nValues, idx) + vibration';
            end
        end
    end
end


save('sound_input_slow_speeds', 'mysound')