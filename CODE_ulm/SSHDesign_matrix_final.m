function desmat = SSHDesign_matrix_final()
%edited by felix to include 3 different amplitude conditions 21.09.2017
%results in 674 trials

%7 different speeds from 300 to 1800 in 250's steps
allSP = 300:250:1800;

allLR = [1 2 3 4];       %relative desired position (as different cases)

%Warning: vibration amplitude also depends on the audio volume on the PC
%allVA = [1 2 3];   %amplitude condition: 1= both intervals full amplitude,
                % 2= both intervals zero amplitude (control)
                % 3= one interval full, one interval zero amplitude(mixed)
allVA = [1 2 3 ]  ; %pilot test with only full and DOUBLE mixed condition!
rfirst = [0 1];
direction = [-1 1];

OnlyOnce = combvec(allSP, allLR, allVA, rfirst, direction)';
N = length(OnlyOnce);

%different cases for distances within a trial
for nrow = 1:N
    %select the condition
    switch OnlyOnce(nrow,2)
        case(1)
            OnlyOnce(nrow,6) = 12000; %replace with LR equal to 5 and 14 mm ->only temporary?
            OnlyOnce(nrow,7) = 12000;
        case(2)
            OnlyOnce(nrow,6) = 6000;
            OnlyOnce(nrow,7) = 6000;
        case(3)
            OnlyOnce(nrow,6) = 12000;
            OnlyOnce(nrow,7) = 6000;
        case(4)             % case 4 was missing!? 
            %i.e. mixed distance trials always had long distance for reference!
            OnlyOnce(nrow,6) = 6000;
            OnlyOnce(nrow,7) = 12000;
            
    end
end

%different cases for vibration within a trial, 
%% pilot test with only full and DOUBLE mixed condition!
for nrow = 1:N
    %select the condition
    switch OnlyOnce(nrow,3)
        case(1)     %full amplitude trial
            OnlyOnce(nrow,11) = 0; 
            OnlyOnce(nrow,12) = 0;
        case(2)     % control trial
            OnlyOnce(nrow,11) = 0;
            OnlyOnce(nrow,12) = 1;
        case(3)     % mixed trial
            OnlyOnce(nrow,11) = 1;
            OnlyOnce(nrow,12) = 0;
    end
end

OnlyOnce(1:N,6) = bsxfun(@times, OnlyOnce(1:N,6), OnlyOnce(1:N,5)); % multiplies the desired LR distance
OnlyOnce(1:N,7) = -bsxfun(@times, OnlyOnce(1:N,7), OnlyOnce(1:N,5));% with direction (-1 or 1)
OnlyOnce(1:N,8) = repmat(median(allSP),N, 1);  % sets the speed of the comparion stimulus (2550)
OnlyOnce(1:N,9) = OnlyOnce(1:N,8);         % !!!frequncies are now same as speeds!!!
OnlyOnce(1:N,10) = OnlyOnce(1:N,1);

desmat = repmat(OnlyOnce(1:N, [6:7 8 1 9:10 11 12 4]), 2, 1); % same stuff in different order?
%desmat [LR1, LR2, SP(comparision stimulus), SP(exp stimulus),...
%       VibrFreq1, VibrFreq2, VibrAmp1, VibrAmp2, rfirst(order)]
% note: VibrFreq1+2 no longer relevant, the freqs are contained in the soundfiles!

% example output desmat:
% [12000,-12000,1600,2900,100,100,2,2,0]