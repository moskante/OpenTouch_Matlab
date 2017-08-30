desmat = TSFdesign_matrix(1, 0.5);
AFhome();

%rep = max(size(desmat));
rep = 70;

%AM on 04.03.2015
%check that acceleration and speed threshold is the actual value for the
%exeperiment
for k = 1:rep
    out = TFScalibrate(desmat(k,2), desmat(k,1), 700, 1, 1); 
    pause(1)
end