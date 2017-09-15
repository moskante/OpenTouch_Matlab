function [out] = play_vibro(inputSignal, amplitude, silence)
%                           
% PLAY_VIBRO plays the inputSignal with a given amplitude and may include
% some silent phase before the sound is played.
%
% Version LM Theunissen: 13.09.2017

%% Settings

fs = 4000; % sampling frequency must be the same as in 'create_sound_file'

% set to new amplitude
mysound = inputSignal.*amplitude;

% figure
% plot(values,mysound)
% title('tractor output')
% ylabel('amplitude')
% xlabel('t  [sec]')
% mysound(mysound > 2) = 2;
% mysound(mysound < -2) = -2;

%% set silence 
if(silence > 0)
    % pause before sound
    skip = zeros(1, round(fs*silence));
    mysound = [skip, mysound'];
end

%% Play sound and set output
sound(mysound, fs);

out = struct('signal', mysound);




