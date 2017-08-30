function home = myHome()

tolerance = 10;
POS0 = 0;

%faulhaber
faulhaber = fopen('home_position.txt', 'wt+');

%open port connection and move to LA = 0
p1 = serial('COM8','BaudRate',57600);
faulhaber_control(1,p1,1,1,20000);

%set velocity to zero
fprintf(p1,'V0\n');

%control on reached position
[POS1, LR] = readPOS(p1, POS0, faulhaber);  
if(abs(POS1) > tolerance)
    fprintf('Warning: Home position not reached. Run the function again')
end

%close connection
faulhaber_control(0,p1,1,1,20000);

home = [POS1, LR];