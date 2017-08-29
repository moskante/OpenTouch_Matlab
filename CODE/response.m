function [islonger] = response()

% Record the mouse button press and RT
%22.02.2012 AM made it.

%sound(params.beep);
%disp('Press L or R button')

%tic
%[x, y, button] = ginput(1);
%toc
tstart = tic;
[x, y, button] = ginput(1);
tresp = toc(tstart);

if(button == 1)                         %transform the output in 0,1
    binary = 0;
else
    binary = 1;
end

islonger(1) = binary;
islonger(2) = tresp;
%islonger(2) = toc;