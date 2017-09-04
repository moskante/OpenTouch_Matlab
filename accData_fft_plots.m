%% 
% Specify the parameters of a signal with a sampling frequency and a signal duration

% part = 800:930;
% L = length(accData(part));     % Length of signal
% X = accData(part,3:5);

L = length(accData);     % Length of signal
X = accData(:,3:5);
%X = accData(:,1:3);

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

%%plots
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
temp1X = X;


% %filter test
%    d = fdesign.lowpass('Fp,Fst,Ap,Ast',3,5,0.5,40,100);
%    Hd = design(d,'equiripple');
%    output = filter(Hd,input);
% %where input is your input signal and output gives the filtered output.
% 
% %to see your filter response
%     fvtool(Hd)
% %see the spectrum of your signal aftering filtering.
%      plot(psd(spectrum.periodogram,output,'Fs',100))
