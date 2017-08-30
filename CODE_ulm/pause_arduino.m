%Function pause_arduino make a pause (blocking!) for a time interval equal
%to interval and read the voltage specified by aruino_board/pin and write
%it to an output file.
%interval: time interval in seconds
%arduino_board: an arduino object
%pin: the pin to read
%fileout: serial object to write on.
%
%Example
%myresults = fopen('test.txt', 'wt');
%uno = arduino('COM4', 'uno')
%test = pause_arduino(2, uno, 'A3', myresults)
%fclose(myresults)
%clear all

function [out] = pause_arduino(interval, arduino_board, pin, serial_id)
myformat = '%4f\t %4f\n';   

%Start the stopwatch timer
tstart = tic;

%enter the main loop
while(1)
    %read serial port
    voltage = readVoltage(arduino_board, pin);
    
    %save current time
    ti = toc(tstart);
    
    %output to serial object serial_id
    fprintf(serial_id, myformat, [voltage ti]);
    
    if(ti >= interval)
        break;
    end
end
        
out = ti;
