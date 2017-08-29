%Tactile speed from vibration and Noise 
%06.07.2015 AM did it
%This is the main code to run the noise/frequency speed discrimination task. The
%code control the sandpaper device (Motor: Faulhaber 3564K024B CS). In each
%trial, the motor moves twice (reference subject_cond_sess.txtand test stimulsubject_cond_sess.txtus). The order of
%the two stimuli is counterbalanced across trials.
%13.04.2016 modified for one finger, different motion direction
%290916 in move2[80:98] new method for reading the serial port (see)
%390916 in response tic and toc not print on shell

%% Prompt
prompt.quest = {'File name:', 'N# of Trials:'};
prompt.title = 'Speed Experiment';
prompt.nline = 1;
prompt.default = {'subject', '140'};
settings = inputdlg(prompt.quest, prompt.title, prompt.nline, prompt.default);

%% set and add path
cd('C:/Users/FSL/Documents/MATLAB/tactile_gravity')
addpath('C:/Users/FSL/Documents/MATLAB/tactile_gravity/figures_setup')
%saveto = strcat('C:/Users/FSL/Documents/MATLAB/tactile_gravity/results/',...
%    char(settings(1)));
%CHECK THIS!
saveto = strcat('C:/Users/FSL/Documents/MATLAB/tactile_gravity/orizzontale/',...
    char(settings(1)));
mkdir(saveto)
id = strcat(saveto,'/', char(settings(1)),'_responses.txt');
id2 = strcat(saveto,'/',char(settings(1)),'_handmotion.txt');

%% allocate the input and responses
stimuli = SpeedDesign_matrix();
ntrials = str2double(settings(2));
pause_trial = 70;
%pause_trial = 4;

exp.input = randomtrials(stimuli, 1);

exp.resp = zeros(ntrials, 2);                                    
exp.stimulus = zeros(ntrials, 6);
exp.condition = zeros(ntrials, 1);
exp.gright = zeros(ntrials, 1);

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
image(imread('button12-or.png'));
axis off

resp1 = figure('Color', 'black'); 
set(resp1, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
image(imread('button1-or.png'));
axis off

resp2 = figure('Color', 'black'); 
set(resp2, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
image(imread('button2-or.png'));
axis off

index = figure('Color', 'black'); 
set(index, 'Position', [0 0 screen_size(3) screen_size(4)], ...
    'DockControls', 'off','Menubar', 'none')
%image([0 0], [418 853], imread('finger-alpha.png')); 
image(imread('finger.png')); 
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
myformat = '%05d\t %05d\t %1u\t %1u\t %u\t %4.4f\n';   
myresults = fopen(id, 'wt');

%data log
accelerometer = fopen(id2, 'wt+');

%inizialize arduino board
%uno = arduino('COM5', 'uno');
uno = serial('COM5');
fopen(uno);
    
%open the serial port connection and move the motor to the home position
p1 = serial('COM1','BaudRate',57600);
%p1 = serial('/dev/tty.MCS78XX_Port0.0','BaudRate',57600);
%p1 = serial('/dev/ttyS0','BaudRate', 115200);
%p1 = serial('/dev/cu.usbserial-ftEGHNL6','BaudRate',57600);

openFlag = port_control(1,p1);
pause(1)
fprintf(p1,'EN\n');
fprintf(p1,'SP%i\n AC%i\n V%i\n', [4000 30000 0]);
pause(12)%long pause to open serial ports

%% Start the Experiment. Wait for button press to start the experiment
figure(waitstart)
start = waitforbuttonpress;

%Main loop to control the experiment
for k = 1:ntrials

    null = SpeedMove2(exp.input(k,1), exp.input(k,2), exp.input(k,3),...
                     exp.input(k,4:5),exp.input(k,6:7),exp.input(k, 8),...
                     index, blank, p1, uno, accelerometer, k);
    pause(1);
    
    figure(instr2);                                                   
    exp.resp(k, 1:2) = response();    
    
    %feedback on which pedal
    if(exp.resp(k, 1) == 0)
        figure(resp1);
    else
        figure(resp2);
    end
    pause(0.5);
    
    output = [exp.input(k, [1:3 8]) exp.resp(k, 1:2)];
    fprintf(myresults, myformat, output');
    
    if(k == ntrials)
        openFlag = port_control(0,p1);
        fclose(myresults);
        fclose(accelerometer);
        figure(theend);
        %clear uno
        fclose(uno);
    else
        if(k == pause_trial)
            figure(waitstart)
            start = waitforbuttonpress;
        end
    end
        
end
