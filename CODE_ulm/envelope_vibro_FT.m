function [out] = envelope_vibro_FT(freqSameAsSpeed, finalAmplitude, duration, silence)

%version: felix traub 28.08.2017

%This function play an envelope sound (sinusoidal times an envelope 
%function E(t). The duration for which a given vector
%will play depends on the number of elements in the vector and the sampling
%rate. For example, a 1000-element vector, when played at 1 kHz, will last 
%1 second. When played at 500 Hz, it will last 2 seconds. Therefore, the 
%first choice you should make is the sampling rate you want to use. To  
%avoid aliasing, the sampling rate should be twice as large as the largest 
%frequency component of the signal. However, you may want to make it even 
%larger than that to avoid attenuation of frequencies close to the sampling 
%rate.
%
%freq = frequency of vibrations
%env is 0 if no envelope and 1 for envelope
%envfreq = frequency of the envelope
%duration = duration of the stimulus in sec
%amplitude: valude between 0 and 1
%silence: duration of the blank interval before the stimulus, in sec
%
%example
%c = envelope_vibro(100, 1, 0, 10, 2);  ooold

%% generate sound for the different speeds (and distances?) beforehand
load('sound_input')
% load(f300,P1average300,...
%      f900,P1average900,...
%      f1600,P1average1600,...
%      f2300,P1average2300,...
%      f2900,P1average2900);

%amplitudeAdjuster (for 5 bins)
%with 5 recreated spectra
amplitudeAdjustment = [1 4.5 4.5 4.5 12];  
% with 5 equidistant factors between the extrema
%amplitudeAdjustment = linspace(1,12,5);   

%% sorting 14 speeds and the standard speed into 5 bins
if freqSameAsSpeed == 300 || freqSameAsSpeed == 500     %300SP bin       
        freq = round(f300(f300>30)*10)/10;
        amplitude = P1average300(f300 > 30)*amplitudeAdjustment(1);
    elseif freqSameAsSpeed == 700 || freqSameAsSpeed == 900 || freqSameAsSpeed == 1100          %900SP bin
        freq = round(f900(f900>30)*10)/10;
        amplitude = P1average900(f900 > 30)*amplitudeAdjustment(2);
    elseif freqSameAsSpeed == 1300 || freqSameAsSpeed == 1500 || freqSameAsSpeed == 1600 || freqSameAsSpeed == 1700 || freqSameAsSpeed == 1900 %1600SP bin
        freq = round(f1600(f1600>30)*10)/10;
        amplitude = P1average1600(f1600 > 30)*amplitudeAdjustment(3);
    elseif freqSameAsSpeed == 2100 || freqSameAsSpeed == 2300 || freqSameAsSpeed == 2500        %2300SP bin
        freq = round(f2300(f2300>30)*10)/10;
        amplitude = P1average2300(f2300 > 30)*amplitudeAdjustment(4);
    elseif  freqSameAsSpeed == 2700 || freqSameAsSpeed == 2900     %2900SP bin
        freq = round(f2900(f2900>30)*10)/10;
        amplitude = P1average2900(f2900 > 30)*amplitudeAdjustment(5);
end
%%%%%

fs = 4000;          %sampling frequency

%first we generate the vibration signal
values=0:(1/fs):duration;
for i = 1:length(freq)
    vibration = sin(2*pi*freq(i)*values)*amplitude(i);
    if i == 1
        mysound = vibration;
    else
%         mysound = mysound .* vibration;
        mysound = mysound + vibration;
    end
end

%% mulitply sound with the trial dependent Amplitude
mysound = mysound.*finalAmplitude;

% figure
% plot(values,mysound)
% title('tractor output')
% ylabel('amplitude')
% xlabel('t  [sec]')
% mysound(mysound > 2) = 2;
% mysound(mysound < -2) = -2;

if(silence > 0)
    %pause before sound
    tmp = 0:(1/fs):silence;
    skip = zeros(1, length(tmp));
    mysound = repmat([skip mysound], 1, 1);
end

% plot(values, envelope, values, vibration)
% plot(values, mysound)
% xlabel 'Time (s)', ylabel Waveform

vibrationDuration = tic;
sound(mysound, fs);
T = toc(vibrationDuration);
duration;
out = struct('duration', T, 'signal', mysound);