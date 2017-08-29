function desmat = SSHDesign_matrix()
%AM21.07.2017 Check: 4 repetition per stimulus?
allSP = 30:67:300;
allLR = [1 2 3];
allVA = [0.0 0.5 1.0];
rfirst = [0 1];
direction = [-1 1];

OnlyOnce = combvec(allSP, allLR, allVA, rfirst, direction)';
N = length(OnlyOnce);

for nrow = 1:N
    %select the condition    
    switch OnlyOnce(nrow,2)
    case(1)
        OnlyOnce(nrow,6) = 881;%replace with LR equal to 5 and 14 mm
        OnlyOnce(nrow,7) = 881;%AM: actually, 881 = 5.7 mm
    case(2)
        OnlyOnce(nrow,6) = 2243;
        OnlyOnce(nrow,7) = 2243;
    case(3)
        OnlyOnce(nrow,6) = 881;
        OnlyOnce(nrow,7) = 2243;
    end
end

OnlyOnce(1:N,6) = bsxfun(@times, OnlyOnce(1:N,6), OnlyOnce(1:N,5));
OnlyOnce(1:N,7) = -bsxfun(@times, OnlyOnce(1:N,7), OnlyOnce(1:N,5));
OnlyOnce(1:N,8) = repmat(median(allSP),N, 1);
OnlyOnce(1:N,9:10) = repmat(100,N, 2);

desmat = repmat(OnlyOnce(1:N, [6:7 8 1 9:10 3 3 4]), 2, 1);