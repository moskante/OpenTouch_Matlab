% Short path speed discrimination task
% 27.04.2017 AM did it
% This is the main code to run the short-speed discrimination task. The
% code control the belt device (Motor: Faulhaber 3242G024C).
% In each trial, the motor motor twice, either clockwise or counterclockwise
% for a pseudo-random path length and SP. After each trial, the participant
% reports in which of the two intervals the surface was moving faster
% by pressing the left or right mouse button.
%
% latest Version LM Theunissen, felix traub 14.9.2017
%  

%% Close all serial ports and clear data
port = instrfind;
fclose(port());
close ('all')

clear
clc

%% Prompt (dialog box at the beginning)
prompt.quest = {'File Name:', 'N# of Trials:', 'Block:'};
prompt.title = 'Speed Experiment';
prompt.nline = 1;
prompt.default = {'subject_1', '336', '1'};
settings = inputdlg(prompt.quest, prompt.title, prompt.nline, prompt.default);

%% set and add path
cd('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/CODE')
addpath('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/FIGURES')
saveto = strcat('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/DATA/Pilot'); % ,...
% char(settings(1)));       
%seperate folder for all pilot measurements, adjust for actual experiment! 
mkdir(saveto)
date_str = datetime;
date_str.Format = 'yyMMdd';
id  = strcat(saveto,'/',char(settings(1)), '_', char(date_str), '_', char(settings(3)),'_responses.txt');
id2 = strcat(saveto,'/',char(settings(1)), '_', char(date_str), '_', char(settings(3)),'_handmotion.txt');
id3 = strcat(saveto,'/',char(settings(1)), '_', char(date_str), '_', char(settings(3)),'_faulhaber.txt');

%% allocate the input and responses
SP = str2double(settings(3));
stimuli = SSHDesign_matrix_FT();    %*_FT felix version for 7 speeds (1 amplitude condition) => 168 trials
% ntrials = str2double(settings(2)); % defined later!
nTrainingTrials = 5; % number of Training trials

exp.input = randomtrials(stimuli, 2);  % ramdomize order of trials, do 2 times the complete 168 trials
if nTrainingTrials > 0
    temp = randi(length(stimuli));
    exp.input = [exp.input(temp:temp+nTrainingTrials-1, :); exp.input];  % ramdomize order of trials, do 2 times the complete 168 trials
end

ntrials = length(exp.input); % get trial number
%ntrials = 10;      %for testing
pause_trial =nTrainingTrials:50:ntrials;  %pause after training trails, then every 50 trials

exp.resp = zeros(ntrials, 2);
exp.stimulus = zeros(ntrials, 6);
POS0 = 999;
POS1 = 999;

%% Defines Screen 1-6
screen_size = get(groot,'ScreenSize');

waitstart = figure('Color', 'black');
text(0.3, 0.5, 'Press a button to start', 'FontSize', 30, 'Color', 'white')
% image(imread('start.png'));
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

theend = figure('Color', 'black');
%image(imread('theEnd.png'));
text(0.3, 0.5, 'End of the Experiment', 'FontSize', 30,'Color', 'white')
set(theend, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off

resetFig = figure('Color', 'black');
%image(imread('theEnd.png'));
text(0.3, 0.5, '   reset position', 'FontSize', 30, 'Color', 'white')
set(resetFig, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off

toomuch = figure('Color', 'black');
text(0.3, 0.5, '  too much pressure!', 'FontSize', 30, 'Color', 'red')
set(toomuch, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off

blank = figure('Color', 'black');
set(blank, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off




%% load soundinput file
load('sound_input_final.mat');

%% Open serial port connections
%myformat = '%03d\t %u\t %u\t %2.1f\t %3.0f\t %3.0f\t %u\t %4.0f\n';
myformat = '%03d\t %03d\t %u\t %u\t %u\t %u\t %u\t %7.4f\t %u\n';

myresults = fopen(id, 'wt');

%data log
% 'wt+' =Open or create new file for reading and writing in text mode.

%faulhaber
faulhaber = fopen(id3, 'wt+');

%open the serial port connection and move the motor to the home position
motor = serial('COM8','BaudRate',57600);
openFlag = faulhaber_control(1,motor,1,1,20000);
fprintf(motor,'V0\n');
fprintf(motor,'SP%i\n LA%i\n M\n', [2550, 0]);

%inizialize arduino board (forceplate)
forceplate = serial('COM13');
fopen(forceplate);
set(forceplate,'Timeout',1);

% % accelerometer arduino (no accmeter needed for actual testing
% accMeter = serial('COM14','BaudRate',115200);    %previous standard
% fopen(accMeter);
% set(accMeter,'Timeout',1);      %reduce read timeout time from 10 to 1 [sec]



%% Start the Experiment. Wait for button press to start the experiment
figure(waitstart)
start = waitforbuttonpress;

%Main loop to control the experiment.
for k = 1:ntrials
    %simplyfy the input...
    null = SSHMove_pilot(exp.input(k,1:2), exp.input(k,3:4),...
        exp.input(k,5:6), exp.input(k,7:8),exp.input(k,9),...
        index, blank, toomuch, motor, forceplate, k, mysound);
    %SSHMove(myLR, mySP, VF, VA, rfirst,fingerFIG, ...
    %blankFIG, p1, arduino_board, serial_id, trial)
    
    %     (myLR, mySP, VF, VA, rfirst,...
    %     fingerFIG, blankFIG, motor, forceplate, trial)
    pause(1.5);
    
    figure(instr2);
    
    %[POS1, LR] = readPOS(p1, POS0, faulhaber);                           %read actual position
    
    startTime = GetSecs;
    % getkey returns the keycode of a following keypress, (here 49=1; and 50=2)
    RestrictKeysForKbCheck([49,50,97,98]);
    
    waitforbuttonpress;
    [endTime, response] = KbWait;
    if response(97) == 1 || response(49) == 1      % 97 or 49= key 1
        exp.resp(k, 2) = 1;
    elseif response(98) == 1 || response(50) == 1  % 98 or 50 = key 2
        exp.resp(k, 2) = 2;
    end
    exp.resp(k, 1) = endTime - startTime;

    %  feedback on which pedal
    if(exp.resp(k, 2) == 1)
        figure(resp1);
    else
        figure(resp2);
    end
       pause(0.2);
    
    figure(resetFig)
    %  move back to starting  position...
    fprintf(motor,'SP%i\n LA%i\n M\n', [2550, 0]);
    pause(0.5);

    if k > nTrainingTrials
        output(k, :) = [exp.input(k, [1:4, 7:9]), exp.resp(k, 1:2)];
        fprintf(myresults, myformat, output(k, :)');
    end
     
    if(k == ntrials)
        figure(theend);
        fprintf(motor,'LA%i\n M\n', 0);
        pause(1)
        openFlag = faulhaber_control(0,motor,1,1,20000);
        fclose(myresults);
        %         fclose(accelerometer);
        fclose(faulhaber);
        fclose(forceplate);
        save([id(1:end-3), 'mat'], 'output');
    else
        if any(k == pause_trial)
            figure(waitstart)
            start = waitforbuttonpress;
        end
    end
end
