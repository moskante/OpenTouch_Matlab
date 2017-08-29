p1 = serial('COM1','BaudRate',57600);

openFlag = port_control(1,p1);
fprintf(p1,'EN\n');
pause(1)

myLA = 200;
fprintf(p1,'SP%i\n LA%i\n M\n', [100 myLA]);

readPOS(p1, 2)

openFlag = port_control(0,p1);