amp=10; 
fs=20500;  % sampling frequency
duration=10;
freq=100;
values=0:(1/fs):duration;
a=amp*sin(2*pi* freq*values);
sound(a)

b = puresound(100, 4, 2);

tic
c = envelope_vibro(100, 4, 0, 30, 2, 1);
toc
%puresound starts after the belt has start moving and last as much as the
%motion duration. such as
% while(1)
%     
%     %in speed control mode?
%     movebelt();
%     
%     if speed > 0
%        b = puresound(100, x);
%     end
%
%     %or stop the belt if ot using a while
%     break
% end
