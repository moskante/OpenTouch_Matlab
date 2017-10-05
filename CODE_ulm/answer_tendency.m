%same as 'correctCollumn' but for answer tendency
% PilotControlFile   = 'felix_pilot_control_170921_1_responses.mat';
% PilotTractorFile   = 'pilot_felix_170915_1_responses.mat';
PilotNewSpeedFile   = 'felix_pilot_2_170926_1_responses.mat';

PilotNewSpeedFile2 = 'felix_pilot_2_171003_2_responses.mat';
PilotNewSpeedFile3 = 'felix_pilot_2_171004_3_responses.mat';

outputPilot2Block1= fullfile('C:\Users\CecileScotto\Documents\MATLAB\Alessandro\DATA\Pilot 2', PilotNewSpeedFile);
load(outputPilot2Block1);   % not: load('File')
outputPilot2Block1 = output;
clear output;

outputPilot2Block2_3 = fullfile('C:\Users\CecileScotto\Documents\MATLAB\Alessandro\DATA\Pilot 2', PilotNewSpeedFile2);
load(outputPilot2Block2_3);   % not: load('File')
outputPilot2Block2_3 = output;
clear output;

outputPilot2Block3 = fullfile('C:\Users\CecileScotto\Documents\MATLAB\Alessandro\DATA\Pilot 2', PilotNewSpeedFile3);
load(outputPilot2Block3);   % not: load('File')
outputPilot2Block3 = output;
clear output;

%% cutout training trials
if length(outputPilot2Block1) ==341 || length(outputPilot2Block1) ==173     %cut irregular output files (training trials)
    outputPilot2Block1=outputPilot2Block1(6:end,:);
end
if length(outputPilot2Block2_3) ==341 || length(outputPilot2Block2_3) ==173     %cut irregular output files (training trials)
    outputPilot2Block2_3=outputPilot2Block2_3(6:end,:);
end
if length(outputPilot2Block3) ==341 || length(outputPilot2Block2_3) ==173     %cut irregular output files (training trials)
    outputPilot2Block3=outputPilot2Block3(6:end,:);
end

%% combine blocks
outputPilot2combined = [outputPilot2Block1;outputPilot2Block2_3;outputPilot2Block3];

%% generate swiched Answer Collumn
swichedAnswerCollumn=ones(length(outputPilot2combined),1)*1000;
for k = 1:length(outputPilot2combined)
    if outputPilot2combined(k,7)==0
        swichedAnswerCollumn(k)=outputPilot2combined(k,9);
    end
    if outputPilot2combined(k,7)==1        %change answer 2 to 1, and 1 to 2
        if outputPilot2combined(k,9) == 1
            swichedAnswerCollumn(k)=2;
        end
        if outputPilot2combined(k,9) == 2
            swichedAnswerCollumn(k)=1;
        end
    end
end
outputPilot2combined(1:k,10) = swichedAnswerCollumn;

%% sort blocks into each tractor condition (control vs mixed vs full tractor)
controlAmplitudeIndex =find ((outputPilot2combined(:,5)+outputPilot2combined(:,6))==0) ;
outputPilot2controlAmplitude = outputPilot2combined(controlAmplitudeIndex,:);

mixedAmplitudeIndex =find ((outputPilot2combined(:,5)+outputPilot2combined(:,6))==1) ;
outputPilot2mixedAmplitude =outputPilot2combined(mixedAmplitudeIndex,:);

fullAmplitudeIndex =find ((outputPilot2combined(:,5)+outputPilot2combined(:,6))==2) ;
outputPilot2fullAmplitude = outputPilot2combined(fullAmplitudeIndex,:);

%% mean answer for each speed
% control amplitude
speedIndex = 300:250:1800;  %new slower speeds 300-1800
for s = 1:length(speedIndex)
    trialIndexA = find(outputPilot2controlAmplitude(:,4)==speedIndex(s));       
    meanAnswerPilot2control(s) = mean(outputPilot2controlAmplitude(trialIndexA,10)); 
end 
meanAnswerPilot2control=meanAnswerPilot2control-1;
%mixed amplitude
for v = 1:length(speedIndex)
    trialIndexB = find(outputPilot2mixedAmplitude(:,4)==speedIndex(v));       
    meanAnswerPilot2mixed(v) = mean(outputPilot2mixedAmplitude(trialIndexB,10)); 
end 
meanAnswerPilot2mixed=meanAnswerPilot2mixed-1;
% full amplitude
for u = 1:length(speedIndex)
    trialIndexC = find(outputPilot2fullAmplitude(:,4)==speedIndex(u));       
    meanAnswerPilot2full(u) = mean(outputPilot2fullAmplitude(trialIndexC,10)); 
end 
meanAnswerPilot2full=meanAnswerPilot2full-1;

%% mixed amplitude differentiation
mixedStandardVibration=outputPilot2mixedAmplitude(find (outputPilot2mixedAmplitude(:,5)==1),:);
mixedComparisonVibration=outputPilot2mixedAmplitude(find (outputPilot2mixedAmplitude(:,5)==0),:);

%mixed amplitude standard stimulus has vibration
for v = 1:length(speedIndex)
    trialIndexStandard = find(mixedStandardVibration(:,4)==speedIndex(v));       
    meanAnswerPilot2mixedStandard(v) = mean(mixedStandardVibration(trialIndexStandard,10)); 
end 
meanAnswerPilot2mixedStandard=meanAnswerPilot2mixedStandard-1;

%mixed amplitude comparision stimulus has vibration
for w = 1:length(speedIndex)
    trialIndexComparison = find(mixedComparisonVibration(:,4)==speedIndex(w));       
    meanAnswerPilot2mixedComparison(w) = mean(mixedComparisonVibration(trialIndexComparison,10)); 
end 
meanAnswerPilot2mixedComparison=meanAnswerPilot2mixedComparison-1;



%% plots
figure
plot(speedIndex,meanAnswerPilot2control,'-ob')   %blue=control
hold on 
plot(speedIndex,meanAnswerPilot2mixedStandard,'-og')     %green=mixed
plot(speedIndex,meanAnswerPilot2mixedComparison,'-oc')  %cyan
plot(speedIndex,meanAnswerPilot2full,'-or')      %red=full amp
ylim([0 1])
xlim([200 1900])
% plot(speedIndex,meanAnswerTractor)
% ylim([0 1])
%xlim([300 4800])
title('pilot2 (new speeds) all conditions results')
xlabel('comparison speed')
ylabel('was comparison speed faster than standard stimulus?')
hold off
legend('no vibration (control)','only standard stimulus vibration','only comparison stimulus vibration','both intervals vibration')
