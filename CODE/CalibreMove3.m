function answer = CalibreMove3(LR, SP, p1, ISI, LA0)
%(write comments)

if(LA0 == 1)
    fprintf(p1,'LA%i\n M\n', 0);
end

for interval = 1:2
    if(ISI == 1)
        waitforbuttonpress;
    end
    
    if(interval == 2)
        %pause(ISI);
        LR = LR*-1;
    end
    
    %Move (pause for safety) [check if  M is necessary in Velocity control]
    fprintf(p1,'LR%i\n SP%i\n AC%i\n', [LR SP 30000]);
    pause(1)
    
    fprintf(p1,'M\n');
    
end

%answer = all_vals;
answer = 0;