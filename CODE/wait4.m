function out = wait4(mean, sd, min, max)

%Function generating a random integer 
%Min and Max are minumum and maximum thresholds for number values for given
%random sample. 
%The random numbers are sampled from a gaussian distribution. 
%Alessandro and Colleen made this on 19/05/2017

delay = round(normrnd(mean, sd));

if delay <= min
   delay = min;
else
    if delay >= max
       delay = max;
    end
end

out = delay;