function EVCSim = setEVCSimParameters(EVCSim, params, varargin)

import EVC.*;
import EVC.DDM.*;

if(isempty(varargin))
   sim = []; 
else
   sim = varargin{1}; 
end
            
% set control efficacy
for i = 1:length(EVCSim.DDMProcesses)
    if(EVCSim.DDMProcesses(i).input.type == DDMFnc.INTENSITY2DDM_EFFICACY)
        EVCSim.DDMProcesses(i).input.params{4} = params.controlEfficacy;
    end
end

% set control implementation cost
EVCSim.defaultCostFnc.params{1} = params.implementationCost;

% % set control reconfiguration cost
EVCSim.reconfCostFnc.params{1} = params.reconfigurationCost;

% set reward sensitivity
EVCSim.rewardFnc.params{3} = params.rewardSensitivity;

% set target response weight
if(isempty(sim))
    for i = 1:length(EVCSim.trials)
       EVCSim.trials(i).stimRespMap(2) = params.targetResponseWeight;
    end
else
    switch sim
        case 'task switching'
            EVCSim.trials(1).stimRespMap(1) = params.targetResponseWeight;
            EVCSim.trials(2).stimRespMap(1) = params.targetResponseWeight;
            EVCSim.trials(3).stimRespMap(4) = params.targetResponseWeight;
            EVCSim.trials(4).stimRespMap(4) = params.targetResponseWeight;
        case 'COGED'
            EVCSim.trials(1).stimRespMap(1) = params.targetResponseWeight;
            EVCSim.trials(2).stimRespMap(end) = params.targetResponseWeight;
    end
end

% set learning rate
EVCSim.learningFnc(1).params{1} = params.learningRate;

% set expected task difficulty
if(isfield(params, 'expectedTaskDifficulty'))
        temp.noiseFnc.type = DDMFnc.ACTUAL_EXPECTED;
        temp.noiseFnc.params{1} = EVCSim.defaultDDMParams.c;
        temp.noiseFnc.params{2} = EVCSim.defaultDDMParams.c * params.expectedTaskDifficulty;
        temp.noiseFnc = DDMFnc(temp.noiseFnc.type, ...
                                            temp.noiseFnc.params);
        temp.noiseProcess = DDMProc(DDMProc.ACTUAL_EXPECTED, ...                  % default controlled DDM process 
                                                    DDMProc.NOISE, ...
                                                    temp.noiseFnc);
        EVCSim.DDMProcesses(end+1) =   temp.noiseProcess;   
end

% diminished utility
if(isfield(params, 'diminishedUtility') && isfield(params, 'utilityScalar'))
    EVCSim.rewardFnc.type = EVCFnc.REWRATE_LOGVAL;
    EVCSim.rewardFnc.params{3} = params.utilityScalar;
    EVCSim.rewardFnc.params{4} = params.diminishedUtility;
end

if(isfield(params, 'rewardMagnitude'))
    EVCSim.rewardFnc.params{4} = EVCSim.rewardFnc.params{4} * params.rewardMagnitude;
end
end