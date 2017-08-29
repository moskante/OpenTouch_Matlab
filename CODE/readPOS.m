function [POS, LR] = readPOS(port, POS0, fileout)
%get motor position or relative displacement (if POS == 0)
% add time limit?
start = tic;
tolerance = 8;
fprintf(port,'POS\n');

while(1)    
    %fprintf(port,'POS\n');
    line2 = fgetl(port);
        %line2 = fscanf(port, '%s');
    POS = str2double(line2);
    timeout = toc(start);
    %fprintf(fileout, '%s\t %3.0f\t %3u\n', [line2 POS trial]);
    fprintf(fileout, '%s\n', line2);
    
    if(isnan(POS) == 0)
        LR = dist(POS0, POS);
        if(LR >= tolerance || POS0 == 0)
            if(POS0 > POS)
                LR = -LR;
            end
            break
        end
    else
        if(timeout > 20)
            POS = 999;
            LR = 999;
            break
        end
    end
    
end