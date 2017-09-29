% %% save all Z-axis raw data somehow
% minlength= 320/2; %accData should  be shortend to a uniform length, accomodated for 320Hz fs
% P1_1050Raw = [temp1P1(1:minlength,3),temp2P1(1:minlength,3),...
%    temp3P1(1:minlength,3),temp4P1(1:minlength,3),temp5P1(1:minlength,3)];
% P1average1050 = mean(P1_1050Raw,2);



% %% manual data entry
% %L***= length of fft data, Fs***= sampling frequency, 
% %f***= frequency vector for plotting
% 
% % % for x speed - with spaces
% % % minLength = ;
% % % L = (minLength -1)*2;
% % % Fs = ;
% % % f  = Fs *(0:(L /2))/L ;


% P1averages300_1800= [P1average300, P1average550, P1average800, ...
%         P1average1050, P1average1300, P1average1550, P1average1800];


L = (minlength-1 )*2;
Fs = 330;       %one estimated Fs has to fit all
f  = Fs *(0:(L /2))/L ;



%%%% Plots to compare Amplitude Spectrum of the new 7 speeds %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%new speeds %[300  1050  1800  2550  3300  4050  4800]

%extraplot
figure

subplot(7,1,1)      %300
plot(f,P1average300) 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 300')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,2)      
plot(f,P1average550) 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 550')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,3)     
plot(f,P1average800) 
% hold on 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 800')
xlabel('f (Hz)')
ylabel('|P1(f)|')
% plot(f,P1average800_old)
% hold off

subplot(7,1,4)     
plot(f,P1average1050) %1050 standard stimulus
% hold on 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1050')
xlabel('f (Hz)')
ylabel('|P1(f)|')
% plot(f,P1average1050_old)
% hold off


subplot(7,1,5)      
plot(f,P1average1300) 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1300')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,6)      
plot(f,P1average1550) 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1550')
xlabel('f (Hz)')
ylabel('|P1(f)|')

subplot(7,1,7)      %1800
plot(f,P1average1800) 
xlim([2 inf])   %dont display freqs below 1Hz!
ylim([0 0.015]) %same amplitude scale for all speeds
title('--MEAN--  Amplitude Spectrum of X(t) for speed 1800')
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