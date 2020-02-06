%% run DDM

drift = 0.08927999999999997;
ddmp.z = 0.2645;
bias = 0.5;
ddmp.c = 0.5;
ddmp.T0 = 0.15;

[meanERs,meanRTs,~,condRTs,condVarRTs, condSkewRTs] = EVC.DDM.AS_ddmSimFRG_Mat(drift,bias,ddmp,1);
meanERs