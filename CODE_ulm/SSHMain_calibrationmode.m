%Short path speed discrimination task 
%27.04.2017 AM did it
%28.08.2017 edited by felix traub 

%This is the main code to run the short-speed discrimination task. The
%code control the belt device (Motor: Faulhaber 3242G024C). 
%In each trial, the motor motor twice, either clockwise or counterclockwise
%for a pseudo-random path length and SP. After each trial, the participant 
%reports in which of the two intervals the surface was moving faster 
%by pressing the left or right mouse button.

% Close all serial ports
port = instrfind;
fclose(port())
close ('all')

%% Prompt (dialog box at the beginning)
% prompt.quest = {'File Name:', 'N# of Trials:', 'Block:'};
% prompt.title = 'Speed Experiment calibration';
% prompt.nline = 1;
% prompt.default = {'calibration', '1', '1'};
% settings = inputdlg(prompt.quest, prompt.title, prompt.nline, prompt.default);
% 
% %% set and add path
% cd('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/CODE')
% addpath('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/FIGURES')
% saveto = strcat('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/DATA/',...
%     char(settings(1)));
% %mkdir(saveto)   %sometimes reslts in timeouts!
% id = strcat(saveto,'/',char(settings(1)), '_', char(settings(3)),'_responses.txt');
% id2 = strcat(saveto,'/',char(settings(1)), '_', char(settings(3)),'_handmotion.txt');
% id3 = strcat(saveto,'/',char(settings(1)), '_', char(settings(3)),'_faulhaber.txt');

%% allocate the input and responses
% SP = str2double(settings(3));
%stimuli = SSHDesign_matrix_FT();       % no designmatrix in calibration mode
%manual stimulus input template:
% -12000       12000        1600         300         100         100           1           1           0
%distance1    distance2     speed1      speed2   vibrationFreq1  vFreq2 amplitude1 amplitude2  intervalOrder 
                    %speed1 is usually 1600 (comparison stimulus)
stimuli =  [12000   12000     300      300      300      300        1       1        0;];
%new speeds %[300  1050   1800  2550  3300  4050  4800]
           
ntrials = size(stimuli,1);
pause_trial = 180;

%exp.input = stimuli;
%exp.input = randomtrials(stimuli, 1);  % ramdomize order of trials
exp.resp = zeros(ntrials, 2);                                    
exp.stimulus = zeros(ntrials, 6);
POS0 = 999;
POS1 = 999;


%% Defines Screen 1-6
screen_size = get(groot,'ScreenSize');

waitstart = figure('Color', 'black');
text(0.3, 0.5, 'Press a button to start', 'FontSize', 30, 'Color', 'white')
%image(imread('start.png'));
set(waitstart, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off

instr2 = figure('Color', 'black'); 
set(instr2, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
image(imread('button12.png'));
axis off

resp1 = figure('Color', 'black'); 
set(resp1, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
image(imread('button1.png'));
axis off

resp2 = figure('Color', 'black'); 
set(resp2, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
image(imread('button2.png'));
axis off

index = figure('Color', 'black'); 
set(index, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
%image([0 0], [418 853], imread('finger-alpha.png')); 
image(imread('finger-right.png')); 
axis off

blank = figure('Color', 'black');
set(blank, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off

theend = figure('Color', 'black');
%image(imread('theEnd.png'));
text(0.3, 0.5, 'End of the Experiment', 'FontSize', 30,'Color', 'white')
set(theend, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off

%% Open serial port connections                                                        
%myformat = '%03d\t %u\t %u\t %2.1f\t %3.0f\t %3.0f\t %u\t %4.0f\n';   
myformat = '%03d\t %03d\t %u\t %u\t %u\t %4.0f\n';   

myresults = fopen(id, 'wt'); %'wt+' = open file for writing in textmode

%data log 
% 'wt+' =Open or create new file for reading and writing in text mode. 
datalog = fopen(id2, 'wt+');   

%faulhaber
faulhaber = fopen(id3, 'wt+');

%inizialize forceplate arduino board
%uno = arduino('COM5', 'uno');
forceplate = serial('COM13');
fopen(forceplate);
set(forceplate,'Timeout',1);

% accelerometer arduino 
accMeter = serial('COM14','BaudRate',115200);    %previous standard
fopen(accMeter);
set(accMeter,'Timeout',1);      %reduce read timeout time from 10 to 1 [sec]


%open the serial port connection and move the motor to the home position
motor = serial('COM8','BaudRate',57600);
openFlag = faulhaber_control(1,motor,1,1,20000);
fprintf(motor,'V0\n');

%% Start the Experiment. Wait for button press to start the experiment
figure(waitstart)
start = waitforbuttonpress;

%Main loop to control the experiment.
for k = 1:ntrials
    %[POS0, X] = readPOS(p1, POS1, faulhaber);
    
    %read n-1 position
    %simplyfy the input...
    [null, accData, sampleFreq] = SSHMove_calibration(exp.input(k,1:2), exp.input(k,3:4),...
                    exp.input(k,5:6), exp.input(k,7:8),exp.input(k,9),...
                    index, blank, motor, forceplate, datalog, k, accMeter);
    %SSHMove(myLR1+2, mySP1+2,
    %VibrationFreq1+2, 
    %VibrationAmp1+2, 
    %rfirst,
    %fingerFIG,blankFIG, p1, arduino_board, serial_id, trial#,accMeter)
    pause(0.5);
      
    %figure(instr2);
    %[POS1, LR] = readPOS(p1, POS0, faulhaber);                           %read actual position
   

f = figure(instr2);

% %getkey returns the keycode of a following keypress, (here 49=1; and 50=2)
% KbCheck;
% RestrictKeysForKbCheck([49,50,1,2]);
% validkey = 0;
% responsetime = tic;
%     while validkey ~=1
%         response=getkey;
%         if response == 49       %49= key 1
%             exp.resp(k,2)=1;
%             validkey = 1;
%         elseif response == 50   %50 = key 2
%             exp.resp(k,2)=2;
%             validkey = 1;
%         end     % still records spam key presses into editor!
%     end
% exp.resp(k,1)  = toc(responsetime);
% RestrictKeysForKbCheck([]);
%        
%     %feedback on which pedal
%     if(exp.resp(k, 2) == 1)
%         figure(resp1);
%     else
%         figure(resp2);
%     end
%     pause(1);
%     %check next LR and move back to starting  position...
%     fprintf(motor,'LA%i\n M\n', 0);
%     
%     %output = [exp.input(k, 1:4) POS0 LR exp.resp(k, 1:2)];
%     output(k, :) = [exp.input(k, 1:4) exp.input(k, 7:9) exp.resp(k, 1:2)];
%     %distance1 distance2 speed1 speed2...
%     %amplitude1 amplitude2 intervalOrder...
%     %responseTime responseKey
%     fprintf(myresults, myformat, output');
    
    if(k == ntrials)         %50 trial bock for time stopping
        figure(theend);
        pause(1)
        fprintf(motor,'LA%i\n M\n', 0);
        openFlag = faulhaber_control(0,motor,1,1,20000);
        fclose(myresults);
        fclose(datalog);
        fclose(faulhaber);
        %clear uno
        fclose(forceplate);
        fclose(accMeter);
    else
        if(k == pause_trial)
            figure(waitstart)
            start = waitforbuttonpress;
        end
    end
        
end

close all