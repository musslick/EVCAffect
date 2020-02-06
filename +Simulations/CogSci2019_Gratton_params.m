
T0 =  0.200;
c = 0.7000;
% thresh = 0.4; submitted
thresh = 0.8;
% wDistractor = 0.4; submitted
wDistractor = 0.385;
reward = 100;

wTarget = 0.3324; % gets overwritten

% set parameters
EVCSim.defaultDDMParams.T0 = T0; 
EVCSim.defaultDDMParams.c = c;
EVCSim.defaultDDMParams.thresh = thresh;

EVCSim.trials(1).stimRespMap   = [wDistractor 0;                                          % responding to stimulus 1 tends to produce second response by 100%
                                                     wTarget 0];                                         % responding to stimulus 2 tends to produce second outcome by 100%

EVCSim.trials(2).stimRespMap   = [0 wDistractor;                                          % responding to stimulus 1 tends to produce second response by 100%
                                                   wTarget 0];                                         % responding to stimulus 2 tends to produce second outcome by 100%


EVCSim.trials(1).outcomeValues(1) = reward;

