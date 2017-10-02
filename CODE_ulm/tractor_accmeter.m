%% start the tractor with certain soundinput (mysound, load different file if neccessary),
% collect accmeter data, plot and fft acc data, then compare vibrations
% caused by tractor with previously measured vibrations caused by movement,
% and adjust amplitudeMultiplier until the means of each source roughly match

%close all serial ports
port = instrfind;
fclose(port())

%open accelerometer
accMeter = serial('COM14','BaudRate',115200);    %previous standart
fopen(accMeter);
set(accMeter,'Timeout',1);

%% %parameters needed for tractor duration
% myLR= 12000; %desired distance
% mySP= 1800; %desired speed %new speeds %[300  1050   1800  2550  3300  4050  4800]
% duration = (myLR/15000)./(mySP/300);  

%% example: 0.1500 and 0.0750 Vduration for 12000 and 6000 distance at 1600 speed
%duration = 1;  %duartion is pre-determined by the soundfile for each stimulus
silence = 1.4;      %delay before starting the tractor
fs=4000;

%% aim is to find a value so the resulting vibration amplitude on the fingertip is
%similar to the vibration during box movement 
amplitudeMultiplier = 30;     % saturation at Multiplier => 1000
% preliniary amp multiliers results:
% [10, 10, 8, 9, 8, 30, 15]
%generate sound function
%out = envelope_vibro_LMT(freq, amplitude, duration, silence);

%collumns 1-7 are speeds 300-4800 for 6000 distance, 8-14 for 12000 distance
speedIndex = 6;     %which speed from 1-7   see [300  1050   1800  2550  3300  4050  4800]
% distanceIndex=(myLR/6000)-1;    %0 for 6000 myLR, 1 for 12000 myLR
distanceIndex=1;        %for 12000 distance

inputSignal = mysound(:,(speedIndex+(distanceIndex*7)));        %+7 for 12000 distance,+0 for 6000
%play sound out of 'sound_input_final', duration has no effect!
out = play_vibro(inputSignal, amplitudeMultiplier, duration, silence);



%accdata collection
accData = 0;
while (accData==0)  %error check, sometimes the frist fscan read doesnt work   
   accData = str2num(fscanf(accMeter));  % str2num converts the arduino string to integers
   % accData = str2num(fgetl(accMeter));
    accData = [accData, 0];
end         % this takes almost 1.5 sec!

dataLength =320;  % 1000 datalength results in about ~3 sec of recording with the typical sampling rate of ~333Hz
%should length of accdata be adjusted to the lenght of the inidividual
%accdata vectors in the averages?  => 324 is that length
accData = nan(dataLength, 4);

%  soundstart=tic;
% sound((mysound(:,(speedIndex+7)).*amplitudeMultiplier), fs);        %4+7 = 2550 speed at 12000 distance
%  toc(soundstart)

tic;
for i = 1:dataLength      
%    accTemp = [str2num(fscanf(accMeter)), toc];
%    accTemp = [accTemp, toc];                % add timestamp each line
   %accData = cat(1,accData,accTemp);        %aggregate data
   accData(i, :) = [str2num(fscanf(accMeter)), toc];
    %accData(i, :) = [str2num(fgetl(accMeter)),toc] ;
   %pause(0.001);    
end 
sampleFreq = dataLength/toc;
fclose(accMeter);

%% trialswise recording quality check and amplitude spectrum plots
% Specify the parameters of a signal with a sampling frequency and a signal duration


L = length(accData);     % Length of signal
%X = accData(:,3:5);
X = accData(:,1:3);

%Fs = length(accData)/5;            % Sampling frequency                    
Fs = sampleFreq;
T = 1/Fs;             % Sampling period    
t = 0:1/Fs:(L-1)/Fs; % accData(:, 2);        % Time vector


%% 
% Compute the Fourier transform of the signal. 
%%
xAxis = fft(X(:,1));
yAxis = fft(X(:,2));
zAxis = fft(X(:,3));

%% 
% Compute the two-sided spectrum |P2|. Then compute the single-sided spectrum 
% |P1| based on |P2| and the even-valued signal length |L|.
P2X = abs(xAxis/L);
P1X = P2X(1:L/2+1);
P1X(2:end-1) = 2*P1X(2:end-1);

P2Y = abs(yAxis/L);
P1Y = P2Y(1:L/2+1);
P1Y(2:end-1) = 2*P1Y(2:end-1);

P2Z = abs(zAxis/L);
P1Z = P2Z(1:L/2+1);
P1Z(2:end-1) = 2*P1Z(2:end-1);

P1 = cat(2, P1X, P1Y, P1Z);
%% 
% Define the frequency domain |f| and plot the single-sided amplitude spectrum 
% |P1|.
f = Fs*(0:(L/2))/L;

%% plots
% line colors are x-axis(blue),y(red),z(yellow)
figure
    subplot(2,1,1)  %time domain plot part
plot(t,X(:,1:3))
title('original Signal')
xlabel('t (milliseconds)')
ylabel('X(t)')

   subplot(2,1,2)     %freq domain plot part 
plot(f,P1(:,3))         %plot only Z axis
xlim([4 inf])   %dont display freqs below 1 Hz!
title('Single-Sided Amplitude Spectrum of X(t) of Z-axis')
xlabel('f (Hz)')
ylabel('|P1(f)|')
% 
% find(f > 30, 1, 'first');
% P1(f > 30);

%save old stuff somehow
    temp1P1 = P1;
%temp1X = X;

%% get the amplitude means for each movement
for n=1:size(P1averages300_1800,2)
    mean_val_move(n) = mean(P1averages300_1800((start_idx:end),n));
end

% mean_val_move list per speed
% 0.0009    0.0017    0.0032    0.0026    0.0034    0.0037    0.0040

%% compare mean amplitude spectra %%
start_idx = find(f > 29, 1, 'first');      %f is always the last used frequency domain from accData_fft_plots
%careful! start_idx is bullshit if the sampleFreq is not around 320 Hz!

[max_val_move, idx] = max(P1averages300_1800(start_idx:end,speedIndex));    %idx has to be added by 30 to account for the disregared freqs
mean_val_move(speedIndex) = mean(P1averages300_1800(start_idx:end,speedIndex));

[max_val_vib, idx2] = max(temp1P1(start_idx:end,3));
max_val_vib_at_move = temp1P1(idx2+start_idx-1,3);
mean_val_vib = mean(temp1P1(start_idx:end,3));
meanRatio=mean_val_move(speedIndex)/mean_val_vib;

%first factor is the comparision of means, second is the comparision of peaks (regardless of frequency),
%third is the comparision of movment peak with vibrationpeak at the freq of
%the movement peak
%factors = [mean_val_move/mean_val_vib, max_val_move/max_val_vib, max_val_move/max_val_vib_at_move];

vibrationResults=[sampleFreq, mean_val_vib, max_val_vib , idx2+start_idx, meanRatio, speedIndex, amplitudeMultiplier]
