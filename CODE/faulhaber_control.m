function isOpen = faulhaber_control(Open, port, STEPMOD, STW, STN)

%the following is to find a serial port
%out = instrfindall
%instrhwinfo('serial') 

if(Open == 1)
    fopen(port);
    isOpen = 1;
    
    %preset and move to LA0
    fprintf(port,'EN\n ANSW2\n SP%i\n AC%i\n LA0\n M\n', [100 30000]);
    pause(5)%long pause to open serial port
    
    %enable step mode
    if(STEPMOD == 1)
        fprintf(port,'STEPMOD\n STW%i\n STN%i\n', [STW STN]);
    else
        fprintf(port,'CONTMOD\n');
    end
else
    fclose(port);
    delete(port);
    clear port;
    isOpen = 0;
end
