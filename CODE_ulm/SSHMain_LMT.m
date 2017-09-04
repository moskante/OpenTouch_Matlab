% Short path speed discrimination task 
% 27.04.2017 AM did it
% This is the main code to run the short-speed discrimination task. The
% code control the belt device (Motor: Faulhaber 3242G024C). 
% In each trial, the motor motor twice, either clockwise or counterclockwise
% for a pseudo-random path length and SP. After each trial, the participant 
% reports in which of the two intervals the surface was moving faster 
% by pressing the left or right mouse button.
%
% Version LM Theunissen: 17.08.2017

%% Prompt (dialog box at the beginning)
prompt.quest = {'File Name:', 'N# of Trials:', 'Block:'};
prompt.title = 'Speed Experiment';
prompt.nline = 1;
prompt.default = {'subject', '270', '1'};
settings = inputdlg(prompt.quest, prompt.title, prompt.nline, prompt.default);

%% set and add path
cd('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/CODE')
addpath('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/FIGURES')
saveto = strcat('C:/Users/CecileScotto/Documents/MATLAB/Alessandro/DATA/',...
    char(settings(1)));
mkdir(saveto)
id = strcat(saveto,'/',char(settings(1)), '_', char(settings(3)),'_responses.txt');
id2 = strcat(saveto,'/',char(settings(1)), '_', char(settings(3)),'_handmotion.txt');
id3 = strcat(saveto,'/',char(settings(1)), '_', char(settings(3)),'_faulhaber.txt');

%% allocate the input and responses
SP = str2double(settings(3));
stimuli = SSHDesign_matrix();
ntrials = str2double(settings(2));
pause_trial = 180;

exp.input = randomtrials(stimuli, 1);  % ramdomize order of trials

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

blank = figure('Color', 'black');
set(blank, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
axis off


%% Open serial port connections                                                        
%myformat = '%03d\t %u\t %u\t %2.1f\t %3.0f\t %3.0f\t %u\t %4.0f\n';   
myformat = '%03d\t %03d\t %u\t %u\t %u\t %4.0f\n';   

myresults = fopen(id, 'wt');

%data log 
% 'wt+' =Open or create new file for reading and writing in text mode. 
accelerometer = fopen(id2, 'wt+');   %'wt+' = open file for writing in textmode

%faulhaber
faulhaber = fopen(id3, 'wt+');

%inizialize arduino board
%uno = arduino('COM5', 'uno');
uno = serial('COM13');
fopen(uno);
    
%open the serial port connection and move the motor to the home position
p1 = serial('COM8','BaudRate',57600);
openFlag = faulhaber_control(1,p1,1,1,20000);

fprintf(p1,'V0\n');

%% Start the Experiment. Wait for button press to start the experiment
figure(waitstart)
start = waitforbuttonpress;

%Main loop to control the experiment.
for k = 1:ntrials
    %[POS0, X] = readPOS(p1, POS1, faulhaber);
    
    %read n-1 position
    %simplyfy the input...
    null = SSHMove_LMT(exp.input(k,1:2), exp.input(k,3:4),...
                    exp.input(k,5:6), exp.input(k,7:8),exp.input(k,9),...
                    index, blank, p1, uno, accelerometer, k);
    %SSHMove(myLR, mySP, VF, VA, rfirst,fingerFIG, ...
    %blankFIG, p1, arduino_board, serial_id, trial)
    pause(1.5);
    
    figure(instr2);
    %[POS1, LR] = readPOS(p1, POS0, faulhaber);                           %read actual position
    
    %check next LR and move back to starting  position...
    fprintf(p1,'LA%i\n M\n', 0);
    exp.resp(k, 1:2) = response();    
    
    %feedback on which pedal
    if(exp.resp(k, 1) == 0)
        figure(resp1);
    else
        figure(resp2);
    end
    pause(0.5);
    
    %output = [exp.input(k, 1:4) POS0 LR exp.resp(k, 1:2)];
    output = [exp.input(k, 1:4) exp.resp(k, 1:2)];
    fprintf(myresults, myformat, output');
    
    if(k == ntrials)
        figure(theend);
        fprintf(p1,'LA%i\n M\n', 0);
        pause(1)
        openFlag = faulhaber_control(0,p1,1,1,20000);
        fclose(myresults);
        fclose(accelerometer);
        fclose(faulhaber);
        %clear uno
        fclose(uno);
    else
        if(k == pause_trial)
            figure(waitstart)
            start = waitforbuttonpress;
        end
    end
        
end
