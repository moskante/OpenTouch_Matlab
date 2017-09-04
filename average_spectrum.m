% % get mean of the 5 last amplitude spectra
minLength = min([length(temp1P1),length(temp2P1),length(temp3P1),length(temp4P1),length(temp5P1)]);
P1new= mean([temp1P1(1:minLength, 3), temp2P1(1:minLength, 3), temp3P1(1:minLength, 3),...
    temp4P1(1:minLength, 3),temp5P1(1:minLength, 3)], 2);
P1average300=P1new;
%manual data entry
%L***= length of fft data, Fs***= sampling frequency, 
%f***= frequency vector for plotting

%for x speed - with spaces
minLength = ;
L = (minLength -1)*2;
Fs = 332.5865;
f  = Fs *(0:(L /2))/L ;

%for ---SHORT TEST --- 300 speed 
minLength300short = 47;
L300short = (minLength300short -1)*2;
Fs300short = 326.3595;
f300short  = Fs300short *(0:(L300short /2))/L300short ;

%for 300 speed 
minLength300 = 277;
L300 = (minLength300 -1)*2;
Fs300 = 333.6063;
f300  = Fs300 *(0:(L300 /2))/L300 ;

%for 1050 speed
minLength = ;
L = (minLength -1)*2;
Fs = 332.5865;
f  = Fs *(0:(L /2))/L ;

%for 1800 speed
minLength1800 = 277;
L1800 = (minLength1800 -1)*2;
Fs1800 = 332.5865;
f1800  = Fs1800 *(0:(L1800 /2))/L1800 ;

%for 2550 (standart) speed
minLength2550= 277;
L2550= (minLength2550-1)*2;
Fs2550= 333.0703;
f2550 = Fs2550*(0:(L2550/2))/L2550;

%for 3300 speed 
minLength3300 = 277;
L3300 = (minLength3300 -1)*2;
Fs3300 =  333.3509;
f3300  = Fs3300 *(0:(L3300 /2))/L3300 ;

%for 4050 speed 
minLength4050 = 276;
L4050 = (minLength4050 -1)*2;
Fs4050 =   332.4589;
f4050  = Fs4050 *(0:(L4050 /2))/L4050 ;

%for 4800 speed 
minLength4800 = 277;
L4800 = (minLength4800 -1)*2;
Fs4800 = 332.9824;
f4800  = Fs4800 *(0:(L4800 /2))/L4800 ;





%%%% Plots to compare Amplitude Spectrum of the new 7 speeds %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%new speeds %[300  1050  1800  2550  3300  4050  4800]

%extraplot
figure

subplot(2,1,1)
plot(f300short,P1average300short) 
xlim([4 inf])   %dont display freqs below 1Hz!
%ylim([0 0.03]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 300')
xlabel('f (Hz)')
ylabel('|P1(f)|')



subplot(2,1,2)      %300
plot(f300,P1average300) 
xlim([1 inf])   %dont display freqs below 1Hz!
%ylim([0 0.03]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 300')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,2)      %1050
plot() 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.02]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1050')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,3)      %1800
plot(f1800,P1average1800) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.02]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1800')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,4)      %2550
plot(f2550,P1average2550) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.02]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 2550')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,5)      %3300
plot(f3300,P1average3300) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.02]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 3300')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,6)      %4050
plot(f4050,P1average4050) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.02]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 4050')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,7)      %4800
plot(f4800,P1average4800) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.02]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 4800')
xlabel('f (Hz)')
ylabel('|P1(f)|')




% max(P1average300(f300>30  ))
% max(P1average1600(f1600>30  ))
% max(P1average2900(f2900>30  ))

% %inverse fourier transform - disregard any frequencys below 30Hz!
% %Z300 will be the reconstructed input into the tractor
% % find(f300 > 30, 1, 'first') returns the datapoint where the 30Hz
% % threshold of the amplitude spectrum is reached
% reconstructedZ300 = ifft(P1average300( [find(f300 > 30, 1, 'first')]  :end));
% reconstructedZ1600 = ifft(P1average1600( [find(f1600 > 30, 1, 'first')]  :end));
% reconstructedZ2900 = ifft(P1average2900( [find(f2900 > 30, 1, 'first')]  :end));
% 
% %length of the 30Hz filtered reconstruced signals
% newlength300 = length(P1average300) - [find(f300 > 30, 1, 'first')];
% length (reconstructedZ300);
% length (t1600);
% %time vertors
% t300 = 0:1/Fs300:(L300-1)/Fs300;
% t1600 = 0:1/Fs1600:(L1600-1)/Fs1600;
% t2900 = 0:1/Fs2900:(L2900-1)/Fs2900;
% 
% subplot(6,2,1)
% plot(reconstructedZ300,t300)
% title('reconstructed Z signal for speed 2900')
% xlabel('t')
% ylabel('Z signal')
% 
% subplot(6,2,2)
% plot(reconstructedZ1600,t1600)
% title('reconstructed Z signal for speed 2900')
% xlabel('t')
% ylabel('Z signal')
% 
% subplot(6,2,3)
% plot(reconstructedZ2900,t2900)
% title('reconstructed Z signal for speed 2900')
% xlabel('t')
% ylabel('Z signal')