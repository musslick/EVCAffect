
T0 = 0.20;
c = 0.5; %0.3; 
thresh = 0.35; %0.25; 
rewardTaskA = 100;
rewardTaskB = 100;

% set trial number
EVCSim.nTrials = 144;

% set parameters
EVCSim.defaultDDMParams.T0 = T0; 
EVCSim.defaultDDMParams.c = c;
EVCSim.defaultDDMParams.thresh = thresh;

EVCSim.trials(1).outcomeValues = [rewardTaskA 0] ;
EVCSim.trials(2).outcomeValues = [rewardTaskA 0] ;
EVCSim.trials(3).outcomeValues = [0 rewardTaskB] ;
EVCSim.trials(4).outcomeValues = [0 rewardTaskB] ;
