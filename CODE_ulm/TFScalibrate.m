function answer = TFScalibrate(target, speed, ramp, printout, flag)

%Motion profile of the belt device, See EN_7000_05029.pdf for details on
%the Faulhaber Motot unit (Motor 3564K024B CS)
%Deceleration/Acceleration ramp: see , pag 42-45. Commands such as NP and
%NV do not work with this Matlab code.
%AM did it on 05.03.2014
%
%target: set the target relative position (LR). LR10000 ca 0.53 cm
%speed: set the target max speed
%ramp: acceleration ramp
%printout:  1 to print the motion profile on the output file 0 in the
%           Matlab workspace
%flag:  0 to enter in the deceleration ifelse (currently doesn't work)

p1 = serial('/dev/cu.usbserial-ftEGHNL6','BaudRate', 57600);                %the port name depend on the platform
%p1 = serial('/dev/tty.MCS78XX_Port0.0','BaudRate', 57600);

fopen(p1);
mprofile = fopen('mprofile.txt', 'a');

fprintf(p1,'POS\n');
output.start = str2double(fscanf(p1));
t0 = tic;

%equivalently:
%fprintf(p1,'AC%i\n LR%i\n SP%i\n M\n', [3000 415000 1000]);
%see also Sequence Programs, RS232 Manual Chap 6.
fprintf(p1,'AC%i\n', ramp);                                                
fprintf(p1,'LR%i\n', target);
fprintf(p1,'SP%i\n', speed);
fprintf(p1,'M\n');

while (1)
    
    %Deceleration (currently not working)
    fprintf(p1,'POS\n');
    cPOS = str2double(fscanf(p1));
    output.decPOS = target - ((speed^2)/(ramp));
    
    if(cPOS >= output.decPOS && flag == 0)
      fprintf(p1,'DEC%i\n', ramp);
      fprintf(p1,'M');
      output.tdec = toc(t0);
      flag = 1;
    end

    fprintf(p1,'gv\n');
    velocity = str2double(fscanf(p1));

    %printout to write the file
    A = [velocity; speed; toc(t0); cPOS; target; flag];
    
    if(printout == 1)
        fprintf(mprofile,'%6.1u %6.1u %6.3f %6.1u %6.1u %1u\n', A);
    else
        fprintf('%6.1u %6.1u %6.3f %6.1u %6.1u %1u\n', A);
    end
    
    %change to position control i.e.
    threshold.speed = 100;
    threshold.position = target*0.95;
    
    %this stop the motion when threshold speed and position is reached
    if(velocity <= threshold.speed && cPOS > threshold.position)
        fprintf(p1,'V0\n');
        fprintf(p1,'POS\n');
        output.ref = str2double(fscanf(p1));
        output.t1 = toc(t0);
        fclose(mprofile);
        break
    end
end

pause(1)

%back to home position                                                     
fprintf(p1,'LA%i\n', 0);
fprintf(p1,'SP%i\n', 3000);
fprintf(p1,'M\n');
pause(1);

while (1)
    fprintf(p1,'gv\n');
    velocity = str2double(fscanf(p1));

    if(velocity == 0);
       break
    end
end

answer = output;

fclose(p1);
