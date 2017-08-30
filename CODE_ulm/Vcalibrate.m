function answer = Vcalibrate(duration, max_vel, ramp)

%10000 ca 0.53 cm
%to do: add a tic toc
p1 = serial('/dev/cu.usbserial-ftEGHNL6','BaudRate',57600);                %the port name depend on the platform
fopen(p1);

fprintf(p1,'POS\n');
output.s0 = str2double(fscanf(p1));
t0 = tic;

%first stroke
fprintf(p1,'SP%i\n', max_vel);
%fprintf(p1,'HD%i\n', 7);
%fprintf(p1,'DEV%i\n', max_vel);
%fprintf(p1,'MV%i\n', 200);
fprintf(p1,'AC%i\n', ramp);                                                
fprintf(p1,'V%i\n', max_vel);

dflag = 0;

%time loop
while(1)
    now = toc(t0);
    fprintf(p1,'gv\n');
    
    velocity = str2double(fscanf(p1));
    fprintf('%6.3f  %6.3f %1d\n', [velocity; now; dflag])

    if(now >= duration && dflag == 0)
        output.td = now;
        fprintf(p1,'POS\n');
        output.sd = str2double(fscanf(p1));
        
%         hi = 'n';
        fprintf(p1,'DEC%i\n', ramp);
        %fprintf(p1,'NV%i\n', 0);
        fprintf(p1,'M');
        
        
%         while(hi ~= 'v')
%             hi = fscanf(p1);
%             fprintf('%s\n', hi);
%             if(toc(t0) > 10)
%                 break
%             end
%         end
        
        dflag = 1;
        
    end
      
    if(velocity <= 100 && dflag == 1)
        fprintf(p1,'V%i\n', 0);
        fprintf(p1,'POS\n');
        output.sf = str2double(fscanf(p1));
        output.tf = toc(t0);
        break
    end
    
    %emergency exit
    if(now > 10)
        fprintf(p1,'V%i\n', 0);
        break
    end
end    

%answer = output;
answer = max_vel;

fclose(p1);
