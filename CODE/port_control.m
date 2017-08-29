function isOpen = port_control(Open, port)

%the following is to find a serial port
%out = instrfindall
%instrhwinfo('serial') 

if(Open == 1)
    fopen(port);
    isOpen = 1;
else
    fclose(port);
    delete(port);
    clear port;
    isOpen = 0;
end
