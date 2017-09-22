%same as 'correctCollumn' but for answer tendency
PilotControlFile   = 'felix_pilot_control_170921_1_responses.mat';
PilotTractorFile   = 'pilot_felix_170915_1_responses.mat';

outputPilotControl= fullfile('C:\Users\CecileScotto\Documents\MATLAB\Alessandro\DATA\Pilot', PilotControlFile);
load(outputPilotControl);   % not: load('File')
outputPilotControl = output;
outputPilotTractor= fullfile('C:\Users\CecileScotto\Documents\MATLAB\Alessandro\DATA\Pilot', PilotTractorFile);
load(outputPilotTractor);   % not: load('File')
outputPilotTractor = output;


%%control pilot
%outputPilotControl=output;
if length(outputPilotControl) ==341      %cut irregular output files
    outputPilotControl=outputPilotControl(6:end,:);
end
    
swichedAnswerCollumn=ones(length(outputPilotControl),1)*1000;

for k = 1:length(outputPilotControl)
    if outputPilotControl(k,7)==0
        swichedAnswerCollumn(k)=outputPilotControl(k,9);
    end
    if outputPilotControl(k,7)==1        %change answer 2 to 1, and 1 to 2
        if outputPilotControl(k,9) == 1
            swichedAnswerCollumn(k)=2;
        end
        if outputPilotControl(k,9) == 2
            swichedAnswerCollumn(k)=1;
        end
    end
end

outputPilotControl(1:k,10) = swichedAnswerCollumn;

speedIndex = 300:750:4800;
for s = 1:length(speedIndex)
    trialIndex = find(outputPilotControl(:,4)==speedIndex(s));       
    meanAnswerControl(s) = mean(outputPilotControl(trialIndex,10)); 
end 
 
meanAnswerControl=meanAnswerControl-1;
%% tractor pilot
%outputPilotTractor=output;
if length(outputPilotTractor) ==341      %cut irregular output files
    outputPilotTractor=outputPilotTractor(6:end,:);
end
    
swichedAnswerCollumn=ones(length(outputPilotTractor),1)*1000;

for k = 1:length(outputPilotTractor)
    if outputPilotTractor(k,7)==0
        swichedAnswerCollumn(k)=outputPilotTractor(k,9);
    end
    if outputPilotTractor(k,7)==1        %change answer 2 to 1, and 1 to 2
        if outputPilotTractor(k,9) == 1
            swichedAnswerCollumn(k)=2;
        end
        if outputPilotTractor(k,9) == 2
            swichedAnswerCollumn(k)=1;
        end
    end
end

outputPilotTractor(1:k,10) = swichedAnswerCollumn;

speedIndex = 300:750:4800;
for s = 1:length(speedIndex)
    trialIndex = find(outputPilotTractor(:,4)==speedIndex(s));       
    meanAnswerTractor(s) = mean(outputPilotTractor(trialIndex,10)); 
end 
 
meanAnswerTractor=meanAnswerTractor-1;

%% plots
figure
plot(speedIndex,meanAnswerControl)
hold on 
ylim([0 1])
%xlim([300 4800])
plot(speedIndex,meanAnswerTractor)
ylim([0 1])
%xlim([300 4800])
title('pilot tractor and control condition results')
xlabel('comparison speed')
ylabel('was comparison speed faster than standard stimulus?')
hold off
legend('pilot control','pilot tractor')
