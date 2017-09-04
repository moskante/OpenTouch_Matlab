function desmat = SSHDesign_matrix_FT()

%7 different speeds from 300 to 4800 in 750's steps
allSP = 300:750:4800;
%[300  1050   800  2550  3300  4050  4800];
allLR = [1 2 3];       %relative desired position (as different cases)

%Warning: vibration amplitude also depends on the audio volume on the PC
allVA = [1];   %final vibration amplitude multiplier 
rfirst = [0 1];
direction = [-1 1];

OnlyOnce = combvec(allSP, allLR, allVA, rfirst, direction)';
N = length(OnlyOnce);

for nrow = 1:N
    %select the condition    
    switch OnlyOnce(nrow,2)
    case(1)
        OnlyOnce(nrow,6) = 12000;%replace with LR equal to 5 and 14 mm ->only temporary?
        OnlyOnce(nrow,7) = 12000;
    case(2)
        OnlyOnce(nrow,6) = 6000;
        OnlyOnce(nrow,7) = 6000;
    case(3)
        OnlyOnce(nrow,6) = 12000;
        OnlyOnce(nrow,7) = 6000;
    end
end

OnlyOnce(1:N,6) = bsxfun(@times, OnlyOnce(1:N,6), OnlyOnce(1:N,5)); % multiplies the desired LR distance 
OnlyOnce(1:N,7) = -bsxfun(@times, OnlyOnce(1:N,7), OnlyOnce(1:N,5));% with direction (-1 or 1)
OnlyOnce(1:N,8) = repmat(median(allSP),N, 1);  % sets the speed of the comparion stimulus (1600)
OnlyOnce(1:N,9) = OnlyOnce(1:N,8);         % !!!frequncies are now same as speeds!!!
OnlyOnce(1:N,10) = OnlyOnce(1:N,1);

desmat = repmat(OnlyOnce(1:N, [6:7 8 1 9:10 3 3 4]), 2, 1); % same stuff in different order?
%desmat [LR1, LR2, SP(comparision stimulus), SP(exp stimulus),...
%       VibrFreq1, VibrFreq2, VibrAmp1, VibrAmp2, rfirst(order)]
% vibration amplitude is always constant within a trial (columns 7 and 8)!
% example output desmat:
% [12000,-12000,1600,2900,100,100,2,2,0]