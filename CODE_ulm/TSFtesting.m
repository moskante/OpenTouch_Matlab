function answer = TSFtesting(ref, com, rfirst)

%Comparison of the patterned and smooth surface 
%12.03.2014 AM did it
%The function to move the motor twice. 
%The parameters ref and com are vectors [speed lr]. rfirst is a dummy (0,1)
%if rfirst == 1 then the reference is presented before the comparison.

%random shuffle ref and com
if(rfirst == 1)
    first.vel = ref;
    second.vel = com;
else
    first.vel = com;
    second.vel = ref;
end

%allocate space for response variables and initialize variables
position = zeros(1, 4);
vFlag = zeros(1, 2);

threshold.position1 = first.vel(2)*0.95;
threshold.position2 = second.vel(2)*0.95;
threshold.speed = 100;
threshold.ac = 700;

%open the port connection
p1 = serial('/dev/cu.usbserial-ftEGHNL6','BaudRate',57600);                %the port name depend on the platform
fopen(p1);

%data export
%mdata = fopen('mdata.txt', 'a');

%stop the motor
fprintf(p1,'V0\n');
fprintf(p1,'POS\n');
position(1) = str2double(fscanf(p1));

%first stroke
waitforbuttonpress;    
pause(0.5)

%change to position control i.e.
fprintf(p1,'AC%i\n', threshold.ac);
fprintf(p1,'SP%i\n', first.vel(1));
fprintf(p1,'LR%i\n', first.vel(2));
fprintf(p1,'M\n');

%ISI 1 (to be sure that started moving...)
pause(1);

%wait for v == 0 and report the position of refference
while (1)
    fprintf(p1,'POS\n');
    cPOS = str2double(fscanf(p1));
    
    fprintf(p1,'gv\n');
    velocity = str2double(fscanf(p1));
    
    A = [velocity; first.vel(1); cPOS; first.vel(2); vFlag(1)];
    %fprintf(mdata,'%6.1u %6.1u %6.1u %6.1u %1u\n', A);
    fprintf('%6.1u %6.1u %6.1u %6.1u %1u\n', A);
    
    %velocity flag: did the target velocity was reached?
    if(vFlag(1) == 0 && velocity == first.vel(1))
        vFlag(1) = 1;
    end
    
    if(velocity <= threshold.speed && cPOS > threshold.position1)
        fprintf(p1,'POS\n');
        position(2) = str2double(fscanf(p1));
        %output.t1 = toc(t0);
        %fclose(mprofile);
        break
    end 
end

%ISI 2
pause(0.5);                                                                %break duration between stimuli within one trial

%second stroke (subtract position(2)
pause(2)

fprintf(p1,'AC%i\n', threshold.ac);
fprintf(p1,'SP%i\n', second.vel(1));
fprintf(p1,'LR%i\n', second.vel(2));
fprintf(p1,'M\n');

%ISI 3
pause(1)

while (1)
    fprintf(p1,'POS\n');
    cPOS = str2double(fscanf(p1)) - position(2);
    
    fprintf(p1,'gv\n');
    velocity = str2double(fscanf(p1));
    
    %velocity flag: did the target velocity was reached?
    if(vFlag(2) == 0 && velocity == second.vel(1))
        vFlag(2) = 1;
    end
    
    A = [velocity; second.vel(1); cPOS; second.vel(2); vFlag(2)];
    %fprintf(mdata,'%6.1u %6.1u %6.1u %6.1u %1u\n', A);
    fprintf('%6.1u %6.1u %6.1u %6.1u %1u\n', A);
    
    if(velocity <= threshold.speed && cPOS > threshold.position2)
        fprintf(p1,'POS\n');
        
        %subtract the first displ.
        position(3) = str2double(fscanf(p1)) - position(2);
        %output.t1 = toc(t0);
        %fclose(mprofile);
        break
    end 
end

position(4) = sum(vFlag);
answer = position;

fclose(p1);
%fclose(mdata);

%AFmove([2000 166000], [500 103750], 0, tip.ref, tip.com, blank)
