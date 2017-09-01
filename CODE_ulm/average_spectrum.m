% % get mean of the 5 last amplitude spectra
% % minLength = min([length(temp1P1),length(temp2P1),length(temp3P1),length(temp4P1),length(temp5P1)]);
% % P1new= mean([temp1P1(1:minLength, 3), temp2P1(1:minLength, 3), temp3P1(1:minLength, 3),...
% %     temp4P1(1:minLength, 3),temp5P1(1:minLength, 3)], 2);

%manual data entry
%L***= length of fft data, Fs***= sampling frequency, 
%f***= frequency vector for plotting


%for 300 speed
% f for 300 is from part 4, with 914 data length and 333.9029 samplingrate
L300 = 914;
Fs300= 333.9029;
f300 = Fs300*(0:(L300/2))/L300;

%for 900 speed
% f for 900 is from part4 , with 272 data length and 338.0601 samplingrate
L900 = (284-1)*2;       %take accdata length not P1 length
Fs900= 338.0601;
f900 = Fs900*(0:(L900/2))/L900;

%for 1600 speed
% f for 1600 is from part 5, with 491 data length and  342.1908 samplingrate
L1600 = 491;
Fs1600 =  342.1908;
f1600 = Fs1600*(0:(L1600/2))/L1600;

%for 2300 speed
% f for 2300 is from part 5, with 231 data length and  337.6646 samplingrate
L2300 = (231)*2;      %take accdata length not P1 length
Fs2300 = 337.6646;
f2300 = Fs2300*(0:(L2300/2))/L2300;

%for 2900 speed
% f for 1600 is from part 3, with 192 data lenth and  354.0243 samplingrate
L2900 = (192-1)*2;
Fs2900 = 342.2324;
f2900 = Fs2900*(0:(L2900/2))/L2900;




%%%% Plots to compare Amplitude Spectrum of 3 speeds
figure
subplot(5,1,1)      %300
plot(f300,P1average300) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.008]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 300')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(5,1,2)      %900
plot(f900,P1average900) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.008]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 900')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(5,1,3)      %1600
plot(f1600,P1average1600) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.008]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1600')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(5,1,4)      %2300
plot(f2300,P1average2300) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.008]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 2300')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(5,1,5)      %2900
plot(f2900,P1average2900) 
xlim([1 inf])   %dont display freqs below 1Hz!
ylim([0 0.008]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 2900')
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