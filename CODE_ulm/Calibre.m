cd('C:/Users/FSL/Documents/MATLAB/tactile_gravity/CODE')
addpath('C:/Users/FSL/Documents/MATLAB/tactile_gravity/FIGURES')
saveto = strcat('C:/Users/FSL/Documents/MATLAB/tactile_gravity/DATA/slipV/CALIBRATION');
%mkdir(saveto)

%save data here
id = strcat(saveto,'/','calibration.txt');
myformat = '%3d\t %3d\t %3f\t %3u\t %3u\n';   
myresults = fopen(id, 'a');

%inizialize arduino board
uno = serial('COM5');
fopen(uno);

%open the serial port connection and move the motor to the home position
p1 = serial('COM1','BaudRate',57600);
openFlag = port_control(1,p1);
pause(1)

fprintf(p1,'EN\n');
fprintf(p1,'SP%i\n AC%i\n DEV%i\n V%i\n', [4000 30000 10 0]);
pause(2)

ISI = 1;
speedCW = [51 180 308 437 566 694 823]';
speedCCW = [-52 -183 -312 -443 -572 -699 -827]';

adjust = [1.5/100 1.4/100 1.4/100 1.4/100 1/100 0.7/100 0.5/100]';
prompt = 'Type displacement value';
x = [speedCW speedCCW adjust zeros(7,1) zeros(7,1)];

% tstart = tic;
% fprintf(p1,'V%i\n', -437);
% toc(tstart);
% 
% fprintf(p1,'V%i\n', 0);


%OK <--
%time = CalibreMove2(51, 20, p1, uno, ISI, 1.4/100);
%time = CalibreMove2(-52, 20, p1, uno, ISI, 1.4/100);

%time = CalibreMove2(180, 20, p1, uno, ISI, 1.4/100);
%time = CalibreMove2(180, 20, p1, uno, ISI, 1.4/100);

%time = CalibreMove2(308, 20, p1, uno, ISI, 1.4/100);
%time = CalibreMove2(308, 20, p1, uno, ISI, 1.4/100);

%OK <--
%time = CalibreMove2(437, 20, p1, uno, ISI, 0.5/100);
%time = CalibreMove2(-439, 20, p1, uno, ISI, 0.5/100);

%gain = 0
time = CalibreMove2(-439, 10, p1, uno, ISI, 0);

%time = CalibreMove2(566, 20, p1, uno, ISI, 1/100);
%time = CalibreMove2(566, 20, p1, uno, ISI, 1/100);

%time = CalibreMove2(694, 20, p1, uno, ISI, 0.7/100);
%time = CalibreMove2(694, 20, p1, uno, ISI, 0.7/100);

%OK <--
%time = CalibreMove2(823, 20, p1, uno, ISI, 0.5/100);
%time = CalibreMove2(-827, 20, p1, uno, ISI, 0.5/100);


%back to home position
%CalibreMove3(0, 437, p1, ISI, 1);

%position control
%CalibreMove3(20000, 437, p1, ISI);

% for k = 7:7
%     CalibreMove2(x(k,1), 1, p1, uno, ISI, x(k,3));
%     x(k,4) = input(prompt);
%     
%     CalibreMove2(x(k,2), 1, p1, uno, ISI, x(k,3));
%     x(k,5) = input(prompt);
% end

fprintf(myresults, myformat, x');

%close all
fclose(myresults);
openFlag = port_control(0,p1);
fclose(uno);