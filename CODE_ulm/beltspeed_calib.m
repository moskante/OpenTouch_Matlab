%adapted from ceciles 'velocity_calib'
port = instrfind;
fclose(port());
close ('all')
% function [CMStoRPM]=beltspeed_calib
% calibration of the belt velocity
%Commands such as NP and NV do not work with this Matlab code.

%printout:  1 to print the motion profile on the output file 0 in the
%           Matlab workspace
% subject = 1;
repetitions = 1;  %number of repetitions (the more repetitions the smaller the error caused by the deceleration phase.
beltperimeter=54.9*repetitions; %testpurpose according to tape measure (on top of tape): 
                    % between 55.9cm for [rough belt(2mm)]
                    % 54.9cm for [[rough belt (1mm)]
                    % 55.1cm for [flat belt]
                    % and 54.0cm (no belt, on top of metal roller) 
                    
%targetpostion=819000*repetitions; %default:830000 something like targetdistance
                    % 75000 is about one rotation of the motor
                    % 810000 is about one rotation of the belt (with 55.9cm beltperimenter and the 2mm belt )
                    % 819000 is one rotation of the belt (with 54.9cm beltperimenter and the 1mm belt
                    % xx is one rotation of the belt (with 55.1cm beltperimenter and the flat belt
targetspeed = 1800;  % 300         550         800        1050        1300        1550        1800
targetposition = 12000;

    %==> with a CMStoRPM constant of about 298.4329 , 1cm/s =~ 298 "speed" [RPM]
    %          INACCURATE!!                          16cm/s =~ 4775  "speed" [RPM]             
acceleration=30000;  %max=30000 (says manual), too small accs dont let the calibration terminate because of the if-clause in the loop
deceleration=30000;     % does this even do something?
printout=1;
%% trialsindex for durationaggregate
mySP=targetspeed; myLR=targetposition;
speedIndex = find(mySP == 300:250:1800); %which speed from 1-7   see [300  1050   1800  2550  3300  4050  4800]
distanceIndex = (abs(myLR)/6000)-1;    %0 for 6000 myLR, 1 for 12000 myLR
trialIndex =(speedIndex+(distanceIndex*7)); % +7 for 12000 distance,+0 for 6000 ->1-14 vector

%% different belts have to be considered
belt_Type={'Rough'}; %'Smooth'

data_name=[belt_Type{:} '_belt_Calib_Subject#' num2str(subject) '_' date '.txt'];

test = 'test';
belt = serial('COM8','BaudRate',57600);  %the port name depend on the platform
fopen(belt);                             %belt ist the fileID
mprofile = fopen(data_name, 'a');   % 'a' is for appending data to the end of the file

fprintf(belt,'POS\n');      %get belt position and put it into output.start file?
output.start = str2double(fscanf(belt));

theoreticalDuration = (abs(targetposition/15000))./(targetspeed/300);
targetIteration = theoreticalDuration*1000;

%commands for the motor
fprintf(belt,'HO\n');
fprintf(belt,'AC%i\n', acceleration); %are these short variables short commands for the motor control?                                        
fprintf(belt,'DEC%i\n', deceleration);
fprintf(belt,'LR%i\n', targetposition); % =>'LR810000' increment the motor to position 810000
fprintf(belt,'SP%i\n', targetspeed); 
fprintf(belt,'M\n');  % command to initiate motion

% fprintf(belt,'HO\n');
% fprintf(belt,'v%i\n', targetspeed); 
% % fprintf(belt,'M\n');  % command to initiate motion
% % 
% % pause(theoreticalDuration) 
% % 
% % fprintf(belt,'v0\n'); 
% % fprintf(belt,'M\n');  % command to initiate motion
t0 = tic;


test = 0;
while (1)            %old loop
    test = test +1;
  
    fprintf(belt,'POS\n'); %Get actual/current Position
    currentPOS = str2double(fscanf(belt));  %read current postion from belt
    output.decPOS = targetposition - ((targetspeed^2)/(acceleration)); %what does this do?
    
%     if(cPOS >= output.decPOS && flag == 0)
%       fprintf(p1,'DEC%i\n', ramp);
%       fprintf(p1,'M');
%       output.tdec = toc(t0);
%       flag = 1;
%     end

    fprintf(belt,'gv\n');   %get velocity, same metric as "speed"?
    velocity = str2double(fscanf(belt));

    %printout to write the file
    %['actual velocity', 'target velocity', time[sec] since start,..
    %'"increments" of the motor','target "increments"']
    A = [velocity targetspeed toc(t0) currentPOS targetposition];  %is cPOS the amount of overall rounds of the motor?
    
    if(printout == 1)
        fprintf(mprofile,'%6.1u %6.1u %6.3f %6.1u %6.1u\n', A);
    else
        fprintf('%6.1u %6.1u %6.3f %6.1u %6.1u\n', A);
    end
    
    %change to position control i.e.
    threshold.speed = 100;      %count only for the following if loop
                                % this functions as a minimum speed which
                                % has to undergone to rach the breakpoint
    threshold.position = targetposition*0.98; %why factor 0.95 ? accommodate für decelleration? -> WRONG!
      
    %this stops only matlab from recording when threshold speed and position is
    %reached, the motor itself stops on its own when his targetpos is reached!
    if(velocity <= threshold.speed && currentPOS > threshold.position)% || test == 7
        fprintf(belt,'V0\n');       %stop belt?
        fprintf(belt,'POS\n');
        output.ref = str2double(fscanf(belt));  %what is output.ref?
        output.t1 = toc(t0);
        fclose(mprofile);
        break
    end
end

%   move back to starting  position...
    fprintf(belt,'SP%i\n LA%i\n M\n', [2550, 0]);

fclose(belt);


x=load(data_name);

% noNaNrow=find(x(:,4) >1, 1);  %cutoff NaN at the start
% x=x(noNaNrow:end,:)

xsize=size(x);
stimduration=x(end,3)-x(1,3)  %returns the duration of the whole procedure
% beltvel=beltperimeter./stimduration; %takes the whole duration into account (with acceleration and deceleration!)
% CMStoRPM=targetspeed/beltvel  %what metric is 'speed' ?

%how constant ist the velocity?
for n=1:length(x)-1
    x(n+1,6)= x(n+1,4)-x(n,4); %moved distance between timepoint
    x(n+1,7)= x(n+1,3)-x(n,3); %timedistance between timepoints
    x(n,8)= (x(n,6)./15000)./(x(n,7)./300); %actual speed (but what metric?)
end

theoreticalDuration = (abs(targetposition/15000))./(targetspeed/300);
durationQuotient = stimduration./theoreticalDuration

durationAggregate(subject) = stimduration;
meanDuration= mean(durationAggregate(durationAggregate>0))

%clear durationAggregate



plot(x(:,4),x(:,8), '-g') %plot ~speed at each distance
% hold on
% plot(x2550(:,4),x2550(:,8), '-cyan') %plot ~speed at each distance
% plot(x1800(:,4),x1800(:,8), '-blue') %plot ~speed at each distance
% plot(x4800(:,4),x4800(:,8), '-red') %plot ~speed at each distance
% hold off
subject = subject+1;