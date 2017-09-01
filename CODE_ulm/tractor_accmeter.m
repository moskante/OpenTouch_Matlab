%close all serial ports
port = instrfind;
fclose(port())

%open accelerometer
accMeter = serial('COM14','BaudRate',115200);    %previous standart
fopen(accMeter);

% freq = [50, 100];
% amplitude = [0.05, 0.05]; 

%aim is to find a value so the resulting vibration amplitude on the fingertip is
%similar to the vibration during box movement 
amplitudeMultiplier = 12;

% % input for tractor for 300 speed
% % the tractor builds its input directly from the amplitude spectra
%  freq = round(f300(f300>30)*10)/10;
%  amplitude = P1average300(f300 > 30)*amplitudeMultiplier;
% %  amplitude = awgn(amplitude, 30);
% % amplitude(1:15) = amplitude(1:15)*5;

%input for tractor for 900 speed
% the tractor builds its input directly from the amplitude spectra
% freq = round(f900(f900>30)*10)/10;
% amplitude = P1average900(f900 > 30)*amplitudeMultiplier;

% input for tractor for 1600 speed
% the tractor builds its input directly from the amplitude spectra
% freq = round(f1600(f1600>30)*10)/10;
% amplitude = P1average1600(f1600 > 30)*amplitudeMultiplier;

% input for tractor for 2300 speed
% the tractor builds its input directly from the amplitude spectra
% freq = round(f2300(f2300>30)*10)/10;
% amplitude = P1average2300(f2300 > 30)*amplitudeMultiplier;

% input for tractor for 2900 speed
% the tractor builds its input directly from the amplitude spectra
freq = round(f2900(f2900>30)*10)/10;
amplitude = P1average2900(f2900 > 30)*amplitudeMultiplier;

%parameters needed for tractor duration
myLR= 12000; %desired distance
mySP= 900; %desired speed
duration = (myLR/15000)./(mySP/300);       
%example: 0.1500 and 0.0750 Vduration for 12000 and 6000 distance at 1600 speed
%duration = 1;
silence = 1.5;      %delay before starting the tractor

%generate sound function
out = envelope_vibro_LMT(freq, amplitude, duration, silence);

%accdata collection
accData = 0;
while (accData==0)  %error check, sometimes the frist fscan read doesnt work   
   accData = str2num(fscanf(accMeter));  % str2num converts the arduino string to integers
   % accData = str2num(fgetl(accMeter));
    accData = [accData, 0];
end

dataLength =500;  % 1000 datalength results in about ~3 sec of recording with the typical sampling rate of ~333Hz
accData = nan(dataLength, 4);

tic;
for i = 1:dataLength      
%    accTemp = [str2num(fscanf(accMeter)), toc];
%    accTemp = [accTemp, toc];                % add timestamp each line
   %accData = cat(1,accData,accTemp);        %aggregate data
   accData(i, :) = [str2num(fscanf(accMeter)), toc];
    %accData(i, :) = [str2num(fgetl(accMeter)),toc] ;
   %pause(0.001);    
end 
sampleFreq = dataLength/toc
fclose(accMeter);

% clear accData
% accData(:, 3) = out.signal';
% sampleFreq = 4000;