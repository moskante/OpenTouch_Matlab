function [concsound stim_time] = puresound(freq, amp, times)

%This function play a pure tone sound.The duration for which a given vector
%will play depends on the number of elements in the vector and the sampling
%rate. For example, a 1000-element vector, when played at 1 kHz, will last 
%1 second. When played at 500 Hz, it will last 2 seconds. Therefore, the 
%first choice you should make is the sampling rate you want to use. To  
%avoid aliasing, the sampling rate should be twice as large as the largest 
%frequency component of the signal. However, you may want to make it even 
%larger than that to avoid attenuation of frequencies close to the sampling 
%rate.
%
%freq = frequency
%
%example
%puresound(10, 20500, 3, 100)

%OR:
%Fs = 1000;      %# Samples per second
%toneFreq = 50;  %# Tone frequency, in Hertz
%nSeconds = 2;   %# Duration of the sound
%y = sin(linspace(0, nSeconds*toneFreq*2*pi, round(nSeconds*Fs)));

%For the experiment: concatenate short sounds with vvectors of zeros (same
%length)

%this must be fixed from trial by trial
%amp=10;         %amp = amplitude of the sound
fs=20500;       %fs = sampling frequency
duration=0.1;   %duration = duration of the bin

values=0:(1/fs):duration;
mysound = amp*sin(2*pi* freq*values);
silence = zeros(1, length(mysound));

%concatenation is a function of stimulus duration
concsound = repmat([mysound silence], 1, times);
tic
sound(concsound);
stim_time = toc;