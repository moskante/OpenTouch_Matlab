function [out] = envelope_vibro(freq, amplitude, env, envfreq, duration, silence)

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
%duration = duration of the stimulus
%amplitude: valude between 0 and 1
%silence: duration of the blank interval before the stimulus
%
%example
%c = envelope_vibro(100, 1, 0, 10, 2);

fs = 4000;          %sampling frequency

%first we generate the vibration signal
values=0:(1/fs):duration;
vibration = sin(2*pi*freq*values)*amplitude;

%then we create the envelope of unitary amplitude
envelope = sin(2*pi*envfreq*values);

%the signal played it equal to the element by elment product of the
%sinusoid and the envelope
if(env == 0)
    mysound = vibration;
else
    mysound = vibration .* envelope;
end

if(silence > 0)
    %pause before sound
    tmp = 0:(1/fs):silence;
    skip = zeros(1, length(tmp));
    mysound = repmat([skip mysound], 1, 1);
end

%plot(values, envelope, values, vibration)
%plot(values, mysound)
%xlabel 'Time (s)', ylabel Waveform

tic
sound(mysound, fs);
T = toc;

out = struct('duration', T, 'signal', mysound);