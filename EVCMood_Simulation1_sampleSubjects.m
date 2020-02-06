
function EVCMood_Simulation1_sampleSubjects(nSubj, parameterName, parameterValues, varargin)

% EVCMood_Simulation1_sampleSubjects(20, 'ControlCost', [1 3]);
% EVCMood_Simulation1_sampleSubjects(20, 'Utility Discounting', [1 0.1]);
% EVCMood_Simulation1_sampleSubjects(20, 'Reward', [1 3]);
% EVCMood_Simulation1_sampleSubjects(20, 'Expected Task Difficulty', [1 2]);
% EVCMood_Simulation1_sampleSubjects(20, 'Expected Task Difficulty', [0.5 1]);
% EVCMood_Simulation1_sampleSubjects(20, 'Default', [1]);

%% PREPARE SIMULATION

% clear all;
close all;
% clc;
import Simulations.*;
import EVC.*;

logfile = 3;

if(isempty(varargin))
    
    % sample parameters
    EVCMood_parameterRange;

    params.controlEfficacy = rand * (max(UD_controlEfficacy) - min(UD_controlEfficacy)) + min(UD_controlEfficacy);
    params.implementationCost = rand * (max(UD_implementationCost) - min(UD_implementationCost)) + min(UD_implementationCost);
    params.reconfigurationCost = rand * (max(UD_reconfigurationCost) - min(UD_reconfigurationCost)) + min(UD_reconfigurationCost);
    params.rewardSensitivity = rand * (max(UD_rewardSensitivity) - min(UD_rewardSensitivity)) + min(UD_rewardSensitivity);
    params.targetResponseWeight = rand * (max(UD_targetResponseWeight) - min(UD_targetResponseWeight)) + min(UD_targetResponseWeight);
    params.learningRate = rand * (max(UD_learningRate) - min(UD_learningRate)) + min(UD_learningRate);
    params.diminishedUtility = rand * (max(UD_diminishedUtility) - min(UD_diminishedUtility)) + min(UD_diminishedUtility);
    params.utilityScalar = rand * (max(UD_utilityScalar) - min(UD_utilityScalar)) + min(UD_utilityScalar);
    params.expectedTaskDifficulty = rand * (max(UD_expectedTaskDifficulty) - min(UD_expectedTaskDifficulty)) + min(UD_expectedTaskDifficulty);
    params.rewardMagnitude = rand * (max(UD_rewardMagnitude) - min(UD_rewardMagnitude)) + min(UD_rewardMagnitude);

else
    params = varargin{1}; 
end

for paramIdx = 1:length(parameterValues)

%% GRATTON

EVCSim = DDM_Gratton();
CogSci2019_Gratton_params;
EVCSim.nSubj = nSubj;
EVCSim.printResults = 1;

switch(parameterName)
    case 'Default'
    case 'ControlCost'
        params.implementationCost = parameterValues(paramIdx);
    case 'Expected Task Difficulty'
        params.expectedTaskDifficulty = parameterValues(paramIdx); 
    case 'Utility Discounting'
        params.diminishedUtility = parameterValues(paramIdx); 
    case 'Reward'
        params.rewardMagnitude = parameterValues(paramIdx);     
    otherwise
        error('Could not recognize parameter name.');
end

EVCSim = setEVCSimParameters(EVCSim, params);
disp('GRATTON SIMULATION');
EVCSim.run();
printSimulationParameters(EVCSim);

EVCSimGratton = EVCSim;
RT = EVCSim.results.RT;
ER = EVCSim.results.ER;
RT_results(paramIdx).Gratton = EVCSim.results.RT;
ER_results(paramIdx).Gratton = EVCSim.results.ER;
RT_results(paramIdx).Gratton.overallPerformance = EVCSim.results.meanRT;
RT_results(paramIdx).Gratton.congruencyEffect = mean(RT.congrEffect);
RT_results(paramIdx).Gratton.congruencySequenceEffect = mean(RT.adaptEffect);
ER_results(paramIdx).Gratton.overallPerformance = EVCSim.results.meanER;
ER_results(paramIdx).Gratton.congruencyEffect = mean(ER.congrEffect);
ER_results(paramIdx).Gratton.congruencySequenceEffect = mean(ER.adaptEffect);
results(paramIdx).Gratton.meanIntensity = mean(EVCSim.results.targetIntensity.mean);

disp(['PERFORMANCE: ' num2str(mean(ER_results(paramIdx).Gratton.overallPerformance))]);
disp(['COGRUENCY EFFECT: ' num2str(mean(RT_results(paramIdx).Gratton.congruencyEffect))]);
disp(['CONGRUENCY SEQUENCE EFFECT: ' num2str(mean(RT_results(paramIdx).Gratton.congruencySequenceEffect))]);



%% TASK SWITCHING

EVCSim = DDM_Goschke();
EVCSim.nTrials = 144;
CogSci2019_TaskSwitching_params;
EVCSim = setEVCSimParameters(EVCSim, params, 'task switching');
EVCSim.nSubj = nSubj;
EVCSim.printResults = 1;

disp('TASK SWITCHING');
EVCSim.run();
printSimulationParameters(EVCSim);

EVCSimTaskSwitching = EVCSim;
RT_results(paramIdx).Goschke = EVCSim.results.RT;
ER_results(paramIdx).Goschke = EVCSim.results.ER;
RT_results(paramIdx).Goschke.switchCost = EVCSim.results.RT.switch - EVCSim.results.RT.rep;
ER_results(paramIdx).Goschke.switchCost = EVCSim.results.ER.switch - EVCSim.results.ER.rep;
results(paramIdx).Goschke.meanIntensity = mean(EVCSim.results.targetIntensity.mean);

disp(['SWITCH COST, RT: ' num2str(mean(RT_results(paramIdx).Goschke.switchCost)) ', ER: ' num2str(mean(ER_results(paramIdx).Goschke.switchCost))]);

end

filePath = ['EVCMood logfiles/EVCMood_sampleSubjects_' parameterName '_s' num2str(nSubj) '_' num2str(logfile) ];
if(strcmp(parameterName, 'Expected Task Difficulty') && min(parameterValues) < 1)
    filePath = ['EVCMood logfiles/EVCMood_sampleSubjects_Low ' parameterName '_s' num2str(nSubj) '_' num2str(logfile) ];
end
disp(filePath)
save(filePath);

end


